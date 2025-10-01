import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';

export async function GET(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url);
    const projectId = searchParams.get('projectId');

    if (!projectId) {
      return NextResponse.json(
        { error: 'Project ID required' },
        { status: 400 }
      );
    }

    // Get project and all scenes with their assets
    const { data: project } = await supabase
      .from('projects')
      .select('*')
      .eq('id', projectId)
      .single();

    const { data: scenes } = await supabase
      .from('scenes')
      .select(`
        *,
        audio_assets(*),
        video_assets(*),
        mixed_assets(*)
      `)
      .eq('project_id', projectId)
      .order('scene_number');

    // Calculate production statistics
    const stats = {
      totalScenes: scenes?.length || 0,
      audioComplete: scenes?.filter(s => s.audio_assets?.[0]?.status === 'complete').length || 0,
      videoComplete: scenes?.filter(s => s.video_assets?.[0]?.status === 'complete').length || 0,
      mixedComplete: scenes?.filter(s => s.mixed_assets?.[0]?.status === 'complete').length || 0,
      audioProgress: 0,
      videoProgress: 0,
      mixedProgress: 0,
      overallProgress: 0
    };

    stats.audioProgress = (stats.audioComplete / stats.totalScenes) * 100;
    stats.videoProgress = (stats.videoComplete / stats.totalScenes) * 100;
    stats.mixedProgress = (stats.mixedComplete / stats.totalScenes) * 100;
    stats.overallProgress = (stats.audioProgress + stats.videoProgress + stats.mixedProgress) / 3;

    return NextResponse.json({
      project,
      stats,
      currentPhase: 
        stats.mixedProgress === 100 ? 'complete' :
        stats.videoProgress === 100 ? 'mixing' :
        stats.audioProgress === 100 ? 'video' : 'audio'
    });
  } catch (error) {
    console.error('Production status error:', error);
    return NextResponse.json(
      { error: 'Failed to get production status' },
      { status: 500 }
    );
  }
}

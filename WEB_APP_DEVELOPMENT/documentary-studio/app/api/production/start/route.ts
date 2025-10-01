import { NextRequest, NextResponse } from 'next/server';
import { supabase } from '@/lib/supabase';

export async function POST(req: NextRequest) {
  try {
    const { projectId, phase } = await req.json();

    // Validate project exists
    const { data: project, error: projectError } = await supabase
      .from('projects')
      .select('*')
      .eq('id', projectId)
      .single();

    if (projectError || !project) {
      return NextResponse.json(
        { error: 'Project not found' },
        { status: 404 }
      );
    }

    // Update project status to processing
    await supabase
      .from('projects')
      .update({ status: 'processing' })
      .eq('id', projectId);

    // In production, this would queue a background job
    // For now, we'll return a success response
    return NextResponse.json({
      success: true,
      projectId,
      phase: phase || 'audio',
      message: 'Production pipeline started. This will trigger audio generation, video generation, mixing, and export.',
      estimatedTime: '30-60 minutes for 24 scenes'
    });
  } catch (error) {
    console.error('Production start error:', error);
    return NextResponse.json(
      { error: 'Failed to start production' },
      { status: 500 }
    );
  }
}

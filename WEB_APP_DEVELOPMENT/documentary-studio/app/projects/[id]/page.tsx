"use client"

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import { Toolbar } from '@/components/Toolbar';
import { ScriptPanel } from '@/components/ScriptPanel';
import { VideoPreview } from '@/components/VideoPreview';
import { Timeline } from '@/components/Timeline';
import { AgentPanel } from '@/components/AgentPanel';
import { supabase } from '@/lib/supabase';

interface Scene {
  id: string;
  sceneNumber: number;
  narrationText: string;
  thumbnailUrl?: string;
  status: 'pending' | 'processing' | 'complete';
}

export default function ProjectPage() {
  const params = useParams();
  const projectId = params.id as string;

  const [projectTitle, setProjectTitle] = useState('Loading...');
  const [script, setScript] = useState<string[]>([]);
  const [scenes, setScenes] = useState<Scene[]>([]);
  const [currentSceneIndex, setCurrentSceneIndex] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(239);
  const [isAgentOpen, setIsAgentOpen] = useState(false);
  const [videoUrl, setVideoUrl] = useState<string | null>(null);

  // Load project data from Supabase
  useEffect(() => {
    async function loadProject() {
      const { data: project } = await supabase
        .from('projects')
        .select('*')
        .eq('id', projectId)
        .single();

      if (project) {
        setProjectTitle(project.title);
        setScript(project.script.split('\n\n'));
      }

      const { data: scenesData } = await supabase
        .from('scenes')
        .select(`
          *,
          mixed_assets(url, status)
        `)
        .eq('project_id', projectId)
        .order('scene_number');

      if (scenesData) {
        const formattedScenes = scenesData.map((scene: any) => ({
          id: scene.id,
          sceneNumber: scene.scene_number,
          narrationText: scene.narration_text,
          thumbnailUrl: scene.mixed_assets?.[0]?.url,
          status: scene.mixed_assets?.[0]?.status || 'pending'
        }));
        setScenes(formattedScenes);
      }
    }

    loadProject();

    // Subscribe to real-time updates
    const channel = supabase
      .channel(`project-${projectId}`)
      .on('postgres_changes',
        { event: '*', schema: 'public', table: 'mixed_assets' },
        (payload) => {
          console.log('Asset updated:', payload);
          loadProject(); // Reload data when assets change
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [projectId]);

  const handleRegenerate = () => {
    console.log('Regenerate clicked');
  };

  const handleExport = () => {
    console.log('Export clicked');
  };

  const formatDuration = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="h-screen flex flex-col bg-gray-50">
      <Toolbar
        projectTitle={projectTitle}
        duration={formatDuration(duration)}
        onRegenerate={handleRegenerate}
        onExport={handleExport}
        onOpenAgent={() => setIsAgentOpen(true)}
      />

      <div className="flex-1 flex overflow-hidden">
        <div className="w-1/2 border-r border-gray-200">
          <ScriptPanel
            script={script}
            currentSceneIndex={currentSceneIndex}
            onSceneClick={setCurrentSceneIndex}
          />
        </div>

        <div className="w-1/2">
          <VideoPreview
            videoUrl={videoUrl}
            isPlaying={isPlaying}
            currentTime={currentTime}
            duration={duration}
            onTimeUpdate={setCurrentTime}
            onDurationChange={setDuration}
          />
        </div>
      </div>

      <Timeline
        scenes={scenes}
        currentSceneIndex={currentSceneIndex}
        isPlaying={isPlaying}
        currentTime={currentTime}
        duration={duration}
        onSceneClick={setCurrentSceneIndex}
        onPlayPause={() => setIsPlaying(!isPlaying)}
      />

      <AgentPanel
        isOpen={isAgentOpen}
        onClose={() => setIsAgentOpen(false)}
        projectId={projectId}
      />
    </div>
  );
}

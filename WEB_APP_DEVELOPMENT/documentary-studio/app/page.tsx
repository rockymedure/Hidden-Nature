"use client"

import { useState, useEffect } from 'react';
import { Toolbar } from '@/components/Toolbar';
import { ScriptPanel } from '@/components/ScriptPanel';
import { VideoPreview } from '@/components/VideoPreview';
import { Timeline } from '@/components/Timeline';
import { AgentPanel } from '@/components/AgentPanel';
import { Separator } from '@/components/ui/separator';

// Sample data - replace with actual Supabase data
const SAMPLE_SCRIPT = [
  "Before the first ray of sunlight touches Earth, leaves are already preparing - opening their pores, positioning for the day ahead.",
  "Four hundred million years ago, the first leaves appeared - simple green patches that would evolve into nature's most sophisticated solar panels.",
  "Every leaf breathes through millions of tiny mouths called stomata - opening and closing thirty thousand times each day.",
  "When attacked by insects, leaves instantly release chemical alarm signals - a botanical scream that warns the entire forest.",
  "Beneath our feet, fungal networks connect every leaf to every tree - a wood wide web sharing resources and information.",
  "In scorching deserts, succulent leaves have become water barrels - storing liquid treasures for months of drought.",
  "Desert leaves armor themselves with microscopic wax chimneys - tiny fortresses that guard every breathing pore.",
];

const SAMPLE_SCENES = Array.from({ length: 23 }, (_, i) => ({
  id: `scene-${i + 1}`,
  sceneNumber: i + 1,
  thumbnailUrl: i < 7 ? undefined : undefined, // We'll add actual thumbnails later
  status: i < 3 ? 'complete' as const : i < 5 ? 'processing' as const : 'pending' as const
}));

export default function DocumentaryStudio() {
  const [currentSceneIndex, setCurrentSceneIndex] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(239); // 3:59
  const [isAgentOpen, setIsAgentOpen] = useState(false);
  const [videoUrl, setVideoUrl] = useState<string | null>(null);

  const handleRegenerate = () => {
    console.log('Regenerate clicked');
    // TODO: Implement regeneration logic
  };

  const handleExport = () => {
    console.log('Export clicked');
    // TODO: Implement export logic
  };

  const formatDuration = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="h-screen flex flex-col bg-gray-50">
      {/* Toolbar */}
      <Toolbar
        projectTitle="Untitled project"
        duration={formatDuration(duration)}
        onRegenerate={handleRegenerate}
        onExport={handleExport}
        onOpenAgent={() => setIsAgentOpen(true)}
      />

      {/* Main content area: Script (50%) | Video (50%) */}
      <div className="flex-1 flex overflow-hidden">
        {/* Script Panel - 50% */}
        <div className="w-1/2 border-r border-gray-200">
          <ScriptPanel
            script={SAMPLE_SCRIPT}
            currentSceneIndex={currentSceneIndex}
            onSceneClick={setCurrentSceneIndex}
          />
        </div>

        {/* Video Preview - 50% */}
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

      {/* Timeline */}
      <Timeline
        scenes={SAMPLE_SCENES}
        currentSceneIndex={currentSceneIndex}
        isPlaying={isPlaying}
        currentTime={currentTime}
        duration={duration}
        onSceneClick={setCurrentSceneIndex}
        onPlayPause={() => setIsPlaying(!isPlaying)}
      />

      {/* Agent Panel (sliding overlay) */}
      <AgentPanel
        isOpen={isAgentOpen}
        onClose={() => setIsAgentOpen(false)}
        projectId="sample-project-id"
      />
    </div>
  );
}
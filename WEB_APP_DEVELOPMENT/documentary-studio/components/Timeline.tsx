"use client"

import { useEffect, useRef } from 'react';
import { Play, Pause, Volume2 } from 'lucide-react';
import { Button } from './ui/button';

interface Scene {
  id: string;
  sceneNumber: number;
  thumbnailUrl?: string;
  status: 'pending' | 'processing' | 'complete';
}

interface TimelineProps {
  scenes: Scene[];
  currentSceneIndex: number;
  isPlaying: boolean;
  currentTime: number;
  duration: number;
  onSceneClick: (index: number) => void;
  onPlayPause: () => void;
}

export function Timeline({
  scenes,
  currentSceneIndex,
  isPlaying,
  currentTime,
  duration,
  onSceneClick,
  onPlayPause
}: TimelineProps) {
  const timelineRef = useRef<HTMLDivElement>(null);

  // Auto-scroll to current scene
  useEffect(() => {
    if (timelineRef.current) {
      const sceneElements = timelineRef.current.querySelectorAll('[data-scene]');
      const currentSceneElement = sceneElements[currentSceneIndex];
      if (currentSceneElement) {
        currentSceneElement.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
      }
    }
  }, [currentSceneIndex]);

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="bg-[#1a1a1a] border-t border-gray-700">
      {/* Controls */}
      <div className="flex items-center gap-4 px-6 py-3 border-b border-gray-700">
        <Button 
          variant="ghost" 
          size="icon"
          onClick={onPlayPause}
          className="text-white hover:bg-gray-700"
        >
          {isPlaying ? <Pause className="h-5 w-5" /> : <Play className="h-5 w-5" />}
        </Button>
        
        <div className="flex items-center gap-2 text-sm text-gray-300">
          <span>{formatTime(currentTime)}</span>
          <span>/</span>
          <span>{formatTime(duration)}</span>
        </div>

        <div className="flex-1" />

        <div className="flex items-center gap-2">
          <Volume2 className="h-4 w-4 text-gray-400" />
          <input 
            type="range" 
            min="0" 
            max="100" 
            defaultValue="100"
            className="w-24 h-1 bg-gray-600 rounded-lg appearance-none cursor-pointer"
          />
        </div>
      </div>

      {/* Scene thumbnails */}
      <div 
        ref={timelineRef}
        className="flex gap-2 overflow-x-auto px-6 py-4 scrollbar-thin scrollbar-thumb-gray-600 scrollbar-track-gray-800"
      >
        {scenes.map((scene, index) => (
          <div
            key={scene.id}
            data-scene={index}
            onClick={() => onSceneClick(index)}
            className={`
              flex-shrink-0 w-32 h-20 rounded-lg cursor-pointer transition-all relative
              ${index === currentSceneIndex 
                ? 'ring-2 ring-blue-500 scale-105' 
                : 'ring-1 ring-gray-600 hover:ring-gray-400'}
              ${scene.status === 'complete' ? 'bg-gray-700' : 'bg-gray-800'}
            `}
          >
            {scene.thumbnailUrl ? (
              <img 
                src={scene.thumbnailUrl} 
                alt={`Scene ${scene.sceneNumber}`}
                className="w-full h-full object-cover rounded-lg"
              />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-gray-500 text-xs">
                {scene.status === 'processing' ? 'Processing...' : `Scene ${scene.sceneNumber}`}
              </div>
            )}
            
            {/* Scene number badge */}
            <div className="absolute top-1 left-1 bg-black/70 text-white text-xs px-1.5 py-0.5 rounded">
              {scene.sceneNumber}
            </div>

            {/* Status indicator */}
            {scene.status !== 'complete' && (
              <div className="absolute bottom-1 right-1">
                <div className={`w-2 h-2 rounded-full ${
                  scene.status === 'processing' ? 'bg-yellow-500 animate-pulse' : 'bg-gray-500'
                }`} />
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Waveform visualization placeholder */}
      <div className="px-6 pb-4">
        <div className="h-12 bg-gray-800 rounded-lg flex items-center justify-center text-gray-600 text-xs">
          Canopy Whisper
        </div>
      </div>
    </div>
  );
}

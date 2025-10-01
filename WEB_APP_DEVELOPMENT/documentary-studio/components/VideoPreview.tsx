"use client"

import { useRef, useEffect } from 'react';

interface VideoPreviewProps {
  videoUrl: string | null;
  isPlaying: boolean;
  currentTime: number;
  duration: number;
  onTimeUpdate: (time: number) => void;
  onDurationChange: (duration: number) => void;
}

export function VideoPreview({ 
  videoUrl, 
  isPlaying, 
  currentTime,
  duration,
  onTimeUpdate,
  onDurationChange
}: VideoPreviewProps) {
  const videoRef = useRef<HTMLVideoElement>(null);

  useEffect(() => {
    if (videoRef.current) {
      if (isPlaying) {
        videoRef.current.play();
      } else {
        videoRef.current.pause();
      }
    }
  }, [isPlaying]);

  return (
    <div className="h-full bg-[#0a0e27] flex items-center justify-center relative">
      {videoUrl ? (
        <video
          ref={videoRef}
          src={videoUrl}
          className="max-w-full max-h-full"
          onTimeUpdate={(e) => onTimeUpdate(e.currentTarget.currentTime)}
          onLoadedMetadata={(e) => onDurationChange(e.currentTarget.duration)}
        />
      ) : (
        <div className="text-gray-400 text-center">
          <div className="w-64 h-64 rounded-full bg-gradient-to-br from-cyan-400 to-blue-600 opacity-20 blur-3xl" />
          <p className="mt-4">No video loaded</p>
        </div>
      )}
    </div>
  );
}

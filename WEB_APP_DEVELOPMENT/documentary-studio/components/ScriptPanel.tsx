"use client"

import { useState } from 'react';

interface ScriptPanelProps {
  script: string[];
  currentSceneIndex: number;
  onSceneClick: (index: number) => void;
}

export function ScriptPanel({ script, currentSceneIndex, onSceneClick }: ScriptPanelProps) {
  return (
    <div className="h-full overflow-y-auto bg-white p-6 space-y-4">
      {script.map((paragraph, index) => (
        <div
          key={index}
          onClick={() => onSceneClick(index)}
          className={`
            p-4 rounded-lg cursor-pointer transition-all
            ${index === currentSceneIndex 
              ? 'bg-blue-50 border-2 border-blue-500' 
              : 'hover:bg-gray-50 border-2 border-transparent'}
          `}
        >
          <p className="text-gray-800 leading-relaxed">
            {paragraph}
          </p>
        </div>
      ))}
    </div>
  );
}

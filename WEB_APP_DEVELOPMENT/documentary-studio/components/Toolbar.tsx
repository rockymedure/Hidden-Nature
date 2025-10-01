"use client"

import { RefreshCw, Clock, Download, Sparkles } from 'lucide-react';
import { Button } from './ui/button';

interface ToolbarProps {
  projectTitle: string;
  duration: string;
  onRegenerate: () => void;
  onExport: () => void;
  onOpenAgent: () => void;
}

export function Toolbar({ projectTitle, duration, onRegenerate, onExport, onOpenAgent }: ToolbarProps) {
  return (
    <div className="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-6">
      {/* Left: Project title */}
      <div className="flex items-center gap-4">
        <h1 className="text-lg font-semibold text-gray-900">{projectTitle}</h1>
      </div>

      {/* Center: Controls */}
      <div className="flex items-center gap-3">
        <Button 
          variant="outline" 
          size="sm"
          onClick={onRegenerate}
          className="gap-2"
        >
          <RefreshCw className="h-4 w-4" />
          Regenerate
        </Button>

        <div className="flex items-center gap-2 px-3 py-1.5 bg-gray-100 rounded-md">
          <Clock className="h-4 w-4 text-gray-600" />
          <span className="text-sm font-medium text-gray-700">{duration}</span>
        </div>

        <Button 
          variant="outline" 
          size="sm"
          className="gap-2"
        >
          <Download className="h-4 w-4" />
        </Button>
      </div>

      {/* Right: Agent button */}
      <div>
        <Button 
          onClick={onOpenAgent}
          className="gap-2 bg-purple-600 hover:bg-purple-700"
        >
          <Sparkles className="h-4 w-4" />
          Assistant
        </Button>
      </div>
    </div>
  );
}

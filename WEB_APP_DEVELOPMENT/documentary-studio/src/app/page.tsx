export default function Home() {
  return (
    <div className="h-screen flex flex-col bg-gray-50">
      {/* Header */}
      <header className="h-16 bg-white border-b border-gray-200 flex items-center justify-between px-6">
        <div className="flex items-center gap-4">
          <h1 className="text-xl font-semibold text-gray-900">Documentary Studio</h1>
          <span className="text-sm text-gray-500">Untitled project</span>
        </div>
        <div className="flex items-center gap-3">
          <button className="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded-md">
            Share
          </button>
          <button className="px-4 py-2 text-sm font-medium text-white bg-black hover:bg-gray-800 rounded-md">
            Export
          </button>
          <button className="px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded-md">
            💬 Agent
          </button>
        </div>
      </header>

      {/* Main Content - 50/50 Split */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left Panel - Script (50%) */}
        <div className="w-1/2 border-r border-gray-200 bg-white overflow-y-auto">
          <div className="p-6 space-y-4">
            <div className="text-sm text-gray-600 mb-4">
              📝 Script
            </div>
            
            {/* Scene Blocks (matching mockup style) */}
            <div className="space-y-3">
              <div className="p-4 bg-blue-50 border-l-4 border-blue-500 rounded-r">
                <p className="text-sm text-gray-800 leading-relaxed">
                  "Before the first ray of sunlight touches Earth, leaves are already preparing - opening their pores, positioning for the day ahead."
                </p>
              </div>
              
              <div className="p-4 hover:bg-gray-50 border-l-4 border-transparent hover:border-gray-300 rounded-r">
                <p className="text-sm text-gray-800 leading-relaxed">
                  "Four hundred million years ago, the first leaves appeared - simple green patches that would evolve into nature's most sophisticated solar panels."
                </p>
              </div>
              
              <div className="p-4 hover:bg-gray-50 border-l-4 border-transparent hover:border-gray-300 rounded-r">
                <p className="text-sm text-gray-800 leading-relaxed">
                  "Every leaf breathes through millions of tiny mouths called stomata - opening and closing thirty thousand times each day."
                </p>
              </div>
              
              <div className="p-4 hover:bg-gray-50 border-l-4 border-transparent hover:border-gray-300 rounded-r">
                <p className="text-sm text-gray-800 leading-relaxed">
                  "When attacked by insects, leaves instantly release chemical alarm signals - a botanical scream that warns the entire forest."
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Right Panel - Video Preview (50%) */}
        <div className="w-1/2 bg-black flex items-center justify-center">
          <div className="text-center">
            <div className="w-full max-w-4xl aspect-video bg-gradient-to-br from-cyan-900 to-blue-950 rounded-lg flex items-center justify-center">
              <p className="text-gray-400 text-sm">Video Preview</p>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Timeline - Scene Chunks */}
      <div className="h-48 bg-gray-900 border-t border-gray-700">
        <div className="h-full flex flex-col">
          {/* Playback Controls */}
          <div className="flex items-center justify-center gap-4 py-3 border-b border-gray-700">
            <button className="w-8 h-8 flex items-center justify-center text-white hover:bg-gray-800 rounded">
              ⏮
            </button>
            <button className="w-10 h-10 flex items-center justify-center bg-white text-black rounded-full hover:bg-gray-200">
              ▶
            </button>
            <button className="w-8 h-8 flex items-center justify-center text-white hover:bg-gray-800 rounded">
              ⏭
            </button>
            <span className="text-white text-sm">0:00 / 3:59</span>
          </div>
          
          {/* Scene Timeline */}
          <div className="flex-1 overflow-x-auto">
            <div className="flex gap-1 p-2 min-w-max">
              {/* Scene Chunk Example */}
              {[1, 2, 3, 4, 5, 6, 7, 8].map((scene) => (
                <div key={scene} className="w-32 h-24 bg-gray-800 rounded border border-gray-700 hover:border-cyan-500 cursor-pointer flex flex-col">
                  <div className="flex-1 bg-gradient-to-b from-cyan-900/30 to-transparent p-2">
                    <div className="text-xs text-gray-400">Scene {scene}</div>
                    {/* Waveform placeholder */}
                    <div className="h-8 mt-1 flex items-end gap-0.5">
                      {[...Array(20)].map((_, i) => (
                        <div 
                          key={i} 
                          className="flex-1 bg-cyan-500/50"
                          style={{ height: `${Math.random() * 100}%` }}
                        />
                      ))}
                    </div>
                  </div>
                  <div className="px-2 py-1 bg-gray-900/50 flex gap-1 text-xs">
                    <span className="text-cyan-400">🎤</span>
                    <span className="text-purple-400">🎥</span>
                    <span className="text-green-400">🎵</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
          
          {/* Project Title */}
          <div className="px-4 py-2 border-t border-gray-700">
            <p className="text-sm text-gray-400">Canopy Whisper</p>
          </div>
        </div>
      </div>
    </div>
  );
}


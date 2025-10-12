#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎬 COMPILING FINAL DOCUMENTARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create scene list
> scene_list.txt
for scene in {1..24}; do
    MIXED_FILE="mixed/scene$(printf "%02d" $scene)_mixed.mp4"
    if [[ -f "$MIXED_FILE" ]]; then
        echo "file '$MIXED_FILE'" >> scene_list.txt
    else
        echo "⚠️  Warning: Scene $(printf "%02d" $scene) mixed file not found"
    fi
done

if [[ -s "scene_list.txt" ]]; then
    echo "📋 Playlist created with $(wc -l < scene_list.txt) scenes"
    echo ""
    echo "🎬 Concatenating all scenes..."
    ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "THE_PAINTED_REED_FROGS_DOUBLE_LIFE.mp4" 2>/dev/null
    
    if [[ -f "THE_PAINTED_REED_FROGS_DOUBLE_LIFE.mp4" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_PAINTED_REED_FROGS_DOUBLE_LIFE.mp4" | cut -d. -f1)
        filesize=$(ls -lh "THE_PAINTED_REED_FROGS_DOUBLE_LIFE.mp4" | awk '{print $5}')
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✨ DOCUMENTARY COMPLETE!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "📹 File: THE_PAINTED_REED_FROGS_DOUBLE_LIFE.mp4"
        echo "⏱️  Duration: $((duration / 60))m $((duration % 60))s"
        echo "📏 Size: $filesize"
        echo "📐 Format: 16:9 (1920x1080)"
        echo "🎬 Scenes: $(wc -l < scene_list.txt)"
        echo ""
        echo "✅ Ready for YouTube upload!"
    else
        echo "❌ Error: Final documentary not created."
    fi
else
    echo "❌ Error: No mixed scenes found!"
    echo "   Run mix_all_scenes.sh first"
fi

#!/bin/bash

echo "🎬 COMPILING FINAL MOBILE DOCUMENTARY (9:16)"
echo "⏭️  Starting from Scene 2 (Scene 1 skipped)"
echo ""

# Create playlist for scenes 2-26
> mobile_playlist.txt

scene_count=0
for scene in {2..26}; do
    MIXED_FILE="mobile/scene${scene}_mixed.mp4"
    if [[ -f "$MIXED_FILE" ]]; then
        echo "file 'mobile/scene${scene}_mixed.mp4'" >> mobile_playlist.txt
        ((scene_count++))
    else
        echo "⚠️  Warning: Scene $scene mixed file not found"
    fi
done

echo "📋 Playlist created with $scene_count scenes"
echo ""

if [[ $scene_count -eq 0 ]]; then
    echo "❌ Error: No mixed scenes found!"
    echo "   Run mix_mobile_scenes.sh first"
    exit 1
fi

# Compile final mobile documentary
echo "🎬 Concatenating all scenes..."
ffmpeg -y -f concat -safe 0 -i mobile_playlist.txt -c copy "THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4" 2>/dev/null

if [[ -f "THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4" | cut -d. -f1)
    filesize=$(ls -lh "THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4" | awk '{print $5}')
    minutes=$((duration / 60))
    seconds=$((duration % 60))
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ MOBILE DOCUMENTARY COMPLETE!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📱 File: THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4"
    echo "⏱️  Duration: ${minutes}m ${seconds}s"
    echo "📏 Size: $filesize"
    echo "📐 Format: 9:16 portrait (1080x1920)"
    echo "🎬 Scenes: $scene_count (scenes 2-26)"
    echo ""
    echo "✅ Ready for TikTok, Instagram Reels, YouTube Shorts!"
else
    echo "❌ Error: Compilation failed"
    exit 1
fi

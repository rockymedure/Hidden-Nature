#!/bin/bash

OUTPUT_FILE="THE_PAINTED_REED_FROGS_DOUBLE_LIFE_MOBILE_9x16.mp4"
PLAYLIST_FILE="mobile_playlist.txt"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📱 COMPILING FINAL MOBILE DOCUMENTARY (9:16)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

> "$PLAYLIST_FILE"
for i in {1..24}; do
    scene_num=$(printf "%02d" $i)
    MIXED_FILE="mixed/scene${scene_num}_mixed.mp4"
    if [[ -f "$MIXED_FILE" ]]; then
        echo "file '$MIXED_FILE'" >> "$PLAYLIST_FILE"
    else
        echo "⚠️  Warning: Scene $i mixed file not found: $MIXED_FILE"
    fi
done

if [[ -s "$PLAYLIST_FILE" ]]; then
    echo "📋 Playlist created with $(wc -l < "$PLAYLIST_FILE") scenes"
    echo ""
    echo "🎬 Concatenating all mobile scenes..."
    ffmpeg -y -f concat -safe 0 -i "$PLAYLIST_FILE" -c copy "$OUTPUT_FILE" 2>/dev/null
    
    if [[ -f "$OUTPUT_FILE" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT_FILE" | cut -d. -f1)
        filesize=$(ls -lh "$OUTPUT_FILE" | awk '{print $5}')
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✨ MOBILE DOCUMENTARY COMPLETE!"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "📱 File: $OUTPUT_FILE"
        echo "⏱️  Duration: $((duration / 60))m $((duration % 60))s"
        echo "📏 Size: $filesize"
        echo "📐 Format: 9:16 portrait (1080x1920)"
        echo "🎬 Scenes: $(wc -l < "$PLAYLIST_FILE")"
        echo ""
        echo "✅ Ready for TikTok, Instagram Reels, YouTube Shorts!"
        echo ""
    else
        echo "❌ Error: Final mobile documentary not created."
    fi
else
    echo "❌ Error: No mixed scenes found! Run mix_all_mobile_scenes.sh first."
fi


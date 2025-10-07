#!/bin/bash

echo "📱 DIATOM: Compiling Mobile Documentary (9:16)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create mobile playlist
> mobile_playlist.txt
for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24; do
    if [[ -f "mobile/scene${i}_mixed.mp4" ]]; then
        echo "file 'mobile/scene${i}_mixed.mp4'" >> mobile_playlist.txt
        echo "✅ Added scene $i to playlist"
    else
        echo "❌ Missing scene $i"
    fi
done

echo ""
echo "🎬 Concatenating all 24 mobile scenes..."

ffmpeg -y -f concat -safe 0 -i mobile_playlist.txt -c copy "DIATOM_LIVING_GLASS_ART_MOBILE_9x16.mp4" 2>/dev/null

if [[ -f "DIATOM_LIVING_GLASS_ART_MOBILE_9x16.mp4" ]]; then
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "DIATOM_LIVING_GLASS_ART_MOBILE_9x16.mp4")
    filesize=$(ls -lh "DIATOM_LIVING_GLASS_ART_MOBILE_9x16.mp4" | awk '{print $5}')
    minutes=$((${duration%.*} / 60))
    seconds=$((${duration%.*} % 60))
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ MOBILE DOCUMENTARY COMPLETE! ✨"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📊 Final Stats:"
    echo "   Duration: ${minutes}m ${seconds}s"
    echo "   File Size: $filesize"
    echo "   Aspect Ratio: 9:16 (Portrait)"
    echo "   Resolution: 1080x1920"
    echo "   Scenes: 24"
    echo ""
    echo "📱 Ready for Instagram/TikTok/YouTube Shorts!"
else
    echo "❌ Compilation failed"
fi


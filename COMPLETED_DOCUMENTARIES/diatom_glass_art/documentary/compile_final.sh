#!/bin/bash

echo "🎞️ DIATOM: Compiling Final Documentary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create playlist
> playlist.txt
for i in {01..24}; do
    if [[ -f "mixed/scene${i}_mixed.mp4" ]]; then
        echo "file 'mixed/scene${i}_mixed.mp4'" >> playlist.txt
        echo "✅ Added scene $i to playlist"
    else
        echo "❌ Missing scene $i"
    fi
done

echo ""
echo "🎬 Concatenating all 24 scenes..."

ffmpeg -y -f concat -safe 0 -i playlist.txt -c copy "DIATOM_LIVING_GLASS_ART_DOCUMENTARY.mp4" 2>/dev/null

if [[ -f "DIATOM_LIVING_GLASS_ART_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "DIATOM_LIVING_GLASS_ART_DOCUMENTARY.mp4")
    filesize=$(ls -lh "DIATOM_LIVING_GLASS_ART_DOCUMENTARY.mp4" | awk '{print $5}')
    minutes=$((${duration%.*} / 60))
    seconds=$((${duration%.*} % 60))
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ DOCUMENTARY COMPLETE! ✨"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📊 Final Stats:"
    echo "   Duration: ${minutes}m ${seconds}s"
    echo "   File Size: $filesize"
    echo "   Scenes: 24"
    echo "   Resolution: 1080p (16:9)"
    echo ""
    echo "🔬 Title: DIATOM: LIVING GLASS ART"
    echo "   Nature's invisible architects"
    echo "   200 million years of microscopic masterpieces"
    echo ""
    echo "✅ Ready for viewing!"
else
    echo "❌ Compilation failed"
fi


#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎬 COMPILING ALL 6 CONCEPTS INTO ONE HIGHLIGHT REEL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create playlist in order
cat > concept_playlist.txt << PLAYLIST
file 'Jumping_Spider_16s.mp4'
file 'Cuttlefish_16s.mp4'
file 'Tardigrade_16s.mp4'
file 'Venus_Flytrap_16s.mp4'
file 'Chameleon_16s.mp4'
file 'Monarch_Butterfly_16s.mp4'
PLAYLIST

echo "📋 Playlist created:"
echo "   1. Jumping Spider (16s)"
echo "   2. Cuttlefish (16s)"
echo "   3. Tardigrade (16s)"
echo "   4. Venus Flytrap (16s)"
echo "   5. Chameleon (16s)"
echo "   6. Monarch Butterfly (16s)"
echo ""
echo "🎬 Concatenating all concepts..."

# Concatenate all videos with re-encoding to ensure compatibility
ffmpeg -y -f concat -safe 0 -i concept_playlist.txt \
    -c:v libx264 -preset fast -crf 23 \
    -c:a aac -b:a 192k \
    ALL_CONCEPTS_HIGHLIGHT_96s.mp4 2>/dev/null

if [[ -f "ALL_CONCEPTS_HIGHLIGHT_96s.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 ALL_CONCEPTS_HIGHLIGHT_96s.mp4 | awk '{printf "%.1fs", $1}')
    size=$(ls -lh ALL_CONCEPTS_HIGHLIGHT_96s.mp4 | awk '{print $5}')
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ COMPILATION COMPLETE!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📺 File: ALL_CONCEPTS_HIGHLIGHT_96s.mp4"
    echo "⏱️  Duration: $duration"
    echo "📏 Size: $size"
    echo "📐 Format: 9:16 vertical"
    echo ""
    echo "✅ Ready to review!"
else
    echo "❌ Error: Compilation failed"
fi

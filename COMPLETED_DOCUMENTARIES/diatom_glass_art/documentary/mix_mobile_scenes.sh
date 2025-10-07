#!/bin/bash

echo "🔊 DIATOM MOBILE: Mixing all 24 scenes"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Three-layer mix: Video (0.175x) + Narration (1.3x) + Music (0.20x)"
echo "Output: AAC 44.1kHz mono (9:16 portrait)"
echo ""

for i in {01..24}; do
    video="mobile/scene${i}.mp4"
    narration="narrations/scene${i}.mp3"
    music="music/scene${i}.mp3"
    output="mobile/scene${i}_mixed.mp4"
    
    if [[ -f "$video" && -f "$narration" && -f "$music" ]]; then
        echo "🔊 Mixing mobile scene $i..."
        
        ffmpeg -y -i "$video" -i "$narration" -i "$music" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac -ac 1 -ar 44100 \
            "$output" 2>/dev/null
        
        if [[ -f "$output" ]]; then
            dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output" 2>/dev/null)
            printf "   ✅ Scene %s: Mixed (%.2fs)\n" "$i" "$dur"
        else
            echo "   ❌ Scene $i: Mix failed"
        fi
    else
        echo "   ❌ Scene $i: Missing assets"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Mobile mixing complete!"


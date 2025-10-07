#!/bin/bash

echo "🔊 DIATOM: Mixing ALL 24 Scenes"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Three-layer mix: Video (0.175x) + Narration (1.3x) + Music (0.20x)"
echo "Output: AAC 44.1kHz mono (consistent for concatenation)"
echo ""

for i in {01..24}; do
    video="videos/scene${i}.mp4"
    narration="narrations/scene${i}.mp3"
    music="music/scene${i}.mp3"
    output="mixed/scene${i}_mixed.mp4"
    
    if [[ -f "$video" && -f "$narration" && -f "$music" ]]; then
        echo "🔊 Mixing scene $i..."
        
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
        [[ ! -f "$video" ]] && echo "      - Missing video"
        [[ ! -f "$narration" ]] && echo "      - Missing narration"
        [[ ! -f "$music" ]] && echo "      - Missing music"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Mixing complete!"
echo ""
echo "📊 Verifying audio consistency (must be: aac 44100 1):"
for i in {01..24}; do
    if [[ -f "mixed/scene${i}_mixed.mp4" ]]; then
        props=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,channels -of default=noprint_wrappers=1:nokey=1 "mixed/scene${i}_mixed.mp4" 2>/dev/null | tr '\n' ' ')
        if [[ "$props" == "aac 44100 1 " ]]; then
            echo "   ✅ Scene $i: $props"
        else
            echo "   ⚠️ Scene $i: $props (MISMATCH)"
        fi
    fi
done


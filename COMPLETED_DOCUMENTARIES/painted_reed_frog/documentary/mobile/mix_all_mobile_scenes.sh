#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔊 MIXING ALL 24 MOBILE SCENES (3-Layer Audio)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

mkdir -p mixed

for scene in {1..24}; do
    VIDEO_FILE="videos/scene$(printf "%02d" $scene).mp4"
    NARRATION_FILE="../narrations/scene$(printf "%02d" $scene).mp3"
    MUSIC_FILE="../music/scene$(printf "%02d" $scene).mp3"
    MIXED_OUTPUT="mixed/scene$(printf "%02d" $scene)_mixed.mp4"
    
    if [[ -f "$VIDEO_FILE" && -f "$NARRATION_FILE" && -f "$MUSIC_FILE" ]]; then
        echo "🔊 Mixing mobile scene $(printf "%02d" $scene)..."
        
        # Three-layer mix: ambient (0.175x) + narration (1.3x) + music (0.20x)
        ffmpeg -y -i "$VIDEO_FILE" \
                  -i "$NARRATION_FILE" \
                  -i "$MUSIC_FILE" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac -ac 1 -ar 44100 \
            "$MIXED_OUTPUT" 2>/dev/null
        
        if [[ -f "$MIXED_OUTPUT" ]]; then
            size=$(ls -lh "$MIXED_OUTPUT" | awk '{print $5}')
            echo "   ✅ Scene $(printf "%02d" $scene) mixed ($size)"
        else
            echo "   ❌ Scene $(printf "%02d" $scene): Mixing failed"
        fi
    else
        echo "⚠️  Scene $(printf "%02d" $scene): Missing components"
        [[ ! -f "$VIDEO_FILE" ]] && echo "   Missing: $VIDEO_FILE"
        [[ ! -f "$NARRATION_FILE" ]] && echo "   Missing: $NARRATION_FILE"
        [[ ! -f "$MUSIC_FILE" ]] && echo "   Missing: $MUSIC_FILE"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL MOBILE SCENES MIXED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Total mixed scenes:" $(ls mixed/*.mp4 2>/dev/null | wc -l)


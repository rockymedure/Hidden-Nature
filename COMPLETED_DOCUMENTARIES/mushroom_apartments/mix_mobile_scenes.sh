#!/bin/bash

echo "🔊 MIXING MOBILE SCENES (9:16) - SCENES 2-26"
echo "⏭️  Skipping Scene 1 (no mobile video generated)"
echo ""

# Mix scenes 2-26 with existing narration and music
for scene in {2..26}; do
    VIDEO_FILE="mobile/scene${scene}.mp4"
    NARRATION_FILE="mushroom_audio/scene${scene}.mp3"
    MUSIC_FILE="mushroom_music/scene${scene}_music.wav"
    MIXED_OUTPUT="mobile/scene${scene}_mixed.mp4"
    
    if [[ -f "$VIDEO_FILE" && -f "$NARRATION_FILE" && -f "$MUSIC_FILE" ]]; then
        echo "🔊 Mixing scene $scene (mobile 9:16)..."
        
        # Two-layer mix: narration (1.3x) + music (0.20x) - videos have no audio
        ffmpeg -y -i "$VIDEO_FILE" \
                  -i "$NARRATION_FILE" \
                  -i "$MUSIC_FILE" \
            -filter_complex "[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[narration][music]amix=inputs=2:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac -ac 1 -ar 44100 \
            "$MIXED_OUTPUT" 2>/dev/null
        
        if [[ -f "$MIXED_OUTPUT" ]]; then
            size=$(ls -lh "$MIXED_OUTPUT" | awk '{print $5}')
            echo "✅ Scene $scene mixed ($size)"
        else
            echo "❌ Scene $scene: Mixing failed"
        fi
    else
        echo "⚠️  Scene $scene: Missing components"
        [[ ! -f "$VIDEO_FILE" ]] && echo "   Missing: $VIDEO_FILE"
        [[ ! -f "$NARRATION_FILE" ]] && echo "   Missing: $NARRATION_FILE"
        [[ ! -f "$MUSIC_FILE" ]] && echo "   Missing: $MUSIC_FILE"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ MOBILE MIXING COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Mixed: Scenes 2-26 with 2-layer audio"
echo "🎵 Audio: Narration (1.3x) + Music (0.20x)"
echo ""
echo "Next: Run compile_mobile_documentary.sh"

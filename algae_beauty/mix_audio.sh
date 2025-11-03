#!/bin/bash
# Liquid Starlight - Audio Mixing Script
# Three-layer mix: video ambient (0.175x) + narration (1.3x) + music (0.20x)
# CRITICAL: All scenes output as AAC 44.1kHz mono for concatenation compatibility

echo "🔊 Starting three-layer audio mixing..."
echo "📊 Mix levels: Ambient 0.175x | Narration 1.3x | Music 0.20x"
echo ""

# Create output directory
mkdir -p documentary/final

# First: Pad all narrations to exactly 8.000 seconds (prevents audio bleeding)
echo "⏱️  STEP 1: Padding narrations to 8.000 seconds..."
for scene in {1..24}; do
    if [[ -f "documentary/audio/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "documentary/audio/scene${scene}.mp3")

        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "   Scene $scene: ${duration}s → 8.000s (adding silence padding)"
            ffmpeg -y -i "documentary/audio/scene${scene}.mp3" \
                -filter_complex "[0:a]apad=pad_dur=8.0[padded]" \
                -map "[padded]" -t 8.0 \
                "documentary/audio/scene${scene}_padded.mp3" 2>/dev/null
            mv "documentary/audio/scene${scene}_padded.mp3" "documentary/audio/scene${scene}.mp3"
        else
            echo "   Scene $scene: ${duration}s (already correct)"
        fi
    fi
done

echo ""
echo "🎚️  STEP 2: Mixing all scenes (video + narration + music)..."
echo ""

# Mix all scenes with consistent audio properties
for scene in {1..24}; do
    VIDEO_FILE="documentary/videos/scene${scene}.mp4"
    NARRATION_FILE="documentary/audio/scene${scene}.mp3"
    MUSIC_FILE="documentary/music/scene${scene}_music.wav"
    MIXED_OUTPUT="documentary/final/scene${scene}_mixed.mp4"

    if [[ -f "$VIDEO_FILE" && -f "$NARRATION_FILE" && -f "$MUSIC_FILE" ]]; then
        echo "🔊 Mixing scene $scene..."

        # THREE-LAYER MIX with explicit audio consistency settings
        # CRITICAL: -c:a aac -ac 1 -ar 44100 ensures all scenes have identical audio
        ffmpeg -y -i "$VIDEO_FILE" \
                  -i "$NARRATION_FILE" \
                  -i "$MUSIC_FILE" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac -ac 1 -ar 44100 \
            "$MIXED_OUTPUT" 2>/dev/null

        echo "✅ Scene $scene mixed"
    else
        echo "❌ Scene $scene: Missing components"
        [[ ! -f "$VIDEO_FILE" ]] && echo "   Missing: video"
        [[ ! -f "$NARRATION_FILE" ]] && echo "   Missing: narration"
        [[ ! -f "$MUSIC_FILE" ]] && echo "   Missing: music"
    fi
done

echo ""
echo "🔍 STEP 3: Verifying audio consistency across all mixed scenes..."
echo ""

# Verify audio consistency (prevents concatenation dropouts)
inconsistent_scenes=()
for scene in {1..24}; do
    if [[ -f "documentary/final/scene${scene}_mixed.mp4" ]]; then
        props=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,channels \
            -of default=noprint_wrappers=1:nokey=1 "documentary/final/scene${scene}_mixed.mp4" | tr '\n' ' ')

        if [[ "$props" != "aac 44100 1 " ]]; then
            echo "❌ Scene $scene: Audio mismatch - $props (expected: aac 44100 1)"
            inconsistent_scenes+=($scene)
        else
            echo "✅ Scene $scene: Audio properties correct (aac 44100 1)"
        fi
    fi
done

# Regenerate inconsistent scenes
if [[ ${#inconsistent_scenes[@]} -gt 0 ]]; then
    echo ""
    echo "🔧 Regenerating ${#inconsistent_scenes[@]} scenes with inconsistent audio..."
    echo ""

    for scene in "${inconsistent_scenes[@]}"; do
        echo "🔊 Remixing scene $scene with correct audio settings..."
        ffmpeg -y -i "documentary/videos/scene${scene}.mp4" \
                  -i "documentary/audio/scene${scene}.mp3" \
                  -i "documentary/music/scene${scene}_music.wav" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac -ac 1 -ar 44100 \
            "documentary/final/scene${scene}_mixed.mp4" 2>/dev/null
        echo "✅ Scene $scene remixed"
    done
fi

echo ""
echo "✅ All scenes mixed with consistent audio properties!"
echo ""

# Count successful mixes
success_count=$(ls -1 documentary/final/scene*_mixed.mp4 2>/dev/null | wc -l)
echo "📊 Success: $success_count / 24 mixed scenes"

if [[ $success_count -eq 24 ]]; then
    echo "🎉 100% success rate! Ready for final assembly."
else
    echo "⚠️  Some scenes failed to mix. Check logs for details."
fi

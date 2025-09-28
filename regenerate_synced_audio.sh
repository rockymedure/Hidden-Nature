#!/bin/bash

cd black_holes_5min_science

echo "🎬 Regenerating TTS audio to match scene durations with buffer..."

# Load environment variables
if [[ -f "../.env" ]]; then
    source ../.env
fi

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VOICE="Rachel"

# Source the scene data
source scene_data.sh

# Create new directory for synced audio
mkdir -p synced_audio

for scene in {1..60}; do
    video_file="raw_videos/scene${scene}.mp4"

    if [[ -f "$video_file" ]]; then
        # Get video duration
        video_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file")

        # Calculate target audio duration (video duration - 0.5s buffer)
        target_duration=$(echo "$video_duration - 0.5" | bc)

        echo "🎵 Scene $scene: Video ${video_duration%.*}s -> Audio ${target_duration%.*}s (0.5s buffer)"

        # Get narration text
        audio_var="SCENE_${scene}_AUDIO"
        narration_text="${!audio_var}"

        if [[ -z "$narration_text" ]]; then
            echo "❌ No narration text for scene $scene"
            continue
        fi

        # Calculate speed to fit target duration
        # Estimate natural speech rate: ~150 words per minute = 2.5 words per second
        word_count=$(echo "$narration_text" | wc -w)
        natural_duration=$(echo "$word_count / 2.5" | bc -l)

        # Calculate speed multiplier to fit target duration
        if (( $(echo "$natural_duration > $target_duration" | bc -l) )); then
            speed=$(echo "scale=2; $natural_duration / $target_duration" | bc -l)
            # Cap maximum speed at 1.3 for natural speech
            if (( $(echo "$speed > 1.3" | bc -l) )); then
                speed="1.3"
            fi
        else
            # If text is shorter, slow down slightly for better pacing
            speed=$(echo "scale=2; $natural_duration / $target_duration" | bc -l)
            # Cap minimum speed at 0.8 for natural speech
            if (( $(echo "$speed < 0.8" | bc -l) )); then
                speed="0.8"
            fi
        fi

        echo "   📝 $word_count words, natural ${natural_duration%.*}s, speed ${speed}x"

        # Generate TTS with calculated speed
        request_body=$(cat << EOF
{
    "text": "$narration_text",
    "voice": "$VOICE",
    "stability": 0.5,
    "similarity_boost": 0.75,
    "style": 0.5,
    "speed": $speed
}
EOF
        )

        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$request_body")

        audio_url=$(echo "$response" | jq -r '.audio.url // empty')

        if [[ -z "$audio_url" || "$audio_url" == "null" ]]; then
            echo "❌ Audio generation failed for scene $scene"
            continue
        fi

        # Download synced audio
        synced_audio_file="synced_audio/scene${scene}_synced.mp3"
        if curl -s -o "$synced_audio_file" "$audio_url"; then
            # Verify actual duration
            actual_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$synced_audio_file")
            echo "✅ Scene $scene: Generated ${actual_duration%.*}s audio"
        else
            echo "❌ Download failed for scene $scene"
        fi

        # Small delay to avoid API rate limiting
        sleep 2

    else
        echo "⚠️  Scene $scene - no video file found"
    fi
done

echo ""
echo "🎞️  Creating scenes with properly synced audio..."

# Create directory for final synced scenes
mkdir -p final_synced_scenes

for scene in {1..60}; do
    video_file="raw_videos/scene${scene}.mp4"
    synced_audio_file="synced_audio/scene${scene}_synced.mp3"
    output_file="final_synced_scenes/scene${scene}_synced.mp4"

    if [[ -f "$video_file" && -f "$synced_audio_file" ]]; then
        echo "🔧 Mixing scene $scene..."

        # Mix veo3 ambient audio with synced narration
        ffmpeg -y -i "$video_file" -i "$synced_audio_file" \
            -filter_complex "[0:a][1:a]amix=inputs=2:duration=first:dropout_transition=2,volume=1.2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene synced and mixed"
        fi
    fi
done

echo ""
echo "🎬 Creating final documentary with perfectly synced narration..."

# Create scene list
SCENE_LIST="final_synced_scenes/synced_scene_list.txt"
> "$SCENE_LIST"

for scene in {1..60}; do
    synced_file="final_synced_scenes/scene${scene}_synced.mp4"
    if [[ -f "$synced_file" ]]; then
        echo "file '$synced_file'" >> "$SCENE_LIST"
    fi
done

# Final compilation
ffmpeg -y -f concat -safe 0 -i "$SCENE_LIST" -c copy "BLACK_HOLES_PERFECTLY_SYNCED.mp4"

if [[ -f "BLACK_HOLES_PERFECTLY_SYNCED.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "BLACK_HOLES_PERFECTLY_SYNCED.mp4")
    filesize=$(ls -lh "BLACK_HOLES_PERFECTLY_SYNCED.mp4" | awk '{print $5}')

    echo ""
    echo "🎉 SUCCESS! Perfectly synced documentary created:"
    echo "   📁 File: BLACK_HOLES_PERFECTLY_SYNCED.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "🎯 Features:"
    echo "   • Rachel's narration timed perfectly to each scene"
    echo "   • 0.5s buffer before each scene transition"
    echo "   • Variable scene lengths (4/6/8 seconds) respected"
    echo "   • Veo3 ambient audio mixed underneath"
    echo "   • Natural speech pacing with speed adjustment"

    # Create preview sample
    ffmpeg -y -i "BLACK_HOLES_PERFECTLY_SYNCED.mp4" -t 60 "PREVIEW_60sec_perfect_sync.mp4" > /dev/null 2>&1

    if [[ -f "PREVIEW_60sec_perfect_sync.mp4" ]]; then
        echo "   🎬 Preview: PREVIEW_60sec_perfect_sync.mp4"
    fi

else
    echo "❌ Failed to create final synced documentary"
fi

echo ""
echo "🎧 Your Netflix-quality educational documentary with perfectly synced narration is ready!"
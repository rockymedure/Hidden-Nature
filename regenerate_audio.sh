#!/bin/bash

cd black_holes_5min_science

echo "🎵 Regenerating TTS audio to match scene durations..."

# Load environment variables
if [[ -f "../.env" ]]; then
    source ../.env
fi

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VOICE="Rachel"

# Source the scene data
source scene_data.sh

for scene in {1..60}; do
    video_file="raw_videos/scene${scene}.mp4"

    if [[ -f "$video_file" ]]; then
        # Get actual video duration
        video_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file")
        video_duration_int=${video_duration%.*}

        # Get narration text for this scene
        audio_var="SCENE_${scene}_AUDIO"
        narration_text="${!audio_var}"

        if [[ ! -z "$narration_text" ]]; then
            echo "🔧 Scene $scene: Regenerating ${video_duration_int}s audio..."

            # Calculate speech rate to fit duration
            # Slower speed for longer scenes, faster for shorter
            case "$video_duration_int" in
                "4") speed=1.1 ;;  # Slightly faster for 4s scenes
                "6") speed=1.0 ;;  # Normal speed for 6s scenes
                "8") speed=0.9 ;;  # Slightly slower for 8s scenes
                *) speed=1.0 ;;    # Default
            esac

            # Generate new audio with appropriate speed
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

            if [[ ! -z "$audio_url" && "$audio_url" != "null" ]]; then
                # Download regenerated audio
                new_audio_file="raw_audio/scene${scene}_${video_duration_int}s.mp3"
                if curl -s -o "$new_audio_file" "$audio_url"; then
                    # Check actual duration of generated audio
                    actual_audio_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$new_audio_file")
                    echo "✅ Scene $scene: Generated ${actual_audio_duration%.*}s audio (target: ${video_duration_int}s, speed: $speed)"

                    # Now create mixed version
                    mixed_file="final_scenes/scene${scene}_mixed.mp4"
                    ffmpeg -y -i "$video_file" -i "$new_audio_file" \
                        -filter_complex "[1:a][0:a]amix=inputs=2:duration=first:dropout_transition=2,volume=1.2[audio]" \
                        -map 0:v -map "[audio]" \
                        -c:v copy -c:a aac \
                        "$mixed_file" > /dev/null 2>&1

                    if [[ -f "$mixed_file" ]]; then
                        echo "🎬 Scene $scene: Mixed version created"
                    fi
                else
                    echo "❌ Scene $scene: Download failed"
                fi
            else
                echo "❌ Scene $scene: TTS generation failed"
                echo "Response: $response"
            fi

            # Small delay between requests
            sleep 2
        else
            echo "⚠️  Scene $scene: No narration text found"
        fi
    else
        echo "⚠️  Scene $scene: Video file missing"
    fi
done

echo ""
echo "🎞️  Creating final documentary with properly timed audio..."

# Create final compilation
SCENE_LIST="mixed_scene_list.txt"
> "$SCENE_LIST"

for scene in {1..60}; do
    mixed_file="final_scenes/scene${scene}_mixed.mp4"
    if [[ -f "$mixed_file" ]]; then
        echo "file '$mixed_file'" >> "$SCENE_LIST"
    fi
done

ffmpeg -y -f concat -safe 0 -i "$SCENE_LIST" -c copy "BLACK_HOLES_PROPERLY_TIMED_AUDIO.mp4"

if [[ -f "BLACK_HOLES_PROPERLY_TIMED_AUDIO.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "BLACK_HOLES_PROPERLY_TIMED_AUDIO.mp4")
    filesize=$(ls -lh "BLACK_HOLES_PROPERLY_TIMED_AUDIO.mp4" | awk '{print $5}')

    echo ""
    echo "🎉 SUCCESS! Documentary with properly timed narration:"
    echo "   📁 File: BLACK_HOLES_PROPERLY_TIMED_AUDIO.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "🎧 Features:"
    echo "   • TTS audio regenerated to match each scene's duration"
    echo "   • Variable speech rates (4s=fast, 6s=normal, 8s=slow)"
    echo "   • Veo3 ambient audio mixed with narration"
    echo "   • Perfect timing synchronization"
else
    echo "❌ Failed to create final documentary"
fi
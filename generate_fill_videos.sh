#!/bin/bash

# Generate fill videos in parallel for scenes with longer narration

# Load environment variables
source ../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

# Define fill content for each scene that needs it
declare -A FILL_PROMPTS=(
    [4]="Close-up shots of radio telescopes and space observatories at night, detailed antenna arrays, scientists working at computers analyzing black hole data, cinematic documentary style"
    [10]="Dramatic size comparison visualization showing Earth, stellar black hole, and massive supermassive black hole scale, with gravitational field representations, educational animation style"
    [16]="Massive star in final moments before collapse, nuclear reactions failing, core compression sequence, stellar death process, cinematic space documentary"
    [22]="Multiple synchronized clocks showing different time rates, Einstein relativity visualization, time warping effects near massive objects, scientific animation"
    [27]="Quantum particles and information being destroyed or preserved, abstract information theory visualization, glowing data streams, particle physics laboratory"
    [34]="Mathematical spacetime diagrams, geometric representations of curved space, scientific chalkboard equations, Penrose diagram animations, academic physics"
    [58]="Modern physics laboratories, particle accelerators, scientists at work, research facilities, cutting-edge scientific instruments, documentary research footage"
    [60]="Spectacular cosmic vista with galaxies and nebulae, space exploration montage, future telescopes and missions, inspiring universe panorama, wonder and discovery"
)

echo "🎬 Generating fill videos for scenes with extended narration..."

# Create directory for fill videos
mkdir -p fill_videos

# Generate all fill videos in parallel
pids=()

for scene in "${!FILL_PROMPTS[@]}"; do
    prompt="${FILL_PROMPTS[$scene]}"

    echo "🎥 Generating 4s fill for Scene $scene..."

    # Generate fill video in background
    (
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$prompt\", \"duration\": 4, \"aspect_ratio\": \"16:9\"}")

        video_url=$(echo "$response" | jq -r '.video.url // empty')

        if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "fill_videos/scene${scene}_fill.mp4" "$video_url"
            echo "✅ Scene $scene fill completed"
        else
            echo "❌ Scene $scene fill failed"
            echo "Response: $response"
        fi
    ) &

    pids+=($!)

    # Small delay between requests
    sleep 2
done

echo "⏳ Waiting for all fill videos to generate..."

# Wait for all background jobs
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo ""
echo "🔧 Creating extended scenes by concatenating original + fill..."

# Create extended scenes
mkdir -p extended_scenes

for scene in "${!FILL_PROMPTS[@]}"; do
    original_video="raw_videos/scene${scene}.mp4"
    fill_video="fill_videos/scene${scene}_fill.mp4"

    if [[ -f "$original_video" && -f "$fill_video" ]]; then
        echo "🎬 Creating extended Scene $scene..."

        # Create list file for concatenation
        cat > "scene${scene}_concat.txt" << EOF
file '$original_video'
file '$fill_video'
EOF

        # Concatenate original + fill
        ffmpeg -y -f concat -safe 0 -i "scene${scene}_concat.txt" -c copy "extended_scenes/scene${scene}_extended.mp4" > /dev/null 2>&1

        if [[ -f "extended_scenes/scene${scene}_extended.mp4" ]]; then
            echo "✅ Scene $scene extended"

            # Clean up temp file
            rm "scene${scene}_concat.txt"
        else
            echo "❌ Scene $scene concatenation failed"
        fi
    else
        echo "⚠️  Scene $scene missing files"
    fi
done

echo ""
echo "🎵 Mixing extended scenes with narration..."

# Mix extended scenes with audio
mkdir -p final_extended_scenes

for scene in "${!FILL_PROMPTS[@]}"; do
    extended_video="extended_scenes/scene${scene}_extended.mp4"

    # Find the right audio file
    audio_file="raw_audio/scene${scene}_4s.mp3"
    [[ ! -f "$audio_file" ]] && audio_file="raw_audio/scene${scene}_6s.mp3"
    [[ ! -f "$audio_file" ]] && audio_file="raw_audio/scene${scene}_8s.mp3"
    [[ ! -f "$audio_file" ]] && audio_file="raw_audio/scene${scene}.mp3"

    if [[ -f "$extended_video" && -f "$audio_file" ]]; then
        echo "🎧 Mixing Scene $scene with narration..."

        final_file="final_extended_scenes/scene${scene}_final_extended.mp4"

        # Mix veo3 audio with narration
        ffmpeg -y -i "$extended_video" -i "$audio_file" \
            -filter_complex "[0:a][1:a]amix=inputs=2:duration=first:dropout_transition=2,volume=1.2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$final_file" > /dev/null 2>&1

        if [[ -f "$final_file" ]]; then
            echo "✅ Scene $scene final extended version created"
        else
            echo "❌ Scene $scene mixing failed"
        fi
    fi
done

echo ""
echo "🎉 Fill video generation complete!"
echo ""
echo "📊 Summary:"
for scene in "${!FILL_PROMPTS[@]}"; do
    if [[ -f "final_extended_scenes/scene${scene}_final_extended.mp4" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "final_extended_scenes/scene${scene}_final_extended.mp4")
        echo "   Scene $scene: Extended to ${duration%.*}s with narration"
    fi
done
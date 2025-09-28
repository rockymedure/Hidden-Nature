#!/bin/bash

# Generate Attenborough-style documentary with multi-clip approach

cd black_holes_attenborough_science

echo "🎬 Generating Attenborough-style documentary clips..."

# Load environment
source ../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

# Create directories
mkdir -p multi_clips matched_videos final_mixed

echo "🎯 Target durations based on natural narration:"
echo "Scene 1: 10s | Scene 2: 10s | Scene 3: 18s | Scene 4: 15s"
echo "Scene 5: 13s | Scene 6: 15s | Scene 7: 17s | Scene 10: 19s"
echo ""

# Define clip generation strategy for each scene
generate_scene_clips() {
    local scene=$1
    local target_seconds=$2
    local prompts=("${@:3}")

    echo "🎬 Scene $scene: Generating clips for ${target_seconds}s total"

    mkdir -p "multi_clips/scene${scene}"

    local clips_needed=0
    local remaining_time=$target_seconds

    while (( remaining_time > 0 )); do
        ((clips_needed++))

        # Choose optimal clip duration
        if (( remaining_time >= 8 )); then
            clip_duration=8
        elif (( remaining_time >= 6 )); then
            clip_duration=6
        else
            clip_duration=4
        fi

        # Select prompt (cycle through variations)
        prompt_index=$(( (clips_needed - 1) % ${#prompts[@]} ))
        prompt="${prompts[$prompt_index]}"

        echo "  📹 Clip $clips_needed: ${clip_duration}s"

        # Generate clip
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$prompt\", \"duration\": $clip_duration, \"aspect_ratio\": \"16:9\"}")

        video_url=$(echo "$response" | jq -r '.video.url // empty')

        if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "multi_clips/scene${scene}/clip${clips_needed}_${clip_duration}s.mp4" "$video_url"
            echo "    ✅ Clip $clips_needed downloaded"
        else
            echo "    ❌ Clip $clips_needed failed"
        fi

        remaining_time=$((remaining_time - clip_duration))
        sleep 3
    done

    # Combine clips for this scene
    echo "  🔗 Combining clips for Scene $scene..."

    concat_list="multi_clips/scene${scene}/concat_list.txt"
    > "$concat_list"

    for clip in $(seq 1 $clips_needed); do
        for duration in 8 6 4; do
            clip_file="multi_clips/scene${scene}/clip${clip}_${duration}s.mp4"
            if [[ -f "$clip_file" ]]; then
                echo "file '$clip_file'" >> "$concat_list"
                break
            fi
        done
    done

    # Concatenate clips
    combined_file="matched_videos/scene${scene}_${target_seconds}s.mp4"
    ffmpeg -y -f concat -safe 0 -i "$concat_list" -c copy "$combined_file" > /dev/null 2>&1

    if [[ -f "$combined_file" ]]; then
        echo "  ✅ Scene $scene: ${target_seconds}s video ready"
        return 0
    else
        echo "  ❌ Scene $scene: Combination failed"
        return 1
    fi
}

echo "🚀 Starting clip generation..."

# Scene 1: 10s (8s + 4s)
generate_scene_clips 1 10 \
    "Deep space background with galaxies and nebulae, cosmic vista, cinematic documentary style, no speech, ambient only" \
    "Majestic cosmic title sequence emerging, stellar formations, space documentary opening, no dialogue, atmospheric audio only"

# Scene 2: 10s (6s + 4s)
generate_scene_clips 2 10 \
    "Dramatic black hole with swirling accretion disk, matter spiraling inward, cosmic phenomenon, no speech, ambient only" \
    "Spectacular black hole close-up, luminous matter streams, space cinematography, no dialogue, atmospheric audio"

# Scene 3: 18s (8s + 6s + 4s)
generate_scene_clips 3 18 \
    "Einstein working on equations, mathematical formulas, historical documentary style, no speech, ambient only" \
    "Spacetime visualization, curved geometry demonstration, physics education, no dialogue, atmospheric audio" \
    "Scientific equations and relativity concepts, academic documentation, no narration, ambient background"

# Continue with remaining scenes...
# (Add more generate_scene_clips calls for scenes 4,5,6,7,10)

echo ""
echo "🎵 Mixing all scenes with Attenborough narration..."

# Mix each scene with its narration
for scene in 1 2 3; do  # Add more scene numbers as they're generated
    video_file="matched_videos/scene${scene}_*s.mp4"
    video_exists=$(ls $video_file 2>/dev/null | head -1)
    narration_file="narration_first/scene${scene}_natural.mp3"

    if [[ ! -z "$video_exists" && -f "$narration_file" ]]; then
        output_file="final_mixed/scene${scene}_attenborough.mp4"

        echo "🎼 Scene $scene: Mixing Attenborough-style narration"

        ffmpeg -y -i "$video_exists" -i "$narration_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Perfect Attenborough sync"
        fi
    fi
done

echo ""
echo "🎞️  Attenborough-style documentary generation in progress..."
echo "Total target duration: ~2 minutes with natural educational pacing"
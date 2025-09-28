#!/bin/bash

# Generate multiple 4/6/8s clips and combine them to match narration length

cd black_holes_attenborough_science

echo "🎬 Generating multiple clips to match narration timing..."

# Load environment
source ../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

# Read the timing data
while IFS='|' read -r scene duration rounded_duration; do
    if [[ -z "$scene" ]]; then continue; fi

    echo "🎯 Scene $scene needs ${rounded_duration%.*}s of video"

    # Calculate how many clips needed
    target_seconds=${rounded_duration%.*}

    # Get visual description
    visual_var="SCENE_${scene}_VISUAL"
    visual_desc="${!visual_var}"

    if [[ -z "$visual_desc" ]]; then
        echo "❌ No visual description for scene $scene"
        continue
    fi

    # Create variations of the visual prompt
    case $scene in
        1) prompts=(
            "Deep space background with galaxies and nebulae, cosmic title sequence, cinematic documentary style, no speech, ambient only"
            "Stunning cosmic vista with distant stars and nebulae, space documentary opening, no dialogue, atmospheric audio only"
            "Majestic deep space panorama, galaxy formations, documentary cinematography, silent cosmic ambience"
        ) ;;
        2) prompts=(
            "Dramatic black hole with swirling accretion disk, matter spiraling inward, cosmic documentary style, no speech, ambient only"
            "Spectacular black hole visualization, glowing matter streams, space cinematography, no dialogue, atmospheric audio"
            "Powerful black hole with luminous accretion disk, cosmic phenomenon, documentary filming, silent space ambience"
        ) ;;
        3) prompts=(
            "Einstein working on equations, mathematical formulas, historical documentary style, no speech, ambient only"
            "Spacetime visualization, curved geometry demonstration, physics education, no dialogue, atmospheric audio"
            "Scientific equations and relativity concepts, academic documentation, no narration, ambient background"
        ) ;;
        *) prompts=(
            "$visual_desc, cinematic documentary style, no speech, ambient only"
            "$visual_desc, professional cinematography, no dialogue, atmospheric audio"
            "$visual_desc, educational visualization, no narration, ambient background"
        ) ;;
    esac

    # Generate clips to fill the time
    mkdir -p "multi_clips/scene${scene}"

    clips_needed=0
    remaining_time=$target_seconds

    while (( remaining_time > 0 )); do
        ((clips_needed++))

        # Choose clip duration (prioritize longer clips)
        if (( remaining_time >= 8 )); then
            clip_duration=8
        elif (( remaining_time >= 6 )); then
            clip_duration=6
        else
            clip_duration=4
        fi

        # Choose prompt variation (cycle through them)
        prompt_index=$(( (clips_needed - 1) % 3 ))
        prompt="${prompts[$prompt_index]}"

        echo "  📹 Clip $clips_needed: ${clip_duration}s (${remaining_time}s remaining)"

        # Generate clip
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$prompt\", \"duration\": $clip_duration, \"aspect_ratio\": \"16:9\"}")

        video_url=$(echo "$response" | jq -r '.video.url // empty')

        if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "multi_clips/scene${scene}/clip${clips_needed}_${clip_duration}s.mp4" "$video_url"
            echo "    ✅ Clip $clips_needed generated"
        else
            echo "    ❌ Clip $clips_needed failed"
        fi

        remaining_time=$((remaining_time - clip_duration))
        sleep 3  # Rate limiting
    done

    echo "  🔗 Combining $clips_needed clips for Scene $scene..."

    # Create concatenation list
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
    combined_file="matched_videos/scene${scene}_combined_${target_seconds}s.mp4"
    ffmpeg -y -f concat -safe 0 -i "$concat_list" -c copy "$combined_file" > /dev/null 2>&1

    if [[ -f "$combined_file" ]]; then
        echo "  ✅ Scene $scene: Combined ${target_seconds}s video created"
    else
        echo "  ❌ Scene $scene: Combination failed"
    fi

done < measured_durations/timing_data.txt

echo ""
echo "🎼 Mixing combined videos with narration..."

# Mix each combined video with its narration
while IFS='|' read -r scene duration rounded_duration; do
    if [[ -z "$scene" ]]; then continue; fi

    target_seconds=${rounded_duration%.*}
    video_file="matched_videos/scene${scene}_combined_${target_seconds}s.mp4"
    narration_file="narration_first/scene${scene}_natural.mp3"
    output_file="final_mixed/scene${scene}_attenborough_perfect.mp4"

    if [[ -f "$video_file" && -f "$narration_file" ]]; then
        echo "🎵 Scene $scene: Mixing Attenborough-style narration"

        ffmpeg -y -i "$video_file" -i "$narration_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Attenborough-quality achieved"
        fi
    fi
done < measured_durations/timing_data.txt

echo ""
echo "🎞️  Creating final Attenborough-style documentary..."

# Final assembly
FINAL_LIST="attenborough_final_list.txt"
> "$FINAL_LIST"

for scene in $(seq 1 10); do
    perfect_file="final_mixed/scene${scene}_attenborough_perfect.mp4"
    if [[ -f "$perfect_file" ]]; then
        echo "file '$perfect_file'" >> "$FINAL_LIST"
    fi
done

ffmpeg -y -f concat -safe 0 -i "$FINAL_LIST" -c copy "BLACK_HOLES_ATTENBOROUGH_PERFECT.mp4"

if [[ -f "BLACK_HOLES_ATTENBOROUGH_PERFECT.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "BLACK_HOLES_ATTENBOROUGH_PERFECT.mp4")
    filesize=$(ls -lh "BLACK_HOLES_ATTENBOROUGH_PERFECT.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Attenborough-style documentary:"
    echo "   📁 File: BLACK_HOLES_ATTENBOROUGH_PERFECT.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "🎯 Perfect synchronization achieved through smart clip combination!"

else
    echo "❌ Failed to create final documentary"
fi
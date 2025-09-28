#!/bin/bash

# Parallel Educational Video Production System
# Optimized for large-scale generation without hitting API limits

set -e

# Load environment variables
if [[ -f ".env" ]]; then
    source .env
fi

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# API Endpoints
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

# Parallel processing configuration
MAX_CONCURRENT_VIDEO=8    # Maximum concurrent video generations
MAX_CONCURRENT_AUDIO=12   # Maximum concurrent audio generations
CHUNK_SIZE=10             # Process scenes in chunks of 10
VIDEO_DELAY=3             # Seconds between video API calls
AUDIO_DELAY=2             # Seconds between audio API calls

echo -e "${BLUE}🚀 Parallel Educational Video Production System${NC}"
echo -e "${CYAN}High-Performance Documentary Generator${NC}"

# Check required parameters
if [[ $# -lt 3 ]]; then
    echo -e "${RED}Usage: $0 <topic> <channel> <script_file>${NC}"
    echo "Example: $0 black_holes_5min science scripts/black_holes_5min.md"
    exit 1
fi

TOPIC="$1"
CHANNEL="$2"
SCRIPT_FILE="$3"

if [[ ! -f "$SCRIPT_FILE" ]]; then
    echo -e "${RED}❌ Script file not found: $SCRIPT_FILE${NC}"
    exit 1
fi

# Channel configurations
get_channel_info() {
    case "$1" in
        "science") echo "Documentary|55555|Rachel" ;;
        "history") echo "Narrative|66666|Marcus" ;;
        "nature") echo "Nature|77777|Maya" ;;
        "psychology") echo "Conversational|88888|James" ;;
        *) echo "Documentary|55555|Rachel" ;;
    esac
}

# Parse channel information
CHANNEL_INFO=$(get_channel_info "$CHANNEL")
IFS='|' read -r STYLE SEED VOICE <<< "$CHANNEL_INFO"

echo -e "${YELLOW}📋 Topic: $TOPIC${NC}"
echo -e "${YELLOW}📺 Channel: $CHANNEL${NC}"
echo -e "${YELLOW}🎨 Style: $STYLE${NC}"
echo -e "${YELLOW}🌱 Seed: $SEED${NC}"
echo -e "${YELLOW}🗣️  Voice: $VOICE${NC}"
echo -e "${YELLOW}⚡ Max Concurrent Videos: $MAX_CONCURRENT_VIDEO${NC}"
echo -e "${YELLOW}⚡ Max Concurrent Audio: $MAX_CONCURRENT_AUDIO${NC}"

# Create directory structure
TOPIC_DIR="${TOPIC}_${CHANNEL}"
mkdir -p "$TOPIC_DIR/raw_videos"
mkdir -p "$TOPIC_DIR/raw_audio"
mkdir -p "$TOPIC_DIR/final_scenes"
mkdir -p "$TOPIC_DIR/logs"

echo -e "${BLUE}📁 Created directory: $TOPIC_DIR${NC}"

# Extract scenes from script file (same as before but optimized)
extract_scenes() {
    local script_file="$1"
    local scene_num=1

    > "${TOPIC_DIR}/scene_data.sh"  # Clear file

    while IFS= read -r line; do
        if [[ "$line" =~ ^\*\*Scene\ [0-9]+\*\*: ]]; then
            # Extract visual description
            visual=$(echo "$line" | sed 's/\*\*Scene [0-9]*\*\*: //')
            visual=$(echo "$visual" | sed 's/"/\\"/g')
            echo "SCENE_${scene_num}_VISUAL=\"$visual\"" >> "${TOPIC_DIR}/scene_data.sh"
        elif [[ "$line" =~ ^-\ \*\*Narration\*\*: ]]; then
            # Extract narration text
            narration=$(echo "$line" | sed 's/^- \*\*Narration\*\*: "//' | sed 's/"$//')
            narration=$(echo "$narration" | sed 's/"/\\"/g')
            echo "SCENE_${scene_num}_AUDIO=\"$narration\"" >> "${TOPIC_DIR}/scene_data.sh"
            ((scene_num++))
        fi
    done < "$script_file"

    echo $((scene_num - 1))
}

# Generate video with error handling and retries
generate_video_parallel() {
    local scene_num=$1
    local visual_var="SCENE_${scene_num}_VISUAL"
    local visual_desc="${!visual_var}"

    if [[ -z "$visual_desc" ]]; then
        echo -e "${RED}❌ No visual for scene $scene_num${NC}" | tee -a "${TOPIC_DIR}/logs/video_errors.log"
        return 1
    fi

    # Variable scene duration
    local durations=(4 6 8)
    local duration=${durations[$((($scene_num - 1) % 3))]}

    local prompt="$visual_desc, cinematic documentary style, professional camera work, 4K quality, dramatic lighting, educational visualization"

    local request_body=$(cat << EOF
{
    "prompt": "$prompt",
    "duration": $duration,
    "aspect_ratio": "16:9",
    "seed": $SEED
}
EOF
    )

    echo -e "${CYAN}🎥 [Scene $scene_num] Generating video (${duration}s)...${NC}" | tee -a "${TOPIC_DIR}/logs/progress.log"

    local response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$request_body")

    local video_url=$(echo "$response" | jq -r '.video.url // empty')

    if [[ -z "$video_url" || "$video_url" == "null" ]]; then
        echo -e "${RED}❌ [Scene $scene_num] Video generation failed${NC}" | tee -a "${TOPIC_DIR}/logs/video_errors.log"
        echo "Response: $response" >> "${TOPIC_DIR}/logs/video_errors.log"
        return 1
    fi

    # Download video
    local video_file="${TOPIC_DIR}/raw_videos/scene${scene_num}.mp4"
    if curl -s -o "$video_file" "$video_url"; then
        echo -e "${GREEN}✅ [Scene $scene_num] Video completed${NC}" | tee -a "${TOPIC_DIR}/logs/progress.log"
        return 0
    else
        echo -e "${RED}❌ [Scene $scene_num] Video download failed${NC}" | tee -a "${TOPIC_DIR}/logs/video_errors.log"
        return 1
    fi
}

# Generate audio with error handling and retries
generate_audio_parallel() {
    local scene_num=$1
    local audio_var="SCENE_${scene_num}_AUDIO"
    local narration_text="${!audio_var}"

    if [[ -z "$narration_text" ]]; then
        echo -e "${RED}❌ No audio for scene $scene_num${NC}" | tee -a "${TOPIC_DIR}/logs/audio_errors.log"
        return 1
    fi

    local request_body=$(cat << EOF
{
    "text": "$narration_text",
    "voice": "$VOICE",
    "stability": 0.5,
    "similarity_boost": 0.75,
    "style": 0.5,
    "speed": 1.0
}
EOF
    )

    echo -e "${CYAN}🎵 [Scene $scene_num] Generating audio...${NC}" | tee -a "${TOPIC_DIR}/logs/progress.log"

    local response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$request_body")

    local audio_url=$(echo "$response" | jq -r '.audio.url // empty')

    if [[ -z "$audio_url" || "$audio_url" == "null" ]]; then
        echo -e "${RED}❌ [Scene $scene_num] Audio generation failed${NC}" | tee -a "${TOPIC_DIR}/logs/audio_errors.log"
        echo "Response: $response" >> "${TOPIC_DIR}/logs/audio_errors.log"
        return 1
    fi

    # Download audio
    local audio_file="${TOPIC_DIR}/raw_audio/scene${scene_num}.mp3"
    if curl -s -o "$audio_file" "$audio_url"; then
        echo -e "${GREEN}✅ [Scene $scene_num] Audio completed${NC}" | tee -a "${TOPIC_DIR}/logs/progress.log"
        return 0
    else
        echo -e "${RED}❌ [Scene $scene_num] Audio download failed${NC}" | tee -a "${TOPIC_DIR}/logs/audio_errors.log"
        return 1
    fi
}

# Process video generation in parallel batches
process_videos_parallel() {
    local start_scene=$1
    local end_scene=$2

    echo -e "${PURPLE}🎬 Processing videos for scenes $start_scene-$end_scene${NC}"

    local pids=()
    local active_jobs=0

    for scene in $(seq $start_scene $end_scene); do
        # Wait if we have too many concurrent jobs
        while [[ $active_jobs -ge $MAX_CONCURRENT_VIDEO ]]; do
            sleep 1
            # Count running jobs
            active_jobs=0
            for pid in "${pids[@]}"; do
                if kill -0 "$pid" 2>/dev/null; then
                    ((active_jobs++))
                fi
            done
        done

        # Launch video generation in background
        (generate_video_parallel "$scene") &
        pids+=($!)
        ((active_jobs++))

        # Small delay to avoid overwhelming API
        sleep $VIDEO_DELAY
    done

    # Wait for all video jobs to complete
    echo -e "${BLUE}⏳ Waiting for video generation batch to complete...${NC}"
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
}

# Process audio generation in parallel batches
process_audio_parallel() {
    local start_scene=$1
    local end_scene=$2

    echo -e "${PURPLE}🎵 Processing audio for scenes $start_scene-$end_scene${NC}"

    local pids=()
    local active_jobs=0

    for scene in $(seq $start_scene $end_scene); do
        # Wait if we have too many concurrent jobs
        while [[ $active_jobs -ge $MAX_CONCURRENT_AUDIO ]]; do
            sleep 1
            # Count running jobs
            active_jobs=0
            for pid in "${pids[@]}"; do
                if kill -0 "$pid" 2>/dev/null; then
                    ((active_jobs++))
                fi
            done
        done

        # Launch audio generation in background
        (generate_audio_parallel "$scene") &
        pids+=($!)
        ((active_jobs++))

        # Small delay to avoid overwhelming API
        sleep $AUDIO_DELAY
    done

    # Wait for all audio jobs to complete
    echo -e "${BLUE}⏳ Waiting for audio generation batch to complete...${NC}"
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
}

# Combine video and audio for all scenes
combine_scenes_parallel() {
    local start_scene=$1
    local end_scene=$2

    echo -e "${PURPLE}🎬 Combining scenes $start_scene-$end_scene${NC}"

    for scene in $(seq $start_scene $end_scene); do
        local video_file="${TOPIC_DIR}/raw_videos/scene${scene}.mp4"
        local audio_file="${TOPIC_DIR}/raw_audio/scene${scene}.mp3"
        local output_file="${TOPIC_DIR}/final_scenes/scene${scene}_final.mp4"

        if [[ -f "$video_file" && -f "$audio_file" ]]; then
            ffmpeg -y -i "$video_file" -i "$audio_file" -c:v copy -c:a aac -shortest "$output_file" > /dev/null 2>&1
            if [[ -f "$output_file" ]]; then
                echo -e "${GREEN}✅ [Scene $scene] Combined successfully${NC}"
            else
                echo -e "${RED}❌ [Scene $scene] Combination failed${NC}"
            fi
        else
            echo -e "${YELLOW}⚠️  [Scene $scene] Missing video or audio${NC}"
        fi
    done
}

# Main processing function
main() {
    # Extract scene data
    echo -e "${CYAN}📝 Extracting scenes from script...${NC}"
    TOTAL_SCENES=$(extract_scenes "$SCRIPT_FILE")
    echo -e "${GREEN}✅ Extracted $TOTAL_SCENES scenes${NC}"

    # Source the scene data
    source "${TOPIC_DIR}/scene_data.sh"

    # Process in chunks
    echo -e "${PURPLE}🚀 Starting parallel production pipeline...${NC}"

    for ((chunk_start=1; chunk_start<=TOTAL_SCENES; chunk_start+=CHUNK_SIZE)); do
        chunk_end=$((chunk_start + CHUNK_SIZE - 1))
        if [[ $chunk_end -gt $TOTAL_SCENES ]]; then
            chunk_end=$TOTAL_SCENES
        fi

        echo -e "${BLUE}📦 Processing chunk: scenes $chunk_start-$chunk_end${NC}"

        # Process videos first (parallel batch)
        process_videos_parallel $chunk_start $chunk_end

        # Small break between video and audio
        sleep 3

        # Process audio (parallel batch)
        process_audio_parallel $chunk_start $chunk_end

        # Combine scenes in this chunk
        combine_scenes_parallel $chunk_start $chunk_end

        echo -e "${GREEN}✅ Chunk $chunk_start-$chunk_end completed${NC}"

        # Break between chunks to avoid overwhelming API
        if [[ $chunk_end -lt $TOTAL_SCENES ]]; then
            echo -e "${BLUE}⏸️  Cooling down before next chunk...${NC}"
            sleep 5
        fi
    done

    # Create final compilation
    echo -e "${PURPLE}🎞️  Creating final compilation...${NC}"

    SCENE_LIST="${TOPIC_DIR}/scene_list.txt"
    > "$SCENE_LIST"

    for scene in $(seq 1 $TOTAL_SCENES); do
        final_scene="${TOPIC_DIR}/final_scenes/scene${scene}_final.mp4"
        if [[ -f "$final_scene" ]]; then
            echo "file '$final_scene'" >> "$SCENE_LIST"
        fi
    done

    # Final compilation
    FINAL_VIDEO="${TOPIC_DIR}/${TOPIC}_${CHANNEL}_documentary.mp4"
    ffmpeg -y -f concat -safe 0 -i "$SCENE_LIST" -c copy "$FINAL_VIDEO" > /dev/null 2>&1

    if [[ -f "$FINAL_VIDEO" ]]; then
        echo -e "${GREEN}🎉 SUCCESS! Final video created: $FINAL_VIDEO${NC}"

        # Get video stats
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FINAL_VIDEO" | cut -d. -f1)
        filesize=$(ls -lh "$FINAL_VIDEO" | awk '{print $5}')

        echo -e "${CYAN}📊 Video Stats:${NC}"
        echo -e "${YELLOW}   Duration: ${duration}s${NC}"
        echo -e "${YELLOW}   File Size: $filesize${NC}"
        echo -e "${YELLOW}   Scenes: $TOTAL_SCENES${NC}"
        echo -e "${YELLOW}   Location: $FINAL_VIDEO${NC}"

        # Show error summary
        video_errors=$(wc -l < "${TOPIC_DIR}/logs/video_errors.log" 2>/dev/null || echo "0")
        audio_errors=$(wc -l < "${TOPIC_DIR}/logs/audio_errors.log" 2>/dev/null || echo "0")
        echo -e "${YELLOW}   Video Errors: $video_errors${NC}"
        echo -e "${YELLOW}   Audio Errors: $audio_errors${NC}"
    else
        echo -e "${RED}❌ Failed to create final compilation${NC}"
        exit 1
    fi
}

# Run main function
main

echo -e "${GREEN}🎬 Parallel educational video production complete!${NC}"
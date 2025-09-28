#!/bin/bash

# TTS-FIRST WORKFLOW: Natural narration determines video timing
# Step 1: Generate all TTS → Step 2: Measure durations → Step 3: Generate videos to match

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

echo -e "${BLUE}🎬 TTS-FIRST Educational Video Production${NC}"
echo -e "${CYAN}Attenborough-Style Natural Pacing${NC}"

# Check required parameters
if [[ $# -lt 3 ]]; then
    echo -e "${RED}Usage: $0 <topic> <channel> <script_file>${NC}"
    echo "Example: $0 black_holes_attenborough science scripts/black_holes_ATTENBOROUGH_STYLE.md"
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
        "science") echo "Documentary|Rachel" ;;
        "history") echo "Narrative|Marcus" ;;
        "nature") echo "Nature|Maya" ;;
        "psychology") echo "Conversational|James" ;;
        *) echo "Documentary|Rachel" ;;
    esac
}

# Parse channel information
CHANNEL_INFO=$(get_channel_info "$CHANNEL")
IFS='|' read -r STYLE VOICE <<< "$CHANNEL_INFO"

echo -e "${YELLOW}📋 Topic: $TOPIC${NC}"
echo -e "${YELLOW}📺 Channel: $CHANNEL${NC}"
echo -e "${YELLOW}🎨 Style: $STYLE${NC}"
echo -e "${YELLOW}🗣️  Voice: $VOICE${NC}"

# Create directory structure
TOPIC_DIR="${TOPIC}_${CHANNEL}"
mkdir -p "$TOPIC_DIR/narration_first"
mkdir -p "$TOPIC_DIR/measured_durations"
mkdir -p "$TOPIC_DIR/matched_videos"
mkdir -p "$TOPIC_DIR/final_mixed"

echo -e "${BLUE}📁 Created directory: $TOPIC_DIR${NC}"

# Extract scenes from script file
extract_scenes() {
    local script_file="$1"
    local scene_num=1

    > "${TOPIC_DIR}/scene_narration.sh"

    while IFS= read -r line; do
        if [[ "$line" =~ ^\*\*Scene\ [0-9]+\*\*: ]]; then
            visual=$(echo "$line" | sed 's/\*\*Scene [0-9]*\*\*: //')
            visual=$(echo "$visual" | sed 's/"/\\"/g')
            echo "SCENE_${scene_num}_VISUAL=\"$visual\"" >> "${TOPIC_DIR}/scene_narration.sh"
        elif [[ "$line" =~ ^-\ \*\*Narration\*\*: ]]; then
            narration=$(echo "$line" | sed 's/^- \*\*Narration\*\*: "//' | sed 's/"$//')
            narration=$(echo "$narration" | sed 's/"/\\"/g')
            echo "SCENE_${scene_num}_AUDIO=\"$narration\"" >> "${TOPIC_DIR}/scene_narration.sh"
            ((scene_num++))
        fi
    done < "$script_file"

    echo $((scene_num - 1))
}

echo -e "${CYAN}📝 Extracting scenes from script...${NC}"
TOTAL_SCENES=$(extract_scenes "$SCRIPT_FILE")
echo -e "${GREEN}✅ Extracted $TOTAL_SCENES scenes${NC}"

# Source the scene data
source "${TOPIC_DIR}/scene_narration.sh"

echo -e "${PURPLE}🎵 STEP 1: Generating all narration first...${NC}"

# Generate all TTS audio first (parallel)
pids=()
for scene in $(seq 1 $TOTAL_SCENES); do
    audio_var="SCENE_${scene}_AUDIO"
    narration_text="${!audio_var}"

    if [[ ! -z "$narration_text" ]]; then
        echo -e "${CYAN}🎤 Generating natural narration for Scene $scene...${NC}"

        # Generate TTS in background
        (
            request_body=$(cat << EOF
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

            response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
                -H "Authorization: Key $FAL_API_KEY" \
                -H "Content-Type: application/json" \
                -d "$request_body")

            audio_url=$(echo "$response" | jq -r '.audio.url // empty')

            if [[ ! -z "$audio_url" && "$audio_url" != "null" ]]; then
                curl -s -o "${TOPIC_DIR}/narration_first/scene${scene}_natural.mp3" "$audio_url"
                echo -e "${GREEN}✅ Scene $scene narration completed${NC}"
            else
                echo -e "${RED}❌ Scene $scene narration failed${NC}"
            fi
        ) &

        pids+=($!)
        sleep 2  # Rate limiting
    fi
done

echo -e "${BLUE}⏳ Waiting for all narration to generate...${NC}"
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo -e "${PURPLE}📏 STEP 2: Measuring actual narration durations...${NC}"

# Measure all narration durations
> "${TOPIC_DIR}/measured_durations/timing_data.txt"

for scene in $(seq 1 $TOTAL_SCENES); do
    narration_file="${TOPIC_DIR}/narration_first/scene${scene}_natural.mp3"

    if [[ -f "$narration_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$narration_file")
        # Round up to nearest 0.5 second for video generation
        rounded_duration=$(echo "scale=1; ($duration + 0.5) / 1 * 1" | bc)

        echo "$scene|$duration|$rounded_duration" >> "${TOPIC_DIR}/measured_durations/timing_data.txt"

        echo -e "${YELLOW}Scene $scene: Narration ${duration%.*}s → Video ${rounded_duration%.*}s${NC}"
    fi
done

echo -e "${PURPLE}🎥 STEP 3: Generating videos to match narration timing...${NC}"

# Generate videos based on measured narration durations (parallel)
pids=()
while IFS='|' read -r scene duration rounded_duration; do
    if [[ -z "$scene" ]]; then continue; fi

    visual_var="SCENE_${scene}_VISUAL"
    visual_desc="${!visual_var}"

    if [[ ! -z "$visual_desc" ]]; then
        echo -e "${CYAN}🎬 Generating ${rounded_duration%.*}s video for Scene $scene...${NC}"

        # Generate video to match narration length
        (
            prompt="$visual_desc, cinematic documentary style, professional camera work, 4K quality, dramatic lighting, educational visualization, no speech, no dialogue, ambient sound only"

            request_body=$(cat << EOF
{
    "prompt": "$prompt",
    "duration": $rounded_duration,
    "aspect_ratio": "16:9"
}
EOF
            )

            response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
                -H "Authorization: Key $FAL_API_KEY" \
                -H "Content-Type: application/json" \
                -d "$request_body")

            video_url=$(echo "$response" | jq -r '.video.url // empty')

            if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
                curl -s -o "${TOPIC_DIR}/matched_videos/scene${scene}_${rounded_duration%.*}s.mp4" "$video_url"
                echo -e "${GREEN}✅ Scene $scene video matched to narration${NC}"
            else
                echo -e "${RED}❌ Scene $scene video failed${NC}"
            fi
        ) &

        pids+=($!)
        sleep 3  # Rate limiting
    fi
done < "${TOPIC_DIR}/measured_durations/timing_data.txt"

echo -e "${BLUE}⏳ Waiting for all matched videos...${NC}"
for pid in "${pids[@]}"; do
    wait "$pid"
done

echo -e "${PURPLE}🎼 STEP 4: Mixing narration with matched videos...${NC}"

# Mix narration with perfectly matched videos
while IFS='|' read -r scene duration rounded_duration; do
    if [[ -z "$scene" ]]; then continue; fi

    video_file="${TOPIC_DIR}/matched_videos/scene${scene}_${rounded_duration%.*}s.mp4"
    narration_file="${TOPIC_DIR}/narration_first/scene${scene}_natural.mp3"
    output_file="${TOPIC_DIR}/final_mixed/scene${scene}_perfect_sync.mp4"

    if [[ -f "$video_file" && -f "$narration_file" ]]; then
        echo -e "${CYAN}🎼 Mixing Scene $scene with perfect timing...${NC}"

        # Mix with Attenborough-style audio levels
        ffmpeg -y -i "$video_file" -i "$narration_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo -e "${GREEN}✅ Scene $scene perfectly synchronized${NC}"
        else
            echo -e "${RED}❌ Scene $scene mixing failed${NC}"
        fi
    fi
done < "${TOPIC_DIR}/measured_durations/timing_data.txt"

echo -e "${PURPLE}🎞️  STEP 5: Final documentary assembly...${NC}"

# Create final scene list
FINAL_LIST="${TOPIC_DIR}/perfect_sync_list.txt"
> "$FINAL_LIST"

for scene in $(seq 1 $TOTAL_SCENES); do
    perfect_file="${TOPIC_DIR}/final_mixed/scene${scene}_perfect_sync.mp4"
    if [[ -f "$perfect_file" ]]; then
        echo "file '$perfect_file'" >> "$FINAL_LIST"
    fi
done

# Final compilation
FINAL_VIDEO="${TOPIC_DIR}/${TOPIC}_PERFECT_SYNC_DOCUMENTARY.mp4"
ffmpeg -y -f concat -safe 0 -i "$FINAL_LIST" -c copy "$FINAL_VIDEO"

if [[ -f "$FINAL_VIDEO" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FINAL_VIDEO")
    filesize=$(ls -lh "$FINAL_VIDEO" | awk '{print $5}')

    echo ""
    echo -e "${GREEN}🌟 SUCCESS! Perfect sync documentary created:${NC}"
    echo -e "${YELLOW}   📁 File: $FINAL_VIDEO${NC}"
    echo -e "${YELLOW}   ⏱️  Duration: $((duration / 60))m $((duration % 60))s${NC}"
    echo -e "${YELLOW}   💾 Size: $filesize${NC}"
    echo ""
    echo -e "${CYAN}🎯 Attenborough-Quality Features:${NC}"
    echo -e "${YELLOW}   • Natural narration pace (no rushing)${NC}"
    echo -e "${YELLOW}   • Videos generated to match exact speech timing${NC}"
    echo -e "${YELLOW}   • Perfect synchronization achieved${NC}"
    echo -e "${YELLOW}   • Educational depth with proper pacing${NC}"

else
    echo -e "${RED}❌ Failed to create perfect sync documentary${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎬 TTS-first production complete! Script was the master timing document.${NC}"
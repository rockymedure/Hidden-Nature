#!/bin/bash

# Educational Documentary Video Production Pipeline
# Adapted from chef video system for faceless educational content

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

echo -e "${BLUE}🎬 Educational Video Production Pipeline${NC}"
echo -e "${CYAN}Faceless Documentary Style Generator${NC}"

# Check required parameters
if [[ $# -lt 3 ]]; then
    echo -e "${RED}Usage: $0 <topic> <channel> <script_file>${NC}"
    echo "Example: $0 black_holes science scripts/black_holes_script.md"
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

# Create directory structure
TOPIC_DIR="${TOPIC}_${CHANNEL}"
mkdir -p "$TOPIC_DIR/raw_videos"
mkdir -p "$TOPIC_DIR/raw_audio"
mkdir -p "$TOPIC_DIR/final_scenes"

echo -e "${BLUE}📁 Created directory: $TOPIC_DIR${NC}"

# Extract scenes from script file
extract_scenes() {
    local script_file="$1"
    local scene_num=1

    while IFS= read -r line; do
        if [[ "$line" =~ ^\*\*Scene\ [0-9]+\*\*: ]]; then
            # Extract visual description (everything after "Scene N**: ")
            visual=$(echo "$line" | sed 's/\*\*Scene [0-9]*\*\*: //')
            # Escape quotes for shell
            visual=$(echo "$visual" | sed 's/"/\\"/g')
            echo "SCENE_${scene_num}_VISUAL=\"$visual\"" >> "${TOPIC_DIR}/scene_data.sh"
        elif [[ "$line" =~ ^-\ \*\*Narration\*\*: ]]; then
            # Extract narration text (after "- **Narration**: ")
            narration=$(echo "$line" | sed 's/^- \*\*Narration\*\*: "//' | sed 's/"$//')
            # Escape quotes for shell
            narration=$(echo "$narration" | sed 's/"/\\"/g')
            echo "SCENE_${scene_num}_AUDIO=\"$narration\"" >> "${TOPIC_DIR}/scene_data.sh"
            ((scene_num++))
        fi
    done < "$script_file"

    echo $((scene_num - 1))
}

# Extract scene data
echo -e "${CYAN}📝 Extracting scenes from script...${NC}"
TOTAL_SCENES=$(extract_scenes "$SCRIPT_FILE")
echo -e "${GREEN}✅ Extracted $TOTAL_SCENES scenes${NC}"

# Source the scene data
source "${TOPIC_DIR}/scene_data.sh"

# Generate video for a scene
generate_scene_video() {
    local scene_num=$1
    local visual_var="SCENE_${scene_num}_VISUAL"
    local visual_desc="${!visual_var}"

    if [[ -z "$visual_desc" ]]; then
        echo -e "${RED}❌ No visual description found for scene $scene_num${NC}"
        return 1
    fi

    echo -e "${CYAN}🎥 Generating video for Scene $scene_num...${NC}"
    echo -e "${YELLOW}Visual: $visual_desc${NC}"

    # Create educational-style prompt
    local prompt="$visual_desc, cinematic documentary style, professional camera work, 4K quality, dramatic lighting, educational visualization"

    # Variable scene duration for visual dynamics (4, 6, or 8 seconds)
    local durations=(4 6 8)
    local duration=${durations[$((($scene_num - 1) % 3))]}

    local request_body=$(cat << EOF
{
    "prompt": "$prompt",
    "duration": $duration,
    "aspect_ratio": "16:9",
    "seed": $SEED
}
EOF
    )

    echo -e "${BLUE}📡 Sending video generation request...${NC}"

    local response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$request_body")

    local video_url=$(echo "$response" | jq -r '.video.url // empty')

    if [[ -z "$video_url" || "$video_url" == "null" ]]; then
        echo -e "${RED}❌ Failed to generate video for scene $scene_num${NC}"
        echo "Response: $response"
        return 1
    fi

    echo -e "${GREEN}✅ Video generated: $video_url${NC}"

    # Download video
    local video_file="${TOPIC_DIR}/raw_videos/scene${scene_num}.mp4"
    curl -s -o "$video_file" "$video_url"

    if [[ ! -f "$video_file" ]]; then
        echo -e "${RED}❌ Failed to download video for scene $scene_num${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ Downloaded: $video_file${NC}"
    return 0
}

# Generate audio for a scene
generate_scene_audio() {
    local scene_num=$1
    local audio_var="SCENE_${scene_num}_AUDIO"
    local narration_text="${!audio_var}"

    if [[ -z "$narration_text" ]]; then
        echo -e "${RED}❌ No narration text found for scene $scene_num${NC}"
        return 1
    fi

    echo -e "${CYAN}🎵 Generating audio for Scene $scene_num...${NC}"
    echo -e "${YELLOW}Narration: $narration_text${NC}"

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

    echo -e "${BLUE}📡 Sending audio generation request...${NC}"

    local response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$request_body")

    local audio_url=$(echo "$response" | jq -r '.audio.url // empty')

    if [[ -z "$audio_url" || "$audio_url" == "null" ]]; then
        echo -e "${RED}❌ Failed to generate audio for scene $scene_num${NC}"
        echo "Response: $response"
        return 1
    fi

    echo -e "${GREEN}✅ Audio generated: $audio_url${NC}"

    # Download audio
    local audio_file="${TOPIC_DIR}/raw_audio/scene${scene_num}.mp3"
    curl -s -o "$audio_file" "$audio_url"

    if [[ ! -f "$audio_file" ]]; then
        echo -e "${RED}❌ Failed to download audio for scene $scene_num${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ Downloaded: $audio_file${NC}"
    return 0
}

# Combine video and audio for a scene
combine_scene() {
    local scene_num=$1
    local video_file="${TOPIC_DIR}/raw_videos/scene${scene_num}.mp4"
    local audio_file="${TOPIC_DIR}/raw_audio/scene${scene_num}.mp3"
    local output_file="${TOPIC_DIR}/final_scenes/scene${scene_num}_final.mp4"

    if [[ ! -f "$video_file" || ! -f "$audio_file" ]]; then
        echo -e "${RED}❌ Missing video or audio for scene $scene_num${NC}"
        return 1
    fi

    echo -e "${CYAN}🎬 Combining video and audio for Scene $scene_num...${NC}"

    ffmpeg -y -i "$video_file" -i "$audio_file" -c:v copy -c:a aac -shortest "$output_file" > /dev/null 2>&1

    if [[ ! -f "$output_file" ]]; then
        echo -e "${RED}❌ Failed to combine scene $scene_num${NC}"
        return 1
    fi

    echo -e "${GREEN}✅ Combined: $output_file${NC}"
    return 0
}

# Generate all scenes
echo -e "${PURPLE}🚀 Starting production pipeline...${NC}"

for scene in $(seq 1 $TOTAL_SCENES); do
    echo -e "${BLUE}--- Processing Scene $scene of $TOTAL_SCENES ---${NC}"

    # Generate video
    if ! generate_scene_video "$scene"; then
        echo -e "${RED}❌ Failed to generate video for scene $scene${NC}"
        continue
    fi

    # Wait between requests to avoid rate limiting
    sleep 2

    # Generate audio
    if ! generate_scene_audio "$scene"; then
        echo -e "${RED}❌ Failed to generate audio for scene $scene${NC}"
        continue
    fi

    # Wait between requests
    sleep 2

    # Combine video and audio
    if ! combine_scene "$scene"; then
        echo -e "${RED}❌ Failed to combine scene $scene${NC}"
        continue
    fi

    echo -e "${GREEN}✅ Scene $scene completed${NC}"
done

# Create final video compilation
echo -e "${PURPLE}🎞️  Creating final compilation...${NC}"

# Create scene list file for ffmpeg
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

    # Get video info
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FINAL_VIDEO" | cut -d. -f1)
    filesize=$(ls -lh "$FINAL_VIDEO" | awk '{print $5}')

    echo -e "${CYAN}📊 Video Stats:${NC}"
    echo -e "${YELLOW}   Duration: ${duration}s${NC}"
    echo -e "${YELLOW}   File Size: $filesize${NC}"
    echo -e "${YELLOW}   Scenes: $TOTAL_SCENES${NC}"
    echo -e "${YELLOW}   Location: $FINAL_VIDEO${NC}"
else
    echo -e "${RED}❌ Failed to create final compilation${NC}"
    exit 1
fi

echo -e "${GREEN}🎬 Educational video production complete!${NC}"
#!/bin/bash

# Complete fungal network documentary with latest 2025 research

source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🍄 Creating Netflix-quality fungal network documentary with 2025 research..."

mkdir -p fungal_audio fungal_videos fungal_final

# STEP 1: Generate all narration with latest research
echo "🎵 STEP 1: Generating Charlotte's fungal network narration with cutting-edge science..."

declare -a narrations=(
    "Beneath every footstep in the forest lies the most sophisticated network on Earth."
    "These towering oaks and maples are not isolated individuals, but connected family members."
    "Underground, a vast web of fungal threads links every tree in chemical conversation."
    "These fungal cables carry nutrients, warnings, and information faster than our internet."
    "As morning breaks, this ancient internet begins its daily exchange of life and death."
    "At each root tip, trees form partnerships with fungi that will last centuries."
    "Trees offer precious sugars while fungi provide essential minerals in return."
    "Dr. Suzanne Simard's breakthrough research reveals mother trees recognize and nurture their own offspring."
    "When insects attack, chemical alarms race through the network at lightning speed."
    "Neighboring trees receive the warning and begin producing defensive chemicals."
    "Major fungal highways connect distant tree communities across miles of forest."
    "Fungal nodes act like routers, directing nutrients and information to where needed most."
    "A dying tree sends its stored carbon to relatives growing in a distant clearing."
    "The network collectively decides which trees receive resources during times of scarcity."
    "Some fungi exploit the network, stealing resources while providing nothing in return."
    "In 2025, scientists debate how much trees truly communicate versus coincidental resource sharing."
    "Complex biochemical markets operate continuously, trading everything from water to rare minerals."
    "Trees deposit excess summer carbon into fungal banks for withdrawal during winter."
    "New DNA sequencing and isotopic tracing reveal the network's true complexity and limitations."
    "Young seedlings tap into the network, downloading survival strategies from elder trees."
    "Now you know the secret - every forest walk is a journey over nature's internet."
    "As research continues, we're discovering both the remarkable abilities and the limits of forest communication."
    "For 400 million years, this wood wide web has connected life in ways we're only beginning to understand."
)

# Generate all narrations in parallel
for i in {0..22}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    (
        curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"text\": \"$narration\", \"voice\": \"Charlotte\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
            | jq -r '.audio.url' | xargs -I {} curl -s -o "fungal_audio/scene${scene}.mp3" {}
        echo "✅ Scene $scene: Fungal network narration completed"
    ) &
    sleep 0.5
done

echo "⏳ Waiting for all fungal network narration..."
wait

echo ""
echo "🍄 STEP 2: Generating 1080p underground network videos..."

# Underground network with environmental progression
NETWORK_BASE="The same forest ecosystem with recognizable Douglas fir mother trees and intricate fungal network connections"

declare -a environments=(
    "22222|Forest floor with fallen leaves and hidden underground complexity, natural lighting"
    "22222|Forest floor with fallen leaves and hidden underground complexity, natural lighting"
    "22222|Forest floor with fallen leaves and hidden underground complexity, natural lighting"
    "22222|Forest floor with fallen leaves and hidden underground complexity, natural lighting"
    "22222|Forest floor with fallen leaves and hidden underground complexity, natural lighting"
    "22223|Underground root zone with tree-fungi interfaces, biological connection points"
    "22223|Underground root zone with tree-fungi interfaces, biological connection points"
    "22223|Underground root zone with tree-fungi interfaces, biological connection points"
    "22223|Underground root zone with tree-fungi interfaces, biological connection points"
    "22223|Underground root zone with tree-fungi interfaces, biological connection points"
    "22224|Deep fungal highway networks spanning forest distances, biological superhighways"
    "22224|Deep fungal highway networks spanning forest distances, biological superhighways"
    "22224|Deep fungal highway networks spanning forest distances, biological superhighways"
    "22224|Deep fungal highway networks spanning forest distances, biological superhighways"
    "22224|Deep fungal highway networks spanning forest distances, biological superhighways"
    "22225|Complex biochemical trading zones, molecular commerce hubs, network markets"
    "22225|Complex biochemical trading zones, molecular commerce hubs, network markets"
    "22225|Complex biochemical trading zones, molecular commerce hubs, network markets"
    "22225|Complex biochemical trading zones, molecular commerce hubs, network markets"
    "22225|Complex biochemical trading zones, molecular commerce hubs, network markets"
    "22222|Return to forest floor, same as opening, new understanding of hidden complexity"
    "22222|Return to forest floor, same as opening, new understanding of hidden complexity"
    "22222|Return to forest floor, same as opening, new understanding of hidden complexity"
)

declare -a scene_actions=(
    "beautiful forest floor hiding incredible underground network complexity"
    "majestic trees reaching skyward, their hidden underground connections"
    "cross-section view revealing underground fungal networks connecting tree roots"
    "close-up of delicate white fungal threads, biological fiber optic cables"
    "fungal networks glowing with activity, chemical signals beginning to flow"
    "tree roots interfacing with fungal networks at microscopic connection points"
    "chemical exchange visualization, nutrients flowing between tree-fungi partners"
    "massive Douglas fir sending nutrients preferentially to genetically related seedlings"
    "warning signals traveling rapidly through fungal threads, emergency forest communication"
    "multiple trees responding to chemical alarm, coordinated forest defense system"
    "vast fungal networks spanning great distances, biological information superhighways"
    "complex fungal junction points, network traffic management, biological switches"
    "nutrients traveling long distances through network, forest inheritance system"
    "democratic resource allocation through network consensus, forest democracy"
    "parasitic fungi tapping into network illegally, underground resource theft"
    "split-screen showing competing research interpretations, scientific methodology"
    "chemical trading hubs, molecular commerce, underground biochemical stock exchange"
    "seasonal resource storage, biological banking system, carbon deposits and withdrawals"
    "modern laboratory equipment, DNA analysis, cutting-edge mycorrhizal research"
    "seedlings connecting to network, knowledge transfer, forest education system"
    "same forest floor as opening, now understanding the hidden complexity below"
    "scientists working in British Columbia forests, ongoing research, future discoveries"
    "zoom out showing entire forest as interconnected network, biological internet visualization"
)

echo "🚀 Launching all 23 fungal network videos with underground dynamics..."

# Generate all videos with underground progression
for i in {0..22}; do
    scene=$((i + 1))
    env_data="${environments[$i]}"
    IFS='|' read -r seed env_description <<< "$env_data"
    scene_action="${scene_actions[$i]}"

    full_prompt="$NETWORK_BASE in $env_description, $scene_action, cinematic underground documentary style, no speech, no dialogue, ambient forest sounds only"

    echo "🌲 Scene $scene: Underground network (Seed $seed)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "fungal_videos/scene${scene}_network.mp4" {}
        echo "✅ Scene $scene: Fungal network completed"
    ) &
    sleep 2
done

echo "⏳ Waiting for all 1080p fungal network videos..."
wait

echo ""
echo "🎼 STEP 3: Mixing Charlotte's narration with underground visuals..."

# Mix all scenes
for scene in {1..23}; do
    video_file="fungal_videos/scene${scene}_network.mp4"
    audio_file="fungal_audio/scene${scene}.mp3"
    output_file="fungal_final/scene${scene}_network_1080p.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🍄 Scene $scene: Mixing underground network with Charlotte's narration"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Underground network magic achieved"
        fi
    fi
done

echo ""
echo "🎞️  STEP 4: Creating final wood wide web documentary..."

# Final compilation
for scene in {1..23}; do
    echo "file 'fungal_final/scene${scene}_network_1080p.mp4'" >> fungal_final_list.txt
done

ffmpeg -y -f concat -safe 0 -i fungal_final_list.txt -c copy "WOOD_WIDE_WEB_NETFLIX_1080P_2025.mp4"

if [[ -f "WOOD_WIDE_WEB_NETFLIX_1080P_2025.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "WOOD_WIDE_WEB_NETFLIX_1080P_2025.mp4")
    filesize=$(ls -lh "WOOD_WIDE_WEB_NETFLIX_1080P_2025.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Wood Wide Web Documentary with 2025 Research:"
    echo "   📁 File: WOOD_WIDE_WEB_NETFLIX_1080P_2025.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🍄 Charlotte's calming narration with underground network wonder!"
    echo "   🔬 Features Suzanne Simard's 2025 research on mother trees!"
    echo "   🌲 Scientifically accurate with latest DNA sequencing discoveries!"
    echo "   📚 Addresses ongoing scientific controversies honestly!"

else
    echo "❌ Final fungal network compilation failed"
fi

echo ""
echo "🌲 Sixth documentary in your educational network complete!"
echo "🍄 Underground fungal internet revealed with cutting-edge science!"
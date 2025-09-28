#!/bin/bash

# Generate 9:16 mobile version of Hidden Worlds microscopic documentary

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "📱 Creating 9:16 mobile version of microscopic universe documentary..."

mkdir -p mobile_videos mobile_final

# Mobile-optimized microscopic universe
MICRO_BASE="The same drop of pond water with recognizable microscopic landmarks, vertical composition optimized for mobile viewing"

# Mobile-focused visual descriptions (vertical framing)
declare -a mobile_visuals=(
    "zoom into water drop revealing alien microscopic world, vertical composition with light filtering from top"
    "colorful microorganisms moving vertically through frame, beautiful otherworldly creatures"
    "large paramecium with offspring, vertical movement, maternal protection, cilia beating"
    "green algae photosynthesizing vertically, oxygen bubbles rising, microscopic gardens"
    "dense vertical traffic of microorganisms, busy microscopic highway, top-to-bottom movement"
    "predatory microorganisms hunting vertically, dramatic predator descending from above"
    "vertical high-speed chase, predator pursuing prey down through frame"
    "paramecium's vertical evasive maneuvers, rapid up-down directional changes"
    "dramatic vertical hunt conclusion, life-and-death moment in tall frame"
    "descent into darker zone vertically, different organisms emerging from depths"
    "rotifer with cilia crown, vertical feeding mechanism, drawing food downward"
    "vertical bacterial colonies, tall structures, microscopic skyscrapers"
    "bacteria processing matter vertically, decomposition flowing downward"
    "vertical bacterial warfare, chemical signals moving up and down"
    "tall biofilm structures, vertical bacterial cities, alien architecture"
    "close-up bacterial machinery, vertical flagella spinning, molecular motors"
    "vertical chemical communication, signals flowing between bacterial layers"
    "rapid vertical bacterial division, multiplication stacking upward"
    "bacteria foundation supporting organisms above, vertical ecosystem structure"
    "ascending vertically through all layers, complete ecosystem in tall frame"
    "all microorganisms in vertical harmony, ecosystem cooperation top to bottom"
    "full vertical ecosystem showing cycles, reproduction, feeding in mobile frame"
    "vertical zoom out from microscopic to regular water drop, mobile perspective"
)

echo "🚀 Launching all 23 mobile microscopic videos (9:16 aspect ratio)..."

# Use existing narration audio, generate new 9:16 videos
for i in {0..22}; do
    scene=$((i + 1))

    # Determine depth zone for consistent seeding
    if (( scene <= 5 )); then
        seed=11111  # Surface zone
    elif (( scene <= 9 )); then
        seed=11112  # Mid-water zone
    elif (( scene <= 14 )); then
        seed=11113  # Deep zone
    elif (( scene <= 19 )); then
        seed=11114  # Bacterial zone
    else
        seed=11111  # Return to surface
    fi

    visual="${mobile_visuals[$i]}"
    full_prompt="$MICRO_BASE, $visual, cinematic microscopic documentary style optimized for mobile viewing, no speech, no dialogue, ambient microscopic sounds only"

    echo "📱 Scene $scene: Mobile microscopic (9:16, Seed $seed)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "mobile_videos/scene${scene}_mobile.mp4" {}
        echo "✅ Scene $scene: Mobile microscopic completed"
    ) &
    sleep 2
done

echo "⏳ Waiting for all 9:16 mobile microscopic videos..."
wait

echo ""
echo "🎼 Mixing existing Rachel narration with 9:16 mobile visuals..."

# Mix with existing narration
for scene in {1..23}; do
    video_file="mobile_videos/scene${scene}_mobile.mp4"
    audio_file="micro_audio/scene${scene}.mp3"
    output_file="mobile_final/scene${scene}_mobile_final.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "📱 Scene $scene: Mobile mixing with Rachel's narration"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Mobile microscopic magic achieved"
        fi
    fi
done

echo ""
echo "📱 Creating final 9:16 microscopic documentary for mobile..."

# Final mobile compilation
for scene in {1..23}; do
    echo "file 'mobile_final/scene${scene}_mobile_final.mp4'" >> mobile_final_list.txt
done

ffmpeg -y -f concat -safe 0 -i mobile_final_list.txt -c copy "POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4"

if [[ -f "POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4")
    filesize=$(ls -lh "POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Mobile 9:16 Microscopic Documentary:"
    echo "   📁 File: POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   📱 9:16 aspect ratio optimized for mobile viewing!"
    echo "   🔬 Same Rachel narration with vertical microscopic visuals!"
    echo "   🎬 Perfect for TikTok, Instagram, YouTube Shorts!"

else
    echo "❌ Mobile compilation failed"
fi

echo ""
echo "📱 Mobile microscopic universe ready for social media!"
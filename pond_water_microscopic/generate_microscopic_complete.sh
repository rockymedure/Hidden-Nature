#!/bin/bash

# Complete microscopic pond water documentary production

source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🔬 Creating Netflix-quality microscopic universe documentary..."

mkdir -p micro_audio micro_videos micro_final

# STEP 1: Generate all narration first
echo "🎵 STEP 1: Generating Rachel's microscopic wonder narration..."

declare -a narrations=(
    "In a single drop of pond water lies a universe more alien than science fiction."
    "At the surface film, strange creatures glide like living jewels through liquid space."
    "This paramecium mother protects her young in a world where giants lurk everywhere."
    "Green algae capture sunlight, creating oxygen gardens that sustain this microscopic world."
    "Thousands of organisms navigate this liquid highway, each with their own destination."
    "In deeper water, the predators rule - creatures that would terrify us if enlarged."
    "A deadly pursuit unfolds as a hunter tracks its prey through forest of bacteria."
    "The paramecium spins and darts, using every trick evolution has given it to survive."
    "In seconds, the chase ends - in this world, survival is measured in heartbeats."
    "Deeper in our drop, where oxygen grows scarce, stranger creatures emerge."
    "This rotifer builds a living fortress, its spinning crown drawing food from current."
    "Vast forests of bacteria create landscapes as complex as any terrestrial ecosystem."
    "These organisms recycle death into life, breaking down matter for the ecosystem."
    "Some bacteria wage chemical warfare, releasing toxins to claim their territory."
    "In the deepest zone, bacteria build cities with architecture beyond human imagination."
    "Each bacterium is a molecular machine, more complex than any human technology."
    "Bacteria communicate through chemical signals, sharing information across their liquid world."
    "Every twenty minutes, each bacterium can divide, creating exponential population growth."
    "These simple organisms support every complex creature in our microscopic universe."
    "As we rise back toward the surface, the full complexity of this world becomes clear."
    "Each organism plays its part in a symphony of survival and cooperation."
    "This ancient dance of life continues as it has for billions of years."
    "In understanding this single drop, we glimpse the foundations of all life on Earth."
)

# Generate all narrations in parallel
for i in {0..22}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    (
        curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"text\": \"$narration\", \"voice\": \"Rachel\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
            | jq -r '.audio.url' | xargs -I {} curl -s -o "micro_audio/scene${scene}.mp3" {}
        echo "✅ Scene $scene: Microscopic narration completed"
    ) &
    sleep 0.5
done

echo "⏳ Waiting for all microscopic narration..."
wait

echo ""
echo "🔬 STEP 2: Generating 1080p microscopic videos with depth progression..."

# Microscopic environment database
MICRO_BASE="The same drop of pond water with recognizable microscopic landmarks and distinctive microorganisms"

declare -a environments=(
    "11111|Bright surface zone with penetrating light, surface tension effects, colorful microorganisms"
    "11111|Bright surface zone with penetrating light, surface tension effects, colorful microorganisms"
    "11111|Bright surface zone with penetrating light, surface tension effects, colorful microorganisms"
    "11111|Bright surface zone with penetrating light, surface tension effects, colorful microorganisms"
    "11111|Bright surface zone with penetrating light, surface tension effects, colorful microorganisms"
    "11112|Mid-water zone with moderate lighting, active predator-prey interactions, dense organism traffic"
    "11112|Mid-water zone with moderate lighting, active predator-prey interactions, dense organism traffic"
    "11112|Mid-water zone with moderate lighting, active predator-prey interactions, dense organism traffic"
    "11112|Mid-water zone with moderate lighting, active predator-prey interactions, dense organism traffic"
    "11113|Deeper zone with dimmer light, scarce oxygen, different organism types"
    "11113|Deeper zone with dimmer light, scarce oxygen, different organism types"
    "11113|Deeper zone with dimmer light, scarce oxygen, different organism types"
    "11113|Deeper zone with dimmer light, scarce oxygen, different organism types"
    "11113|Deeper zone with dimmer light, scarce oxygen, different organism types"
    "11114|Deepest bacterial zone with complex biofilm structures, molecular machinery visible"
    "11114|Deepest bacterial zone with complex biofilm structures, molecular machinery visible"
    "11114|Deepest bacterial zone with complex biofilm structures, molecular machinery visible"
    "11114|Deepest bacterial zone with complex biofilm structures, molecular machinery visible"
    "11114|Deepest bacterial zone with complex biofilm structures, molecular machinery visible"
    "11111|Return to bright surface zone, same as opening, full ecosystem perspective"
    "11111|Return to bright surface zone, same as opening, full ecosystem perspective"
    "11111|Return to bright surface zone, same as opening, full ecosystem perspective"
    "11111|Return to bright surface zone, same as opening, full ecosystem perspective"
)

declare -a scene_actions=(
    "zoom into water drop revealing alien microscopic world, light filtering through surface"
    "colorful microorganisms moving along surface tension, beautiful and otherworldly"
    "large paramecium with smaller offspring, cilia beating, protective maternal behavior"
    "green algae photosynthesizing, producing oxygen bubbles, microscopic gardens"
    "dense traffic of various microorganisms moving in different directions, busy highway"
    "predatory microorganisms hunting, dramatic predatory behavior at microscopic scale"
    "high-speed microscopic chase scene, predator pursuing victim through bacterial forest"
    "paramecium's evasive maneuvers, rapid directional changes, survival tactics"
    "dramatic conclusion of microscopic hunt, life-and-death moment"
    "descent into darker zone, different types of anaerobic organisms emerging"
    "rotifer with distinctive crown of cilia, feeding mechanism spinning"
    "dense bacterial colonies forming complex structures, microscopic landscape"
    "bacteria processing organic matter, recycling nutrients, decomposition"
    "bacterial colonies competing, chemical warfare, microscopic territorial conflict"
    "complex bacterial biofilms, structured communities, alien-like constructions"
    "close-up bacterial cell machinery, flagella spinning, molecular motors working"
    "chemical signals between bacteria, molecular communication, information transfer"
    "rapid bacterial division, exponential multiplication, population explosion"
    "bacteria as foundation supporting all other microorganisms in ecosystem"
    "ascending through all microscopic layers, showing complete ecosystem complexity"
    "all different microorganisms working together, ecosystem harmony"
    "full ecosystem view showing cycles, reproduction, feeding, recycling"
    "zoom out from microscopic world back to water drop, perspective shift"
)

echo "🚀 Launching all 23 microscopic videos with depth progression and 1080p quality..."

# Generate all videos with depth progression
for i in {0..22}; do
    scene=$((i + 1))
    env_data="${environments[$i]}"
    IFS='|' read -r seed env_description <<< "$env_data"
    scene_action="${scene_actions[$i]}"

    full_prompt="$MICRO_BASE in $env_description, $scene_action, cinematic microscopic documentary style, no speech, no dialogue, ambient microscopic sounds only"

    echo "🔬 Scene $scene: Microscopic depth zone (Seed $seed)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "micro_videos/scene${scene}_micro.mp4" {}
        echo "✅ Scene $scene: Microscopic universe completed"
    ) &
    sleep 2
done

echo "⏳ Waiting for all 1080p microscopic universe videos..."
wait

echo ""
echo "🎼 STEP 3: Mixing Rachel's scientific wonder with microscopic visuals..."

# Mix all scenes
for scene in {1..23}; do
    video_file="micro_videos/scene${scene}_micro.mp4"
    audio_file="micro_audio/scene${scene}.mp3"
    output_file="micro_final/scene${scene}_micro_1080p.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🔬 Scene $scene: Mixing microscopic wonder with Rachel's narration"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Microscopic magic achieved"
        fi
    fi
done

echo ""
echo "🎞️  STEP 4: Creating final microscopic universe documentary..."

# Final compilation
for scene in {1..23}; do
    echo "file 'micro_final/scene${scene}_micro_1080p.mp4'" >> micro_final_list.txt
done

ffmpeg -y -f concat -safe 0 -i micro_final_list.txt -c copy "POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4"

if [[ -f "POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4")
    filesize=$(ls -lh "POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Microscopic Universe Documentary:"
    echo "   📁 File: POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🔬 Rachel's scientific wonder with microscopic drama!"
    echo "   🦠 Invisible universe revealed in stunning detail!"
    echo "   🎬 New 'Hidden Worlds' channel launched!"

else
    echo "❌ Final microscopic compilation failed"
fi

echo ""
echo "🔬 Fifth documentary in your educational network complete!"
echo "🌟 Hidden Worlds channel successfully launched with microscopic storytelling!"
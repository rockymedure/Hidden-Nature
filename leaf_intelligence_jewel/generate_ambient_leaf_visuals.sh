#!/bin/bash

# Ambient Leaf Documentary - Pure Visual Experience
# New seed range for completely different visuals

source ../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🍃 Creating Ambient Leaf Visual Journey"
echo "🎬 Using new seed range (70000-70023) for fresh visuals"

mkdir -p ambient_leaf_videos

# Ambient visual descriptions - focusing on pure visual beauty
declare -a ambient_visuals=(
    "Dewdrops on leaf surfaces at golden hour, prismatic light refraction, macro detail"
    "Wind dancing through bamboo leaves, rhythmic movement, zen garden atmosphere"
    "Rainforest canopy from below, sunlight filtering through layers of green, cathedral light"
    "Autumn leaves floating on still water, perfect reflections, meditation pond"
    "Frost crystallizing on leaf veins, time-lapse formation, winter magic"
    "Tropical leaves with rain cascading, slow motion water droplets, monsoon beauty"
    "Desert succulents in moonlight, silver edges glowing, night photography"
    "Cherry blossom petals and leaves, spring breeze, Japanese garden aesthetic"
    "Fern fronds unfurling in time-lapse, fibonacci spirals, mathematical beauty"
    "Backlit maple leaves, translucent veins visible, autumn gold light"
    "Morning mist through redwood forest leaves, ethereal atmosphere, giants awakening"
    "Lotus leaves on water, concentric ripples, zen meditation"
    "Pine needles with snow melting, macro drops, spring thaw"
    "Jungle leaves during golden rain, light shafts, tropical paradise"
    "Oak leaves changing colors, time-lapse transition, seasonal cycle"
    "Moss-covered leaves in ancient forest, emerald textures, timeless"
    "Willow leaves touching water surface, gentle movements, peaceful stream"
    "Ginkgo leaves falling in slow motion, golden carpet, ancient tree"
    "Palm fronds in ocean breeze, tropical sunset, paradise silhouettes"
    "Forest floor covered in fallen leaves, mushrooms emerging, cycle of life"
    "Vine leaves climbing ancient walls, time-lapse growth, nature reclaiming"
    "Eucalyptus leaves in fog, mysterious atmosphere, australian bush"
    "Leaf shadows dancing on forest floor, dappled light patterns, natural art"
    "All leaf types in harmony, visual symphony, celebration of green life"
)

echo "🚀 Generating 24 ambient leaf visuals..."

for i in {0..23}; do
    scene=$((i + 1))
    seed=$((70000 + i))  # New seed range: 70000 → 70023
    visual="${ambient_visuals[$i]}"

    full_prompt="$visual, cinematic photography, ambient documentary style, no text, no labels, pure nature, meditative quality"

    echo "🍃 Scene $scene: Generating ambient visual (seed $seed)"

    (
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}")

        # Save response for recovery
        echo "$response" > "ambient_leaf_videos/scene${scene}_response.json"

        # Extract and download video
        video_url=$(echo "$response" | jq -r '.video.url')

        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "ambient_leaf_videos/scene${scene}.mp4" "$video_url"
            echo "✅ Scene $scene: Ambient visual complete"
        else
            echo "❌ Scene $scene: Failed to generate"
        fi
    ) &
    sleep 2
done

echo "⏳ Waiting for all ambient visuals..."
wait

echo ""
echo "🎵 Ready for ambient music overlay!"
echo "📁 Videos saved in ambient_leaf_videos/"
echo ""
echo "The videos will be in order this time since we're saving them immediately as they complete!"
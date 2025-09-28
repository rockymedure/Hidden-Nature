#!/bin/bash

# Resubmit Leaf Videos to Get URLs
# Since videos are already generated, this should return existing URLs quickly

source ../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🍃 Retrieving Leaf Intelligence Video URLs"
echo "📊 Missing scenes: 3, 5-24"

mkdir -p leaf_videos

# Visual descriptions from original script
declare -a visuals=(
    "Pre-dawn forest with leaves subtly moving and adjusting position, preparing for photosynthesis, misty atmosphere"
    "Ancient fern-like leaves in primordial forest, simple early leaf structures, prehistoric atmosphere"
    "Extreme close-up of leaf surface showing stomata opening and closing like tiny mouths, microscopic detail"
    "Leaf being eaten by caterpillar, chemical vapors rising and spreading to nearby leaves, emergency response"
    "Underground view showing root systems connected by glowing fungal networks, data flowing between trees"
    "Thick, waxy succulent leaves in harsh desert landscape, water droplets visible inside translucent tissues"
    "Extreme microscopic view of waxy leaf surface with chimney-like structures around stomata, desert protection"
    "Cactus pads at night with stomata opening, cool desert evening, CAM photosynthesis in action"
    "Time-lapse of leaves moving throughout day and night cycle, internal clock visualization, rhythmic motion"
    "Sunflower field with leaves tracking sun's movement across sky, mechanical precision in plant movement"
    "Sensitive plant leaves folding instantly when touched, rapid defensive movement, electrical signals"
    "Bromeliad plant with leaves forming water-collecting channels, raindrops flowing down leaf surfaces"
    "Pine needles covered in frost, cross-section showing internal structure, winter adaptation"
    "Deciduous tree transitioning from green to brilliant fall colors, pigment chemistry in action"
    "Venus flytrap leaves with trigger hairs, insects landing, rapid snap-trap closure, carnivorous adaptation"
    "Giant tropical leaves in rainforest canopy, dappled light filtering through, massive surface area"
    "Prairie grass leaves bending gracefully in strong wind, flexible stems, wind resistance"
    "Arctic plant leaves covered in ice but remaining functional, antifreeze proteins visualization"
    "Eucalyptus forest with oils visible as vapors, allelopathic effects, chemical dominance"
    "Aloe plant with gel-filled leaves, healing compounds visible, medicinal properties"
    "Water lily pads floating on lake surface, air channels visible, aquatic adaptation"
    "Electrical signals traveling through leaf veins, bioelectric communication, nerve-like plant responses"
    "Comparison of naive vs experienced leaves, defense compound production, plant memory"
    "Montage of all leaf types, photosynthesis happening, oxygen being released, the cycle of life"
)

# Only process missing scenes
missing_scenes=(3 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24)

echo "🚀 Retrieving videos for ${#missing_scenes[@]} missing scenes..."
echo "(These should return quickly as they're already generated)"
echo ""

for scene in "${missing_scenes[@]}"; do
    i=$((scene - 1))
    seed=$((60000 + i))
    visual="${visuals[$i]}"

    full_prompt="$visual, macro photography style, botanical detail, scientific documentary, living plant behavior, no speech, ambient only"

    echo "🍃 Scene $scene: Retrieving video (seed $seed)..."

    # Submit request and get URL
    response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}")

    # Extract video URL
    video_url=$(echo "$response" | jq -r '.video.url' 2>/dev/null)

    if [[ -n "$video_url" && "$video_url" != "null" ]]; then
        echo "📥 Downloading scene $scene..."
        curl -s -o "leaf_videos/scene${scene}.mp4" "$video_url"

        if [[ -f "leaf_videos/scene${scene}.mp4" ]]; then
            filesize=$(ls -lh "leaf_videos/scene${scene}.mp4" | awk '{print $5}')
            echo "✅ Scene $scene: Downloaded ($filesize)"
        else
            echo "❌ Scene $scene: Download failed"
        fi
    else
        echo "❌ Scene $scene: Could not get video URL"
        echo "Response: $(echo "$response" | head -100)"
    fi

    sleep 2
done

echo ""
echo "📊 Download Complete!"

total_videos=$(find leaf_videos/ -name "*.mp4" | wc -l)
echo "📁 Total videos now: $total_videos/24"

if [[ $total_videos -eq 24 ]]; then
    echo "🎉 All leaf intelligence videos are ready!"
    echo "🎬 You can now continue with audio mixing and final compilation!"
else
    echo "⚠️  Still missing $((24 - total_videos)) videos"
fi
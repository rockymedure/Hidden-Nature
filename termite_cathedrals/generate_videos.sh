#!/bin/bash
# Termite Cathedrals - Video Generation Script
# Generates all 24 videos in parallel using Veo3

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

# Visual consistency parameters
DOCUMENTARY_STYLE="Science documentary with cinematic macro photography"
LIGHTING="Natural African savanna lighting with warm golden tones, dramatic sunrise/sunset, professional backlighting"
CAMERA_APPROACH="Mix of wide landscape shots and extreme macro close-ups, shallow depth of field"
COLOR_PALETTE="Warm earth tones - browns, ochres, golds, natural African savanna colors"
ENVIRONMENTAL_CONTEXT="African savanna setting, professional wildlife documentary aesthetic, educational visualization"

# Create output directory
mkdir -p documentary/videos

echo "🎥 Generating all videos in parallel..."
echo "📹 Format: 16:9, 1080p, 8 seconds"
echo ""

# Visual descriptions array (corresponding to narrations)
declare -a visuals=(
    "Wide shot of massive termite mound rising against golden sunset sky, dramatic silhouette, African landscape stretching behind, cinematic establishing shot"
    "Close-up macro shot of tiny worker termites moving across mound surface, size comparison evident, shallow depth of field highlighting scale"
    "Slow tilt up towering termite mound showing full height, vegetation at base for scale, architectural grandeur, time-lapse clouds passing"
    "Cross-section view of mound interior showing intricate tunnel network, chambers, passageways, complex three-dimensional structure, cutaway visualization"
    "Macro shot of ventilation chimneys on mound surface, air flow visible through heat shimmer, multiple openings creating texture"
    "Animated visualization showing air flow patterns, heat rising from central chamber, convection currents, thermal imaging aesthetic"
    "Split screen comparison - scorching savanna exterior versus cool, stable mound interior, thermometer visualization, climate control in action"
    "Extreme macro of wall structure showing texture, layered construction, material composition visible, structural integrity evident"
    "Rain pouring over termite mound, water running off hardened surface, structure standing firm against elements, durability showcase"
    "Macro shot of white fungus gardens in cultivation chambers, workers tending crops, agricultural system, symbiotic relationship"
    "Close-up of delicate fungus structures with moisture droplets, workers maintaining humidity levels, precision agriculture"
    "Massive pale queen termite surrounded by attendant workers, egg-laying in progress, scale comparison showing enormous abdomen"
    "Macro shot of soldier termite with huge mandibles, defensive posture, armor-like exoskeleton, warrior caste biology"
    "Time-lapse of workers building walls, carrying materials, coordinated construction activity, collective labor in action"
    "Swarm of termites working simultaneously on different tunnel sections, emergent order from individual actions, collective intelligence"
    "Visual comparison - tiny termite next to mound, then human next to hypothetical 2-mile skyscraper, scale perspective shift"
    "Ancient weathered termite cathedral in landscape, erosion patterns showing age, historical timeline visualization, monument to persistence"
    "Split screen - termite mound ventilation system alongside modern biomimicry architecture building, parallel innovation"
    "Time-lapse of mound surface activity, ventilation holes opening and closing, dynamic response to temperature changes"
    "Macro of workers breaking through wall to create new ventilation shaft, responsive engineering, problem-solving in action"
    "Workers rushing to damaged section, carrying soil particles, coordinated repair work, emergency response system"
    "Time-lapse of mound expansion over months, new sections appearing, organic growth pattern, architectural evolution"
    "Various animals inhabiting old termite mound - lizard emerging from hole, birds nesting, ecosystem transformation, legacy structure"
    "Final wide shot of termite cathedral at sunrise, workers visible on surface, golden light, monument to collective intelligence"
)

# Base seed for consistency
BASE_SEED=77000

# Generate ALL videos in PARALLEL
for i in {0..23}; do
    scene=$((i + 1))
    seed=$((BASE_SEED + i))
    visual="${visuals[$i]}"

    # Build full prompt with consistency strategy
    full_prompt="$visual, $DOCUMENTARY_STYLE, $CAMERA_APPROACH, $LIGHTING, $COLOR_PALETTE, $ENVIRONMENTAL_CONTEXT, no speech, ambient only"

    (
        echo "🎥 Scene $scene: Generating video (seed $seed)..."
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"prompt\": \"$full_prompt\",
                \"duration\": 8,
                \"aspect_ratio\": \"16:9\",
                \"resolution\": \"1080p\",
                \"seed\": $seed,
                \"generate_audio\": true
            }")

        # Save response for debugging
        echo "$response" > "documentary/responses/video_scene${scene}.json"

        video_url=$(echo "$response" | jq -r '.video.url')
        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "documentary/videos/scene${scene}.mp4" "$video_url"
            echo "✅ Scene $scene: Video saved"
        else
            echo "❌ Scene $scene: Video generation failed"
            echo "Response: $response"
        fi
    ) &

    # Stagger API calls to avoid rate limits
    sleep 2
done

echo ""
echo "⏳ Waiting for all videos to complete..."
echo "   (This may take 5-10 minutes)"
wait

echo ""
echo "✅ All videos generated!"
echo ""

# Count successful videos
success_count=$(ls -1 documentary/videos/scene*.mp4 2>/dev/null | wc -l)
echo "📊 Success: $success_count / 24 videos"

if [[ $success_count -eq 24 ]]; then
    echo "🎉 100% success rate! Ready for audio mixing."
else
    echo "⚠️  Some videos failed. Check documentary/responses/ for error details."
fi

#!/bin/bash
# Liquid Starlight - Video Generation Script
# Generates all 24 videos in parallel using Veo3

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

# Visual consistency parameters
DOCUMENTARY_STYLE="Visual beauty documentary with cinematic nature photography"
BIOLUMINESCENCE_LIGHTING="Long exposure night photography, electric blue bioluminescent glow, dark backgrounds"
AERIAL_LIGHTING="Natural daylight, vibrant color saturation, rich blues and greens"
SATELLITE_LIGHTING="High-resolution satellite imagery, Earth from space perspective, vivid natural colors"
COLOR_PALETTE="Electric blues, emerald greens, turquoise, crimson reds, deep ocean colors"
CAMERA_APPROACH="Progressive scale transitions from microscopic to satellite, smooth zoom aesthetics, professional nature documentary"

# Create output directory
mkdir -p documentary/videos

echo "🎥 Generating all videos in parallel..."
echo "📹 Format: 16:9, 1080p, 8 seconds"
echo ""

# Visual descriptions array (corresponding to narrations)
declare -a visuals=(
    "Dark beach at night, single wave crashes and explodes with brilliant electric blue bioluminescence, ethereal glow spreading across foam, magical opening shot"
    "Microscopic view of dinoflagellate algae, transparent single-celled organisms with delicate features, close-up showing internal structures, scientific beauty"
    "Extreme macro of dinoflagellate glowing, blue light emanating from within cell, chemical reaction visible, bioluminescent flash captured in slow motion"
    "Hand touching dark water surface, ripples spreading outward with blue glow following every movement, trails of light, interactive beauty"
    "Series of waves breaking at night, each explosion creating curtains of blue light, long exposure showing light trails, rhythmic beauty"
    "Kayaker paddling at night, every stroke creating glowing blue swirls in water, magical light trails following movement, dreamlike scene"
    "Person walking along shoreline at night, footprints glowing bright blue with each step, beach transformed into glowing pathway"
    "Dolphins swimming through glowing water at night, bodies creating glowing silhouettes, trails of blue light following their movements, nature's light show"
    "Deep ocean scene with various bioluminescent organisms, jellyfish, algae, showing diversity of ocean light, evolutionary perspective"
    "Transition shot - morning light on ocean surface, hint of color in water, scale beginning to shift, bridge between night beauty and day beauty"
    "Aerial view of coastline with visible algae bloom, turquoise and emerald streaks in water, patterns following currents, daytime beauty revealed"
    "Higher aerial view showing larger bloom patterns, Van Gogh-like swirls in ocean, artistic composition, blues and greens mixing"
    "Time-lapse of bloom shifting and swirling, colors moving like paint in water, natural choreography, dynamic beauty"
    "Aerial view of red tide algae bloom, crimson and burgundy colors in water, dramatic color contrast against blue ocean, jewel-like appearance"
    "Bright green algae bloom in calm bay, intense emerald color, almost unnatural vibrancy, gem-like water"
    "Satellite imagery showing massive algae bloom from orbit, swirling patterns visible from space, Earth's living art, scale perspective shift"
    "Satellite image showing spiral bloom pattern, resembling spiral galaxy, massive scale revealed, cosmic parallel"
    "Satellite view of Black Sea with characteristic turquoise bloom patterns, marbled appearance, geological beauty in living form"
    "Satellite view showing fractal-like bloom patterns, repeating patterns at different scales, mathematical beauty in nature"
    "View from International Space Station showing algae bloom on Earth below, human perspective from orbit, ultimate scale shift"
    "Zoom back down through scales - satellite to aerial to microscopic, showing connection between scales, continuity of beauty"
    "Split screen or transition showing bioluminescent hand touch morphing into satellite bloom view, connecting both scales of beauty"
    "Multi-scale montage - microscopic dinoflagellate, glowing wave, aerial bloom, satellite view - all showing same organism at different scales"
    "Final shot returning to bioluminescent wave at night, but now understanding the greater context, full circle moment, awe and appreciation"
)

# Base seed for consistency
BASE_SEED=55000

# Generate ALL videos in PARALLEL
for i in {0..23}; do
    scene=$((i + 1))
    seed=$((BASE_SEED + i))
    visual="${visuals[$i]}"

    # Adjust lighting and style based on scene type
    if [[ $scene -le 9 ]]; then
        # Bioluminescence scenes (1-9)
        scene_lighting="$BIOLUMINESCENCE_LIGHTING"
    elif [[ $scene -le 15 ]]; then
        # Aerial bloom scenes (10-15)
        scene_lighting="$AERIAL_LIGHTING"
    else
        # Satellite and transition scenes (16-24)
        scene_lighting="$SATELLITE_LIGHTING"
    fi

    # Build full prompt with consistency strategy
    full_prompt="$visual, $DOCUMENTARY_STYLE, $CAMERA_APPROACH, $scene_lighting, $COLOR_PALETTE, cinematic beauty, no speech, ambient only"

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

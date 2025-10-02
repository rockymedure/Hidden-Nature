#!/bin/bash
# Generate Field Journal Images using fal.ai nano-banana
# Creates photorealistic documentary-style images for each day

set -e

# Source .env file
if [ -f .env ]; then
    source .env
elif [ -f ../.env ]; then
    source ../.env
else
    echo "❌ Error: .env file not found"
    exit 1
fi

echo "📸 FIELD JOURNAL IMAGE GENERATION"
echo "=================================="
echo "Using fal.ai/nano-banana for photorealistic documentary images"
echo ""

# Create output directory
mkdir -p field_journal_images field_journal_responses

# Image prompts for each day
declare -a prompts=(
    # Day 1
    "Young female marine biologist Charlotte sitting on research vessel deck at golden hour, wetsuit half-zipped, diving gear organized around her, looking thoughtfully at the Pacific ocean horizon, warm sunset lighting, journal and camera equipment visible, professional but contemplative expression, photorealistic documentary photography style, 16:9 cinematic composition, natural beauty, turquoise water in background"
    
    # Day 5
    "Giant Pacific octopus Cosmos emerging majestically from dark rocky coral crevice, eight arms unfurling gracefully like flower petals, skin displaying vibrant maroon and electric blue chromatophore patterns, intelligent eyes clearly visible, surrounded by colorful reef fish, dramatic shafts of blue-green sunlight penetrating crystal-clear water, underwater documentary photography, National Geographic quality, 16:9 cinematic"
    
    # Day 8
    "Octopus Cosmos investigating clear acrylic jar containing live crab on coral reef floor, three arms extended toward jar in problem-solving posture, concentrated expression, skin showing focused patterns, marine life observing in background - butterflyfish and cleaner wrasse, shallow reef setting, underwater documentary style, natural lighting, photorealistic detail, 16:9"
    
    # Day 12
    "Octopus Cosmos arranging coconut shell halves and smooth stones around rocky fortress entrance, multiple arms working simultaneously like an engineer, construction materials scattered on sandy seafloor, defensive wall taking shape, tropical reef fish swimming overhead, underwater architectural documentation photography, detailed textures, natural light, 16:9 documentary composition"
    
    # Day 15
    "Wide-angle underwater reef community scene with Cosmos's fortress in center, neighboring octopuses visible in surrounding territories, reef sharks patrolling in background, colorful parrotfish and angelfish throughout, sea turtle gliding past, vibrant coral formations, ecosystem view showing biodiversity, documentary nature photography, depth and scale, 16:9 cinematic"
    
    # Day 19
    "Close-up split composition of two octopuses displaying color communication patterns - Cosmos on left with rippling waves of red moving from head to arms, another octopus on right responding with white pulses along tentacles, chromatophores clearly visible creating living patterns, coral reef background, underwater macro photography documenting color-language, 16:9 horizontal, scientific beauty"
    
    # Day 23
    "Night dive scene: Octopus Cosmos sleeping in his fortress, arms tucked carefully around body, skin displaying dreamlike flickering color patterns - blues and reds washing across in waves, bioluminescent particles floating in dark water, peaceful sleeping posture, intimate documentary night photography, minimal lighting showing natural behavior, mysterious and tender, 16:9"
    
    # Day 27
    "Underwater photographer's POV: Octopus Cosmos two feet from camera lens, making direct eye contact, one arm extended in gentle reaching gesture, skin in calm neutral tones, moment of interspecies recognition, crystal clear water, intimate connection captured, documentary photography showing mutual awareness, emotional depth, natural reef background slightly blurred, 16:9 composition"
    
    # Day 30
    "Aerial drone shot pulling back from vibrant Pacific coral reef at golden hour, Cosmos's territory visible as small dark spot among coral formations, research vessel in distance, vast ocean extending to horizon, journey completion perspective, documentary establishing shot showing context and scale, warm natural light, cinematic wide angle, 16:9, sense of belonging and home"
    
    # Epilogue
    "Charlotte on research vessel deck at dusk, reviewing underwater footage on camera screen, diving gear packed, ocean and coral reef in background, reflective expression, professional marine biologist at work, journal and notes scattered around, end of expedition atmosphere, documentary behind-the-scenes photography, natural evening light, authentic scientific documentation, 16:9"
)

declare -a day_labels=(
    "day1_charlotte_introduction"
    "day5_first_contact"
    "day8_the_search"
    "day12_engineering_genius"
    "day15_the_neighborhood"
    "day19_color_language"
    "day23_dreams_consciousness"
    "day27_recognition_moment"
    "day30_journey_complete"
    "epilogue_reflections"
)

# Generate images
ENDPOINT="https://fal.run/fal-ai/nano-banana"

for i in {0..9}; do
    label="${day_labels[$i]}"
    prompt="${prompts[$i]}"
    
    echo "📸 Generating: $label"
    echo "Prompt: ${prompt:0:80}..."
    
    # Call fal API
    response=$(curl -s -X POST "$ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"prompt\": \"$prompt\",
            \"num_images\": 1,
            \"output_format\": \"jpeg\"
        }")
    
    # Save response
    echo "$response" > "field_journal_responses/${label}.json"
    
    # Extract image URL and download
    image_url=$(echo "$response" | jq -r '.images[0].url')
    
    if [[ -n "$image_url" && "$image_url" != "null" ]]; then
        curl -s -o "field_journal_images/${label}.jpg" "$image_url"
        echo "✅ Saved: field_journal_images/${label}.jpg"
    else
        echo "❌ Failed to generate: $label"
        echo "Response: $response"
    fi
    
    echo ""
    sleep 2  # Rate limiting
done

echo ""
echo "✨ ================================== ✨"
echo "   FIELD JOURNAL IMAGES COMPLETE!"
echo "✨ ================================== ✨"
echo ""
echo "📊 Summary:"
echo "   Total Images: 10"
echo "   Output Directory: field_journal_images/"
echo "   Format: JPEG (optimized for Substack)"
echo ""
echo "📁 Generated Images:"
ls -lh field_journal_images/ | grep -v "^total" | awk '{print "   " $9 " (" $5 ")"}'
echo ""
echo "✅ Ready to upload to Substack article!"


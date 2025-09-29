#!/bin/bash

# The Secret Architecture of Seeds - CORRECTED Documentary Generator
# Following COMPLETE_DOCUMENTARY_SYSTEM.md exactly
# NARRATION FIRST with correct fal.ai endpoints

source ../../.env

# CORRECT ENDPOINTS FROM GUIDE
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🌱 The Secret Architecture of Seeds - ORACLE X PROFESSIONAL Production System"
echo "🎤 Using Oracle X voice (Professional tier) with ultra-precise timing (6.0-7.8s target)"
echo "🎨 Environmental consistency strategy: Scientific macro documentary approach"
echo "🔬 Seed drift range: 80000-80023 for thematic visual variety"
echo "⏰ Perfect sync fix: No more narration bleeding between scenes"
echo "🔥 UPGRADED: Professional Oracle X voice for enhanced documentary quality"
echo ""

mkdir -p seed_videos seed_responses seed_narrations seed_mixed

# Optimized narrations (15-20 words each for 6-8 second delivery)
declare -a narrations=(
    "Seeds crack concrete, survive centuries, travel oceans. Nature's survival capsules, engineered over 400 million years."
    "Maple seeds generate tornados above their wings. This vortex doubles lift - the same trick hummingbirds use."
    "Spinning seeds shed raindrops in milliseconds - shattering, flinging, even cutting drops in half to maintain flight."
    "Dandelions create impossible air bubbles. A vortex ring quadruples their drag, carrying seeds 150 kilometers on wind."
    "Squirting cucumbers fire seeds at 20 meters per second in 30 milliseconds. Nature's precision artillery launches offspring."
    "Coconuts are boats with fibrous husks, waterproof shells, internal water. They drift 5,000 kilometers across oceans."
    "Some seeds wait for fire. Sealed in resin for decades until extreme heat melts their prison."
    "A 1,300-year-old lotus seed sprouted perfectly. Hard shells create time capsules. Some seeds are immortal."
    "Before velcro, burdock perfected it. Hundreds of tiny hooks spread seeds along animal highways through hitchhiking."
    "Desert seeds are self-burying drills, corkscrewing into soil using only hydration physics to plant themselves perfectly."
    "Tension builds until explosion. Witch hazel shoots 10 meters. Violets use three-stage rockets launching seeds sequentially."
    "Seeds taste their environment - detecting temperature, day length, smoke, other plants. They're processing information, making decisions."
    "Orchid seeds are almost nothing - millions fit in thimbles, gambling everything on finding fungal partners."
    "Arctic lupine seeds frozen 10,000 years still germinate, surviving ice ages using antifreeze proteins and crystalline states."
    "Seeds come with ant food attached. Ants eat the reward and plant perfect nurseries underground."
    "Desert seeds count raindrops with special proteins. False starts mean death, so they measure duration carefully."
    "Tumbleweeds roll for miles, dropping 250,000 seeds across their journey. The plant itself becomes the vehicle."
    "Javan cucumber seeds glide with 12-centimeter wings, soaring from forest canopies using flying squirrel principles."
    "Seeds want to be eaten. Some need stomach acid to germinate. Birds become airlines with seeds as passengers."
    "Fibonacci spirals maximize seed packing. The golden angle ensures optimal space and light. Nature computes perfect solutions."
    "Seeds measure burial depth with pressure sensors, calculating exactly when they can reach the surface successfully."
    "Some seeds skip sex entirely. Dandelions clone, strawberries run, potatoes eye. Why gamble when conditions are perfect?"
    "Mangrove seeds germinate on parents, drop like torpedoes, spear into mud, instantly root or float for years."
    "Every seed: a library, spacecraft, time machine. Nature encoded ocean journeys, fire survival, ice ages in pockets."
)

# Visual descriptions for videos
declare -a visuals=(
    "Time-lapse of a seed sprouting through concrete cracks, roots breaking stone, powerful emergence"
    "Ultra slow-motion maple seed spinning in air, visible tornado vortex above wing, aerodynamic visualization"
    "Maple seed in rain, water drops shattering and flying off the spinning wing, slow motion"
    "Dandelion seed floating, air bubble ring visualization around white pappus bristles, ethereal flight"
    "High-speed capture of squirting cucumber violently ejecting seeds in mucilage jet, explosive dispersal"
    "Coconut floating in ocean waves, cross-section showing internal air chambers and water supply"
    "Pine cone opening in flames, seeds with wings spiraling down through smoke and embers"
    "Ancient lotus seed germinating, time-lapse of roots emerging from thousand-year-old shell"
    "Microscopic view of burdock burrs hooking onto animal fur, velcro-like structures"
    "Desert seed with spiral tail drilling into sand, corkscrew motion with moisture"
    "Multiple seed pods exploding simultaneously - witch hazel, touch-me-not, violet pods bursting"
    "Seeds in soil with chemical signals visualized as colored clouds, molecular communication"
    "Microscopic orchid seeds floating like golden dust motes in sunbeam, almost invisible"
    "Seeds preserved in ice crystals, permafrost cross-section, frozen for millennia"
    "Ants carrying seeds with white elaiosomes to underground nest, farming behavior"
    "Desert suddenly blooming after rain, thousands of seeds germinating simultaneously, time-lapse"
    "Tumbleweed rolling across landscape dropping seeds, plant skeleton dispersing offspring"
    "Javan cucumber seed gliding through forest canopy, transparent wing membranes catching air"
    "Bird eating red berries, X-ray view of seeds passing through digestive system intact"
    "Sunflower head showing Fibonacci spiral pattern, mathematical seed arrangement, golden ratio"
    "Seeds at different soil depths, pressure gradients visualized as color layers"
    "Strawberry runners spreading, dandelion clones, potato eyes sprouting, vegetative reproduction"
    "Mangrove propagule falling like green torpedo, spearing into coastal mud, instant rooting"
    "Montage of diverse seeds transforming into plants, forest emerging from handful of seeds"
)

# Environmental Consistency Strategy for Concept-Focused Documentary
DOCUMENTARY_STYLE="Scientific documentary with consistent macro photography approach"
LIGHTING="Professional studio lighting with natural backlighting for depth"
CAMERA_APPROACH="Macro lens perspective, shallow depth of field, controlled environment"
COLOR_PALETTE="Natural earth tones, consistent color grading throughout"
ENVIRONMENTAL_CONTEXT="Clean scientific presentation, laboratory-quality macro setups"

# STEP 1: Generate ALL Narrations FIRST in PARALLEL
echo "🎙️ STEP 1: Generating ALL narrations in PARALLEL with Oracle X voice (Professional)..."
echo "Using correct fal.ai ElevenLabs endpoint with Oracle X voice ID: 1hlpeD1ydbI2ow0Tt3EW"
echo ""

for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    echo "🎤 Scene $scene: Generating narration..."

    (
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration\",
                \"voice\": \"1hlpeD1ydbI2ow0Tt3EW\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 0.7,
                \"speed\": 1.0
            }")

        audio_url=$(echo "$response" | jq -r '.audio.url')

        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "seed_narrations/scene${scene}.mp3" "$audio_url"
            echo "✅ Scene $scene: Narration saved"
        else
            echo "❌ Scene $scene: Failed to generate narration"
        fi
    ) &

    # Small stagger to avoid rate limits
    if (( i % 4 == 3 )); then
        sleep 1
    else
        sleep 0.5
    fi
done

echo ""
echo "⏳ Waiting for all narrations to complete..."
wait

echo ""
echo "✅ All narrations complete!"
echo ""

# STEP 2: Measure and fix narration durations
echo "📏 STEP 2: Measuring narration durations and regenerating if needed..."
echo "Target: 6.0-7.8 seconds per scene (perfect sync with 8s videos)"
echo ""

declare -a scenes_to_regenerate=()

for i in {1..24}; do
    if [[ -f "seed_narrations/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "seed_narrations/scene${i}.mp3" 2>/dev/null)
        duration_int=${duration%.*}  # Convert to integer for comparison

        duration_float=$(printf "%.1f" $duration)
        if (( $(echo "$duration < 6.0" | bc -l) )) || (( $(echo "$duration > 7.8" | bc -l) )); then
            echo "❌ Scene $i: ${duration}s - NEEDS REGENERATION"
            scenes_to_regenerate+=($((i-1)))  # Add to regeneration list (0-indexed)
        else
            echo "✅ Scene $i: ${duration}s - Good"
        fi
    fi
done

# Regenerate any problematic narrations with adjusted text
if [[ ${#scenes_to_regenerate[@]} -gt 0 ]]; then
    echo ""
    echo "🔄 Regenerating ${#scenes_to_regenerate[@]} narrations with adjusted text..."

    # Ultra-compressed versions for perfect 7.5-second timing (10-12 words max)
    declare -a narrations_short=(
        "Seeds crack concrete, survive centuries. Evolution's survival capsules over millions of years."
        "Maple seeds create tornados above wings. Vortex doubles lift like hummingbirds."
        "Spinning seeds shed raindrops in milliseconds, shattering them to maintain perfect flight."
        "Dandelions create impossible air bubbles. Vortex rings carry seeds 150 kilometers."
        "Squirting cucumbers fire seeds at 20 meters per second. Nature's artillery system."
        "Coconuts are boats with hulls, waterproof shells. They drift thousands of kilometers."
        "Some seeds wait for fire, sealed in resin until heat melts prison."
        "A 1,300-year-old lotus seed sprouted perfectly. Hard shells create time capsules."
        "Before velcro, burdock perfected it. Tiny hooks spread seeds along highways."
        "Desert seeds are self-burying drills, corkscrewing into soil using hydration physics."
        "Tension builds until explosion. Witch hazel shoots 10 meters using rocket systems."
        "Seeds taste environments, detecting temperature, day length. They process information and decide."
        "Orchid seeds are almost nothing, millions fit in thimbles, gambling on partners."
        "Arctic seeds frozen 10,000 years still germinate using antifreeze proteins."
        "Seeds include ant food rewards. Ants eat treats and plant nurseries."
        "Desert seeds count raindrops with proteins. False starts mean death, measure carefully."
        "Tumbleweeds roll miles, dropping 250,000 seeds. The plant becomes the vehicle."
        "Javan cucumber seeds glide with wings, soaring from forest canopies like squirrels."
        "Seeds want to be eaten. Some need stomach acid. Birds become airlines."
        "Fibonacci spirals maximize packing. Golden angles ensure optimal space. Nature computes."
        "Seeds measure burial depth with sensors, calculating when they'll reach surface."
        "Some seeds skip sex. Dandelions clone, strawberries run, potatoes sprout."
        "Mangrove seeds germinate on parents, drop like torpedoes, spear mud, root."
        "Every seed: library, spacecraft, time machine. Ocean journeys encoded in pockets."
    )

    for idx in "${scenes_to_regenerate[@]}"; do
        scene=$((idx + 1))
        current_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "seed_narrations/scene${scene}.mp3" 2>/dev/null)
        duration_int=${current_duration%.*}

        # Choose appropriate text based on duration
        if (( $(echo "$current_duration > 7.8" | bc -l) )); then
            # Too long - use ultra-compressed version
            adjusted_text="${narrations_short[$idx]}"
            echo "🔄 Scene $scene: Using ultra-compressed text (was ${current_duration}s)"
        else
            # Too short - keep original (it might just need different delivery)
            adjusted_text="${narrations[$idx]}"
            echo "🔄 Scene $scene: Re-generating with original text (was ${current_duration}s)"
        fi

        (
            response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
                -H "Authorization: Key $FAL_API_KEY" \
                -H "Content-Type: application/json" \
                -d "{
                    \"text\": \"$adjusted_text\",
                    \"voice\": \"1hlpeD1ydbI2ow0Tt3EW\",
                    \"stability\": 0.5,
                    \"similarity_boost\": 0.75,
                    \"style\": 0.7,
                    \"speed\": 1.0
                }")

            audio_url=$(echo "$response" | jq -r '.audio.url')

            if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
                curl -s -o "seed_narrations/scene${scene}.mp3" "$audio_url"

                # Verify new duration
                new_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "seed_narrations/scene${scene}.mp3" 2>/dev/null)
                echo "✅ Scene $scene: Regenerated (${new_duration}s)"
            fi
        ) &

        sleep 0.5
    done

    wait
    echo "✅ All regenerations complete!"
fi

echo ""

# STEP 3: Generate Videos with seed drift
echo "🎥 STEP 3: Generating seed architecture videos..."
echo "(Using seed drift: 80000 → 80023)"
echo ""

for i in {0..23}; do
    scene=$((i + 1))
    seed=$((80000 + i))
    visual="${visuals[$i]}"

    full_prompt="$visual, $DOCUMENTARY_STYLE, $CAMERA_APPROACH, $LIGHTING, $COLOR_PALETTE, $ENVIRONMENTAL_CONTEXT, mechanical detail, time-lapse and slow-motion, nature's engineering, no speech, ambient only"

    echo "🌱 Scene $scene: Generating video (seed $seed)"

    (
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}")

        # Save response immediately
        echo "$response" > "seed_responses/scene${scene}_response.json"

        # Extract and download video
        video_url=$(echo "$response" | jq -r '.video.url')

        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "seed_videos/scene${scene}.mp4" "$video_url"
            echo "✅ Scene $scene: Video saved"
        else
            echo "❌ Scene $scene: Failed to generate"
        fi
    ) &

    # Stagger API calls
    if (( i % 3 == 2 )); then
        sleep 3
    else
        sleep 1
    fi
done

echo ""
echo "⏳ Waiting for all video generation tasks..."
wait

# STEP 4: Mix Audio and Video with PROVEN levels
echo ""
echo "🎬 STEP 4: Mixing videos with narration (0.25x ambient, 1.3x narration)..."

for i in {1..24}; do
    if [[ -f "seed_videos/scene${i}.mp4" && -f "seed_narrations/scene${i}.mp3" ]]; then
        echo "🔊 Mixing scene $i"

        ffmpeg -y -i "seed_videos/scene${i}.mp4" -i "seed_narrations/scene${i}.mp3" \
            -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac \
            "seed_mixed/scene${i}_mixed.mp4" 2>/dev/null
    fi
done

# STEP 5: Create Final Documentary
echo ""
echo "📽️ STEP 5: Compiling final documentary..."

> seed_playlist.txt
for i in {1..24}; do
    if [[ -f "seed_mixed/scene${i}_mixed.mp4" ]]; then
        echo "file 'seed_mixed/scene${i}_mixed.mp4'" >> seed_playlist.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i seed_playlist.txt -c copy "SEED_ARCHITECTURE_DOCUMENTARY.mp4" 2>/dev/null

if [[ -f "SEED_ARCHITECTURE_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "SEED_ARCHITECTURE_DOCUMENTARY.mp4" | cut -d. -f1)
    filesize=$(ls -lh "SEED_ARCHITECTURE_DOCUMENTARY.mp4" | awk '{print $5}')

    echo ""
    echo "✨ Documentary Complete!"
    echo "📁 File: SEED_ARCHITECTURE_DOCUMENTARY.mp4"
    echo "⏱️ Duration: $((duration / 60))m $((duration % 60))s"
    echo "💾 Size: $filesize"
    echo "🎤 Narrator: Oracle X (Professional)"
    echo "🎬 Seed drift: 80000-80023"
    echo ""
    echo "🌱 The Secret Architecture of Seeds - Ready to inspire!"
fi
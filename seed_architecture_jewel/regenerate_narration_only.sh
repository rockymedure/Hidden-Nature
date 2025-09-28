#!/bin/bash

# Seed Architecture - NARRATION ONLY Regeneration with Oracle X
# Reuses existing videos, generates only new Oracle X narrations

source ../.env

# CORRECT ENDPOINTS FROM GUIDE
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎤 NARRATION-ONLY REGENERATION: Oracle X Professional Voice"
echo "📹 Reusing existing 24 video files (no video generation)"
echo "🎙️ Generating NEW Oracle X narrations with ID: 1hlpeD1ydbI2ow0Tt3EW"
echo "🔄 Will remix existing videos with new Oracle X narrations"
echo ""

mkdir -p seed_narrations seed_mixed

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

# STEP 1: Generate ALL Oracle X Narrations FIRST in PARALLEL
echo "🎙️ STEP 1: Generating ALL narrations with Oracle X voice (Professional)..."
echo ""

for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    echo "🎤 Scene $scene: Generating Oracle X narration..."

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
            echo "✅ Scene $scene: Oracle X narration saved"
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
echo "⏳ Waiting for all Oracle X narrations to complete..."
wait

echo ""
echo "✅ All Oracle X narrations complete!"
echo ""

# STEP 2: Measure and fix narration durations
echo "📏 STEP 2: Measuring narration durations and regenerating if needed..."
echo "Target: 6.0-7.8 seconds per scene (perfect sync with 8s videos)"
echo ""

declare -a scenes_to_regenerate=()

for i in {1..24}; do
    if [[ -f "seed_narrations/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "seed_narrations/scene${i}.mp3" 2>/dev/null)
        
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

# CRITICAL: Pad all narrations to exactly 8.000 seconds to prevent bleeding
echo ""
echo "🔧 STEP 3: Padding all narrations to 8.000s (prevents audio bleeding)..."

for scene in {1..24}; do
    if [[ -f "seed_narrations/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "seed_narrations/scene${scene}.mp3" 2>/dev/null)
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "Scene $scene: ${duration}s → 8.000s (adding silence padding)"
            ffmpeg -y -i "seed_narrations/scene${scene}.mp3" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "seed_narrations/scene${scene}_padded.mp3" 2>/dev/null
            mv "seed_narrations/scene${scene}_padded.mp3" "seed_narrations/scene${scene}.mp3"
        fi
    fi
done

echo ""

# STEP 4: Mix NEW Oracle X narrations with EXISTING videos
echo "🎬 STEP 4: Mixing Oracle X narrations with existing videos..."

for i in {1..24}; do
    if [[ -f "seed_videos/scene${i}.mp4" && -f "seed_narrations/scene${i}.mp3" ]]; then
        echo "🔊 Mixing scene $i (Oracle X narration + existing video)"
        
        if [[ $i -eq 21 ]]; then
            # Scene 21: narration-only (no ambient audio)
            ffmpeg -y -i "seed_videos/scene${i}.mp4" -i "seed_narrations/scene${i}.mp3" \
                -filter_complex "[1:a]volume=1.3[narration]" \
                -map 0:v -map "[narration]" -c:v copy -c:a aac \
                "seed_mixed/scene${i}_mixed.mp4" 2>/dev/null
        else
            # All other scenes: normal ambient + narration mix
            ffmpeg -y -i "seed_videos/scene${i}.mp4" -i "seed_narrations/scene${i}.mp3" \
                -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
                -map 0:v -map "[audio]" -c:v copy -c:a aac \
                "seed_mixed/scene${i}_mixed.mp4" 2>/dev/null
        fi
    fi
done

# STEP 5: Create Final Documentary with Oracle X
echo ""
echo "📽️ STEP 5: Compiling Oracle X documentary..."

> seed_playlist.txt
for i in {1..24}; do
    if [[ -f "seed_mixed/scene${i}_mixed.mp4" ]]; then
        echo "file 'seed_mixed/scene${i}_mixed.mp4'" >> seed_playlist.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i seed_playlist.txt -c copy "SEED_ARCHITECTURE_DOCUMENTARY_ORACLE_X.mp4" 2>/dev/null

if [[ -f "SEED_ARCHITECTURE_DOCUMENTARY_ORACLE_X.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "SEED_ARCHITECTURE_DOCUMENTARY_ORACLE_X.mp4" | cut -d. -f1)
    filesize=$(ls -lh "SEED_ARCHITECTURE_DOCUMENTARY_ORACLE_X.mp4" | awk '{print $5}')

    echo ""
    echo "✨ ORACLE X Documentary Complete!"
    echo "📁 File: SEED_ARCHITECTURE_DOCUMENTARY_ORACLE_X.mp4"
    echo "⏱️ Duration: $((duration / 60))m $((duration % 60))s"
    echo "💾 Size: $filesize"
    echo "🎤 Narrator: Oracle X (Professional) - 1hlpeD1ydbI2ow0Tt3EW"
    echo "🎬 Seed drift: 80000-80023 (existing videos preserved)"
    echo "⚡ Efficient: Reused existing 24 videos, generated only new narrations"
    echo ""
    echo "🌱 The Secret Architecture of Seeds - Oracle X Professional Edition Ready!"
fi

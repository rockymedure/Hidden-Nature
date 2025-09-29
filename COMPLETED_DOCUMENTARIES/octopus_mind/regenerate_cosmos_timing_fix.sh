#!/bin/bash

# Cosmos Home Quest - TIMING FIX Regeneration
# Shorter integrated narrations maintaining abilities + emotional arc
# Target: 15-18 words for reliable 6-7 second delivery

source ../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🐙 Cosmos Home Quest - TIMING FIX Regeneration"
echo "📏 Regenerating all scenes with shorter integrated narrations"
echo "🎯 Target: 15-18 words (6-7 seconds) maintaining abilities + home quest"
echo "🎤 Voice: Arabella (Z3R5wn05IrDiVCyEkUrK)"
echo ""

# SHORTENED Integrated Narrations (15-18 words each)
declare -a short_integrated_narrations=(
    "Cosmos searches the reef for something every intelligent creature needs - a safe home."
    "Eight arms, three hearts, alien intelligence - Cosmos has the tools to claim perfect territory."
    "Each arm explores independently while Cosmos plans his ultimate territorial strategy for reef survival."
    "Cosmos faces his first home challenge - can his intelligence unlock this territorial puzzle?"
    "Cosmos examines potential sanctuary locations with precision, testing reef real estate for safety."
    "Success! Cosmos's intelligence proves he deserves a secure place in this competitive underwater neighborhood."
    "Cosmos gathers fortress materials, each shell chosen perfectly for building his future sanctuary home."
    "Cosmos's engineering genius builds his dream fortress where intelligence becomes living underwater architecture."
    "Cosmos tests every escape route from his new home, ensuring perfect security through flexibility."
    "Cosmos maps his neighborhood with photographic memory, mastering every path to his sanctuary."
    "Each challenge teaches Cosmos new home techniques, building his alien library of territorial knowledge."
    "Cosmos invents new security systems, proving intelligence means constantly improving one's living space."
    "Cosmos paints his territory in living colors, marking his home with artistic intelligence displays."
    "When intruders threaten his sanctuary, Cosmos disappears into his perfectly designed hiding spots."
    "Cosmos studies flatfish neighbors, learning to blend into the community surrounding his territory."
    "Sharks threaten Cosmos's home - his camouflage intelligence becomes fortress walls protecting everything built."
    "From his secure base, Cosmos communicates with neighbors, building connections that make territory home."
    "Cosmos's perfect camouflage transforms his home into ultimate hunting blind - intelligence creating advantage."
    "Safe in his fortress, Cosmos dreams in colors - his mind finally free to wander."
    "In his established home, Cosmos shows emotions only possible when intelligent minds find security."
    "Cosmos welcomes young visitors, sharing hard-won wisdom of building homes for alien intelligence."
    "Cosmos's unique sanctuary reflects his remarkable problem-solving personality in every architectural detail."
    "Recognizing Cosmos's territorial intelligence, we glimpse the universal need for home connecting all minds."
    "Cosmos moves through his domain with mastery - home achieved, intelligence celebrated, belonging found."
)

echo "🔄 REGENERATING ALL 24 SCENES with timing-optimized integrated narrations..."
echo ""

# Regenerate all scenes with proper timing
for i in {0..23}; do
    scene=$((i + 1))
    narration="${short_integrated_narrations[$i]}"
    word_count=$(echo "$narration" | wc -w)

    echo "🎤 Scene $scene: Regenerating ($word_count words, targeting 6-7s)..."

    (
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration\",
                \"voice\": \"Z3R5wn05IrDiVCyEkUrK\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 0.7,
                \"speed\": 1.0
            }")

        audio_url=$(echo "$response" | jq -r '.audio.url')

        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "cosmos_narrations_integrated/scene${scene}.mp3" "$audio_url"
            
            # Check new duration
            new_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cosmos_narrations_integrated/scene${scene}.mp3" 2>/dev/null)
            echo "✅ Scene $scene: Regenerated (${new_duration}s)"
        else
            echo "❌ Scene $scene: Failed to regenerate"
        fi
    ) &

    if (( i % 4 == 3 )); then
        sleep 1
    else
        sleep 0.5
    fi
done

echo ""
echo "⏳ Waiting for all timing fixes..."
wait

echo ""
echo "📏 VERIFICATION: Checking new timing (target: under 7.5s)..."

for i in {1..24}; do
    if [[ -f "cosmos_narrations_integrated/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cosmos_narrations_integrated/scene${i}.mp3" 2>/dev/null)
        if (( $(echo "$duration > 7.5" | bc -l) )); then
            echo "⚠️ Scene $i: ${duration}s - Still over target"
        else
            echo "✅ Scene $i: ${duration}s - Good timing"
        fi
    fi
done

echo ""
echo "🔧 STEP 4: MANDATORY 8.000s padding..."

# Pad all narrations to 8.000s
for scene in {1..24}; do
    if [[ -f "cosmos_narrations_integrated/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cosmos_narrations_integrated/scene${scene}.mp3" 2>/dev/null)
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            ffmpeg -y -i "cosmos_narrations_integrated/scene${scene}.mp3" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "cosmos_narrations_integrated/scene${scene}_padded.mp3" 2>/dev/null
            mv "cosmos_narrations_integrated/scene${scene}_padded.mp3" "cosmos_narrations_integrated/scene${scene}.mp3"
        fi
    fi
done

echo "✅ All timing-fixed narrations padded to perfect 8.000s"
echo ""
echo "🎬 Ready for smart mixing with existing character-consistent videos!"
echo "📽️ Run final assembly to complete COSMOS HOME QUEST documentary!"

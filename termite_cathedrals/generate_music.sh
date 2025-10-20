#!/bin/bash
# Termite Cathedrals - Music Generation Script
# Generates unique 8-second music for each scene using Stable Audio 2.5

source .env
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"

# Create output directory
mkdir -p documentary/music

echo "🎵 Generating scene-specific music in parallel..."
echo "🎼 Format: 8 seconds per scene, thematic coherence"
echo ""

# Scene-specific music prompts (24 scenes)
declare -a music_prompts=(
    "Epic orchestral opening with African drums, warm brass, sense of discovery and scale, cinematic documentary intro, 8 seconds"
    "Delicate pizzicato strings with curious woodwinds, intimate macro exploration, wonder at small scale, 8 seconds"
    "Rising orchestral swell with majestic horns, architectural grandeur, sense of height and achievement, 8 seconds"
    "Intricate clockwork-like percussion with mysterious strings, complexity and design, puzzle-solving atmosphere, 8 seconds"
    "Gentle flowing strings with airy flutes, air movement, breathing structure, natural ventilation feeling, 8 seconds"
    "Warm rising strings with subtle synth pad, convection and flow, science visualization music, 8 seconds"
    "Precise marimba with balanced harmony, temperature precision, scientific accuracy, climate control atmosphere, 8 seconds"
    "Earthy percussion with organic textures, construction sounds, material mixing, building process, 8 seconds"
    "Dramatic strings with rainfall percussion, durability and strength, weathering storms, resilience theme, 8 seconds"
    "Soft piano arpeggios with gentle synth pad, fungus gardens, agricultural wonder, cultivation atmosphere, 8 seconds"
    "Delicate music box melody with moisture sounds, precision humidity, delicate balance, careful maintenance, 8 seconds"
    "Deep bass tones with regal strings, queen majesty, biological engine, reproductive marvel, 8 seconds"
    "Martial snare drums with defensive brass, warrior caste, protection and duty, military precision, 8 seconds"
    "Busy rhythmic patterns with layered percussion, coordinated work, construction activity, collective labor, 8 seconds"
    "Swirling ensemble patterns with emergent harmony, collective intelligence, order from chaos, swarm beauty, 8 seconds"
    "Dramatic scale shift with ascending brass, perspective change, proportional comparison, mind-bending scale, 8 seconds"
    "Ancient ethnic instruments with time-passage ambience, historical depth, monument to persistence, timeless quality, 8 seconds"
    "Modern and ancient instruments blending, biomimicry, innovation inspired by nature, parallel wisdom, 8 seconds"
    "Breathing organic pads with rhythmic pulse, living organism, dynamic adaptation, responsive intelligence, 8 seconds"
    "Alert pizzicato strings with problem-solving piano, sensor detection, responsive engineering, intelligent architecture, 8 seconds"
    "Urgent repair theme with coordinated percussion, emergency response, rapid mobilization, crisis management, 8 seconds"
    "Growing orchestral theme with expanding harmony, organic growth, architectural evolution, natural expansion, 8 seconds"
    "Transitional strings with wildlife sounds, ecosystem transformation, legacy and renewal, life cycle continuation, 8 seconds"
    "Triumphant finale with warm brass and strings, wonder at collaboration, genius without consciousness, inspiring conclusion, 8 seconds"
)

# Generate all music clips in parallel (limit to 10 concurrent jobs to avoid rate limits)
for i in {0..23}; do
    scene=$((i + 1))
    prompt="${music_prompts[$i]}"

    (
        echo "🎵 Scene $scene: Generating music..."
        response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"prompt\": \"$prompt\",
                \"seconds_total\": 8,
                \"num_inference_steps\": 8,
                \"guidance_scale\": 7
            }")

        # Save response for debugging
        echo "$response" > "documentary/responses/music_scene${scene}.json"

        audio_url=$(echo "$response" | jq -r '.audio.url')

        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "documentary/music/scene${scene}_music.wav" "$audio_url"
            echo "✅ Scene $scene: Music generated"
        else
            echo "❌ Scene $scene: Music generation failed"
            echo "Response: $response"
        fi
    ) &

    # Limit concurrent jobs to 10
    if (( (i + 1) % 10 == 0 )); then
        echo "⏳ Waiting for batch to complete..."
        wait
    fi
done

echo ""
echo "⏳ Waiting for final music generation to complete..."
wait

echo ""
echo "✅ All music generated!"
echo ""

# Count successful music files
success_count=$(ls -1 documentary/music/scene*_music.wav 2>/dev/null | wc -l)
echo "📊 Success: $success_count / 24 music clips"

if [[ $success_count -eq 24 ]]; then
    echo "🎉 100% success rate! Ready for audio mixing."
else
    echo "⚠️  Some music generation failed. Check documentary/responses/ for error details."
fi

#!/bin/bash
# Liquid Starlight - Music Generation Script
# Generates unique 8-second music for each scene using Stable Audio 2.5

source .env
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"

# Create output directory
mkdir -p documentary/music

echo "🎵 Generating scene-specific music in parallel..."
echo "🎼 Format: 8 seconds per scene, ethereal to cosmic progression"
echo ""

# Scene-specific music prompts (24 scenes)
declare -a music_prompts=(
    "Ethereal ambient opening with mysterious synth pads, gentle ocean sounds, sense of wonder and magic, nighttime beach atmosphere, 8 seconds"
    "Delicate microscopic music, crystalline tones, intimate wonder, scientific curiosity, gentle celeste and glass-like textures, 8 seconds"
    "Soft glowing ambience with subtle pulse, bioluminescent feeling, gentle sparkle sounds, magical chemistry, 8 seconds"
    "Interactive gentle piano with rippling water sounds, responsive beauty, touching wonder, intimate connection, 8 seconds"
    "Rhythmic ambient waves with blue-toned synths, cascading patterns, oceanic pulse, hypnotic beauty, 8 seconds"
    "Dreamlike floating pads with gentle movement, kayaking through stars, peaceful wonder, ethereal journey, 8 seconds"
    "Magical footstep-like percussion with sparkling high notes, beach walk enchantment, playful wonder, 8 seconds"
    "Flowing underwater ambience with dolphin-like tones, joyful movement, nature's light show, dynamic beauty, 8 seconds"
    "Ancient deep ocean drones, evolutionary time scale, mystery and depth, primordial beauty, 8 seconds"
    "Transitional music shifting from night to day, dawn-like progression, scale beginning to expand, bridge moment, 8 seconds"
    "Aerial perspective music with sweeping strings, revealing larger beauty, daytime wonder, expansive view, 8 seconds"
    "Artistic swirling strings with impressionist piano, Van Gogh-like musical texture, painterly beauty, 8 seconds"
    "Time-lapse music with evolving harmonies, colors shifting, natural choreography, dynamic movement, 8 seconds"
    "Rich dramatic strings with ruby-red tones, jewel-like beauty, crimson atmosphere, intense color, 8 seconds"
    "Vibrant emerald-toned ambience with jade-like shimmer, gem beauty, lush green atmosphere, 8 seconds"
    "Cosmic scale music with space-like ambience, satellite perspective shift, orbital wonder, Earth from space, 8 seconds"
    "Spiral galaxy-like swirling harmonies, hundreds of miles wide perspective, cosmic parallel, massive scale, 8 seconds"
    "Marble-veined musical texture, geological beauty in sound, Black Sea atmosphere, sapphire tones, 8 seconds"
    "Mathematical fractal-like patterns in music, repeating motifs, Baltic beauty, order from chaos, 8 seconds"
    "Astronaut perspective music, beyond atmosphere, ultimate wonder, human spaceflight feeling, profound beauty, 8 seconds"
    "Descending through scales music, zoom-back atmosphere, connecting all perspectives, unified beauty, 8 seconds"
    "Connecting theme blending micro and macro, hand touch to satellite view, scale bridge, unified wonder, 8 seconds"
    "Multi-scale montage music, all perspectives united, comprehensive beauty, complete understanding, 8 seconds"
    "Triumphant ethereal finale returning to waves, full circle, wonder at every scale, inspiring conclusion, 8 seconds"
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

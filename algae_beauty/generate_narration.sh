#!/bin/bash
# Liquid Starlight - Narration Generation Script
# Generates all narrations in parallel using ElevenLabs TTS

source .env
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR="Arabella"

# Create output directory
mkdir -p documentary/audio

echo "🎙️  Generating all narrations in parallel..."
echo "📢 Narrator: $NARRATOR"
echo ""

# Extract narration texts into array (24 scenes)
declare -a narrations=(
    "On certain nights, the ocean glows with light that seems stolen from the stars."
    "This liquid starlight comes from algae smaller than a grain of sand."
    "Dinoflagellates create light through chemistry, a defense mechanism turned into art."
    "Touch the water, and they respond, painting your movement with living light."
    "Each wave becomes a canvas, crashing in cascades of electric blue."
    "Kayakers glide through darkness, their paddles trailing galaxies of glowing plankton."
    "Footprints sparkle on wet sand, each step triggering millions of microscopic flashes."
    "Dolphins surf through bioluminescent waves, their bodies outlined in living light."
    "This beauty is ancient, evolving over millions of years in endless darkness."
    "But dinoflagellates create more than nighttime magic, they paint on grander scales."
    "By day, algae blooms transform entire coastlines into swirling ribbons of color."
    "From above, these blooms become abstract masterpieces, nature's impressionist paintings."
    "Currents and tides choreograph the colors, creating art that lasts for days."
    "Some blooms glow red like liquid rubies scattered across the sea."
    "Others shimmer emerald green, turning bays into pools of liquid jade."
    "From satellite view, these blooms become visible from space, cosmic scale beauty."
    "They spiral like galaxies, hundreds of miles wide, painted by microscopic artists."
    "The Black Sea's turquoise blooms look like marble veins etched in sapphire."
    "The Baltic's blooms create fractals, mathematical beauty emerging from chaos."
    "These living paintings are visible to astronauts, beauty that reaches beyond our atmosphere."
    "Each bloom contains trillions of cells, every one capable of creating light."
    "The same organisms that glow under your hand paint pictures visible from the stars."
    "Beauty isn't fixed, it transforms with the scale at which you observe."
    "From glowing waves to cosmic art, algae reveal that wonder exists at every level."
)

# Generate ALL narrations in PARALLEL for maximum speed
for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    (
        echo "🎙️  Scene $scene: Generating narration..."
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration\",
                \"voice\": \"$NARRATOR\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 0.7,
                \"speed\": 1.0
            }")

        # Save response for debugging
        echo "$response" > "documentary/responses/narration_scene${scene}.json"

        audio_url=$(echo "$response" | jq -r '.audio.url')
        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "documentary/audio/scene${scene}.mp3" "$audio_url"
            echo "✅ Scene $scene: Narration saved"
        else
            echo "❌ Scene $scene: Narration generation failed"
            echo "Response: $response"
        fi
    ) &

    # Small delay to avoid API rate limits
    sleep 0.5
done

echo ""
echo "⏳ Waiting for all narrations to complete..."
wait

echo ""
echo "✅ All narrations generated!"
echo ""

# Count successful narrations
success_count=$(ls -1 documentary/audio/scene*.mp3 2>/dev/null | wc -l)
echo "📊 Success: $success_count / 24 narrations"

if [[ $success_count -eq 24 ]]; then
    echo "🎉 100% success rate! Ready for timing analysis."
else
    echo "⚠️  Some narrations failed. Check documentary/responses/ for error details."
fi

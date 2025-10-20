#!/bin/bash
# Termite Cathedrals - Narration Generation Script
# Generates all narrations in parallel using ElevenLabs TTS

source .env
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR="Rachel"

# Create output directory
mkdir -p documentary/audio

echo "🎙️  Generating all narrations in parallel..."
echo "📢 Narrator: $NARRATOR"
echo ""

# Extract narration texts into array (24 scenes)
declare -a narrations=(
    "Rising from the African savanna stand towers that dwarf their creators by thousands."
    "These are termite cathedrals, built by insects smaller than a grain of rice."
    "Some reach thirty feet tall, housing millions in climate-controlled perfection."
    "The secret lies in their architecture, designed without blueprints or architects."
    "Thousands of ventilation shafts regulate temperature and humidity with precision."
    "Hot air rises through central chimneys while cool air enters from below."
    "The result: a constant seventy-seven degrees, even when outside temperatures exceed one hundred."
    "The walls themselves are masterpieces, mixing soil with saliva and feces."
    "This cement hardens into something stronger than concrete, weathering decades of storms."
    "Inside, workers tend fungus gardens that feed the entire colony."
    "These gardens require exact humidity, another reason the ventilation system exists."
    "The queen resides deep within, laying thirty thousand eggs daily for decades."
    "Soldier termites guard the tunnels with massive jaws and chemical weapons."
    "Meanwhile, millions of workers construct, repair, and expand their cathedral constantly."
    "No single termite understands the plan, yet together they build perfection."
    "If humans built proportionally, we would construct towers two miles high."
    "The oldest known mounds have stood for over four thousand years."
    "Their designs inspired human architects creating sustainable buildings with natural ventilation."
    "Each mound is a living organism, breathing, adapting, responding to environment."
    "Sensors detect carbon dioxide levels, triggering construction of new air shafts."
    "When damage occurs, thousands mobilize within minutes to seal the breach."
    "The cathedral grows organically, adding new chambers as the colony expands."
    "Abandoned mounds become homes for lizards, snakes, and birds."
    "These tiny architects prove that genius requires no consciousness, only collaboration."
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

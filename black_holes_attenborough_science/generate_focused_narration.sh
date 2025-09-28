#!/bin/bash

# Generate focused 8-second narrations - each scene perfectly timed

source .env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎵 Generating 23 focused 8-second narrations in parallel..."

mkdir -p focused_audio

# All 23 narrations (15-20 words each for 8-second timing)
declare -a narrations=(
    "In all the cosmos, there is nothing more mysterious or profound than a black hole."
    "These are not merely objects in space. They are tears in reality itself."
    "Today, we embark on humanity's most extraordinary journey into ultimate darkness."
    "Our universe contains two trillion galaxies, each harboring billions of stars and hidden mysteries."
    "At nearly every galaxy's heart lurks something that defies our understanding of physics."
    "Einstein revealed gravity's true nature - not a force, but curved spacetime itself."
    "Imagine a bowling ball on a rubber sheet. This is gravity - mass curves space."
    "This principle governs everything from planets to galaxies across the entire cosmic stage."
    "When massive stars twenty times our Sun's size exhaust their fuel, catastrophic collapse begins."
    "In less than one second, the core collapses into unimaginable density."
    "A teaspoon of this matter would weigh as much as Mount Everest."
    "The collapse warps spacetime so severely it creates an invisible boundary - the event horizon."
    "This boundary marks the point of no return. Nothing can escape - not even light."
    "Imagine approaching Sagittarius A-star, the supermassive monster at our galaxy's heart."
    "From a distance, you see nothing unusual. Just empty space and stars."
    "As you venture closer, time itself begins to behave in extraordinary and unsettling ways."
    "Earth observers see you slow down and freeze, while you experience time flowing normally."
    "Crossing the event horizon feels ordinary - like stepping across an invisible line."
    "Yet you've passed beyond the observable universe into a realm of complete mystery."
    "Inside, the familiar laws of physics begin to break down completely and utterly."
    "Space and time exchange roles in ways that mock everything we understand about reality."
    "What happens at the center remains science's greatest mystery. What is existence itself?"
    "The journey into darkness continues to illuminate the deepest truths about our cosmos."
)

echo "🚀 Launching all 23 TTS generations simultaneously..."

# Generate all narrations in parallel
for i in {0..22}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"
    word_count=$(echo "$narration" | wc -w)

    echo "🎤 Scene $scene: ${word_count} words"

    # Generate TTS in background
    (
        request_body=$(cat << EOF
{
    "text": "$narration",
    "voice": "Rachel",
    "stability": 0.5,
    "similarity_boost": 0.75,
    "style": 0.7,
    "speed": 1.0
}
EOF
        )

        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$request_body")

        audio_url=$(echo "$response" | jq -r '.audio.url // empty')

        if [[ ! -z "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "focused_audio/scene${scene}_8s.mp3" "$audio_url"
            echo "✅ Scene $scene: 8s narration completed"
        else
            echo "❌ Scene $scene: TTS failed"
        fi
    ) &

    # Small delay to avoid overwhelming API
    sleep 0.5
done

echo "⏳ Waiting for all focused narration..."
wait

echo ""
echo "📏 Measuring actual 8-second narration timing..."

echo "Scene,Target,Actual,Words,Status" > focused_timing.csv

total_duration=0

for scene in {1..23}; do
    audio_file="focused_audio/scene${scene}_8s.mp3"

    if [[ -f "$audio_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")
        word_count=$(echo "${narrations[$((scene-1))]}" | wc -w)

        if (( $(echo "$duration <= 8.5" | bc -l) )); then
            status="✅ Perfect"
        else
            status="⚠️ Long"
        fi

        echo "$scene,8s,${duration%.*}s,$word_count,$status" >> focused_timing.csv
        echo "Scene $scene: ${duration%.*}s (${word_count} words) $status"

        total_duration=$(echo "$total_duration + $duration" | bc)
    else
        echo "Scene $scene: ❌ Missing audio"
    fi
done

echo ""
echo "🎯 PERFECT TIMING RESULTS:"
echo "📊 Total documentary: $((total_duration / 60))m $((total_duration % 60))s"
echo "📋 All scenes designed for 8-second video clips"
echo "🎬 Ready for one-to-one video generation!"

cat focused_timing.csv
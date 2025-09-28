#!/bin/bash

# Generate all dinosaur family narration using proven 8-second timing

source .env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🦕 Generating Netflix-quality dinosaur family narration..."

mkdir -p dinosaur_audio

# All 23 narrations (targeting 15-20 words for 8s timing)
declare -a narrations=(
    "As dawn breaks over the ancient forests of Patagonia, a family stirs from their slumber."
    "This is Carnotaurus - the meat-eating bull. A mother and her two nearly-grown young."
    "She weighs two tons and can run faster than any predator of her time."
    "Her offspring are still learning the ways of survival in this dangerous world."
    "The family hasn't eaten in three days. Today, they must hunt or face starvation."
    "The mother catches a scent that sparks her predatory instincts - fresh prey nearby."
    "A low rumble signals her young. The hunt is about to begin."
    "Moving with deadly precision, the family begins their coordinated approach through dense vegetation."
    "Their quarry - a herd of Saltasaurus, massive long-necked giants grazing peacefully."
    "Carnotaurus are ambush predators. Speed and surprise are their greatest weapons against giants."
    "In an explosive burst of speed, the mother launches her attack at forty miles per hour."
    "The herd erupts in panic. Thirty-ton giants flee in thunderous stampede across the landscape."
    "The juveniles watch intently, learning techniques they will need to master for survival."
    "A massive tail swings like a club, missing the mother by mere inches."
    "Success. An older Saltasaurus, separated from the herd, becomes their hard-won meal."
    "For the first time in days, the family feeds together in the gathering dusk."
    "With bellies full, the young play while their mother keeps watch over them."
    "As darkness approaches, the family seeks shelter in the protective embrace of ancient trees."
    "Even in rest, the mother remains alert to dangers that prowl the prehistoric night."
    "Tomorrow will bring new challenges, new hunts, and new lessons for survival."
    "In this world of giants and predators, family bonds are the key to survival."
    "These magnificent hunters ruled their world for millions of years before vanishing forever."
    "Yet through science and imagination, we can witness their daily struggles and triumphs once more."
)

echo "🚀 Launching all 23 dinosaur narrations in parallel..."

# Generate all narrations simultaneously
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
    "voice": "Roger",
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
            curl -s -o "dinosaur_audio/scene${scene}_dino.mp3" "$audio_url"
            echo "✅ Scene $scene: Dinosaur narration completed"
        else
            echo "❌ Scene $scene: TTS failed"
        fi
    ) &

    sleep 0.5
done

echo "⏳ Waiting for all dinosaur narration..."
wait

echo ""
echo "📏 Measuring dinosaur narration timing..."

echo "Scene,Duration,Words,Status" > dinosaur_timing.csv
total_duration=0

for scene in {1..23}; do
    audio_file="dinosaur_audio/scene${scene}_dino.mp3"

    if [[ -f "$audio_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")
        word_count=$(echo "${narrations[$((scene-1))]}" | wc -w)

        if (( $(echo "$duration <= 8.5" | bc -l) )); then
            status="✅ Perfect"
        else
            status="⚠️ Long"
        fi

        echo "$scene,${duration%.*}s,$word_count,$status" >> dinosaur_timing.csv
        echo "Scene $scene: ${duration%.*}s (${word_count} words) $status"

        total_duration=$(echo "$total_duration + $duration" | bc)
    else
        echo "Scene $scene: ❌ Missing audio"
    fi
done

echo ""
echo "🦕 DINOSAUR FAMILY DOCUMENTARY READY:"
echo "📊 Total runtime: $((total_duration / 60))m $((total_duration % 60))s"
echo "🎬 Netflix-quality family drama with educational depth!"

cat dinosaur_timing.csv
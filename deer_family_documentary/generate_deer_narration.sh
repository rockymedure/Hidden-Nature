#!/bin/bash

# Generate deer family narration with proven timing

source .env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🦌 Generating Netflix-quality deer family narration..."

mkdir -p deer_audio

# All 23 narrations (targeting 15-20 words for 8s timing)
declare -a narrations=(
    "As morning light filters through the ancient oak forest, a family begins their day."
    "This white-tailed doe has kept her twin fawns alive through their first summer."
    "Her young are now old enough to explore, but still dependent on her wisdom."
    "The family needs fresh browse, and the meadow grass is nearly exhausted."
    "The mother leads her young toward the crystal stream where tender shoots grow."
    "Here, fresh watercress and young willow saplings provide the perfect morning meal."
    "The fawns watch carefully as their mother demonstrates which plants are safe."
    "Cool, clear water refreshes the family after their morning journey."
    "With bellies full, the family ventures into the sun-drenched meadow to play."
    "The young ones bound and leap, building strength and coordination for survival."
    "Every game serves a purpose - learning to flee from danger at a moment's notice."
    "Just a squirrel in the underbrush, but the lesson in vigilance is learned."
    "As the sun climbs higher, the family seeks the cool sanctuary of deep woods."
    "In the protective embrace of ancient trees, they find the perfect resting spot."
    "The fawns doze while their mother keeps one ear always alert for danger."
    "As shadows lengthen, the family prepares for the afternoon's adventures."
    "The mother leads them up the rocky slope to survey their territory."
    "From this vantage point, she can spot both food sources and potential threats."
    "The fawns learn the boundaries of their world and the paths to safety."
    "As evening approaches, the family returns to the safety of familiar ground."
    "The meadow's evening dew makes the grass sweet and tender once again."
    "The fawns settle close to their mother as twilight deepens around them."
    "Safe in their mother's care, the young ones dream of tomorrow's discoveries."
)

echo "🚀 Launching all 23 deer narrations in parallel..."

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
    "voice": "Charlotte",
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
            curl -s -o "deer_audio/scene${scene}_deer.mp3" "$audio_url"
            echo "✅ Scene $scene: Deer narration completed"
        else
            echo "❌ Scene $scene: TTS failed"
        fi
    ) &

    sleep 0.5
done

echo "⏳ Waiting for all deer narration..."
wait

echo ""
echo "📏 Measuring deer narration timing..."

echo "Scene,Duration,Words,Status" > deer_timing.csv

for scene in {1..23}; do
    audio_file="deer_audio/scene${scene}_deer.mp3"

    if [[ -f "$audio_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")
        word_count=$(echo "${narrations[$((scene-1))]}" | wc -w)

        if (( $(echo "$duration <= 8.5" | bc -l) )); then
            status="✅ Perfect"
        else
            status="⚠️ Long"
        fi

        echo "$scene,${duration%.*}s,$word_count,$status" >> deer_timing.csv
        echo "Scene $scene: ${duration%.*}s (${word_count} words) $status"
    else
        echo "Scene $scene: ❌ Missing audio"
    fi
done

echo ""
echo "🦌 DEER FAMILY NARRATION READY!"
echo "🎬 Ready for visual dynamics generation!"

cat deer_timing.csv
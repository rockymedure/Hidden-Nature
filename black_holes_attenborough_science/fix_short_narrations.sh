#!/bin/bash

source .env
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🔧 Regenerating short narrations to hit 7-second target..."

mkdir -p fixed_audio

# Expanded narrations for scenes that were too short (targeting ~20-25 words for 7s)
declare -A expanded_narrations=(
    [1]="In all the cosmos, there is nothing more mysterious, more profound, or more humbling than a black hole."
    [3]="Today, we embark on humanity's most extraordinary and dangerous journey into the heart of ultimate darkness."
    [5]="At nearly every galaxy's heart lurks something that completely defies our everyday understanding of physics and reality."
    [10]="In less than one second, faster than you can blink, the massive star's core collapses into unimaginable density."
    [11]="A single teaspoon of this collapsed matter would weigh as much as Mount Everest or even more."
    [13]="This invisible boundary marks the point of no return. Nothing can escape - not even light itself."
    [15]="From a safe distance, you see nothing unusual at all. Just empty space and familiar stars."
    [18]="Crossing the event horizon feels utterly ordinary - like stepping across an invisible line in space."
    [19]="Yet you've passed beyond the observable universe into a realm of complete and utter mystery."
    [20]="Inside, the familiar laws of physics begin to break down completely, utterly, and without exception."
    [23]="The journey into darkness continues to illuminate the very deepest truths about our magnificent cosmos."
)

echo "🚀 Regenerating 11 scenes in parallel..."

# Regenerate short scenes
for scene in "${!expanded_narrations[@]}"; do
    narration="${expanded_narrations[$scene]}"
    word_count=$(echo "$narration" | wc -w)

    echo "🎤 Scene $scene: $word_count words (targeting 7s)"

    # Generate in background
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
            curl -s -o "fixed_audio/scene${scene}_7s.mp3" "$audio_url"
            echo "✅ Scene $scene: Fixed narration completed"
        else
            echo "❌ Scene $scene: Fix failed"
        fi
    ) &

    sleep 1  # Rate limiting
done

echo "⏳ Waiting for all fixes..."
wait

echo ""
echo "📏 Verifying fixed timing..."

for scene in "${!expanded_narrations[@]}"; do
    audio_file="fixed_audio/scene${scene}_7s.mp3"
    if [[ -f "$audio_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")
        duration_int=${duration%.*}
        word_count=$(echo "${expanded_narrations[$scene]}" | wc -w)

        if (( duration_int >= 6 && duration_int <= 8 )); then
            echo "Scene $scene: ${duration_int}s ($word_count words) ✅ FIXED"
            # Replace original with fixed version
            cp "$audio_file" "focused_audio/scene${scene}_8s.mp3"
        else
            echo "Scene $scene: ${duration_int}s ($word_count words) ⚠️ Still off"
        fi
    fi
done

echo ""
echo "🎯 Timing adjustment complete!"
echo "📊 All scenes now targeting 6-8 second range for perfect video pairing"
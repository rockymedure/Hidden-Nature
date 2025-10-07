#!/bin/bash

source ../../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎙️ Regenerating 16 Too-Long Narrations (Shortened)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Shortened narrations (target 6.0-7.8s)
declare -A SHORTENED=(
    [1]="[warm] In a drop of seawater lives an artist. Invisible. Creating perfect glass sculptures for two hundred million years."
    [2]="[amazed] This is a diatom. It builds its shell from silicon. It sculpts light itself into art."
    [3]="[curious] Every species creates a different pattern. Each one mathematically perfect. Each one impossibly beautiful."
    [5]="[warm] It takes water, sunlight, and silicon. From these, creates architecture rivaling any cathedral."
    [7]="[warm] Inside the glass house, chloroplasts work. Capturing sunlight. Every breath you take—diatoms helped make it."
    [8]="[amazed] Twenty percent of Earth's oxygen comes from diatoms. These invisible artists breathing life into oceans."
    [10]="[warm] Each daughter cell builds a new bottom. The pattern copied perfectly. Mathematical precision written in DNA."
    [11]="[thoughtful] There's a problem. Each generation is smaller. The daughter cells fit inside. Eventually, too tiny."
    [13]="[somber] After weeks, the diatom dies. Its glass shell begins to sink. Down through the dark water."
    [14]="[warm] It lands among billions of others. A microscopic graveyard. Shells upon shells building over centuries."
    [16]="[amazed] This stone has a name: diatomaceous earth. The White Cliffs of Dover—made by microscopic artists."
    [17]="[curious] Humans mine these ancient shells. Use them in toothpaste, filters, even dynamite. Ancient art, still useful."
    [18]="[warm] The glass survives everything. Fire, pressure, time. The patterns remain. Perfect mathematics, frozen in stone."
    [20]="[warm] New cells dividing. New shells forming. Same patterns. Same golden glass. The art continues, unbroken."
    [21]="[thoughtful] We walk beaches of their shells. We breathe their oxygen. Yet never see them. Invisible artists."
    [22]="[curious] They're not finished. Evolution continues. New species emerge. The art gallery accepting new masterpieces."
    [23]="[amazed] In every drop, thousands of diatoms. In every ocean, trillions. Mathematical perfection, repeated infinitely."
    [24]="[warm] Diatoms: living glass art. Nature's geometric masters painting with light and silicon for two hundred million years."
)

for scene in 1 2 3 5 7 8 10 11 13 14 16 17 18 20 21 22 23 24; do
    scene_num=$(printf "%02d" $scene)
    text="${SHORTENED[$scene]}"
    
    echo "🎬 Scene $scene_num: Regenerating (shortened)..."
    
    response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$text\",
            \"voice\": \"Charlotte\",
            \"stability\": 0.5,
            \"similarity_boost\": 0.75,
            \"style\": 0.7,
            \"speed\": 1.0
        }")
    
    audio_url=$(echo "$response" | jq -r '.audio.url // empty')
    
    if [[ -n "$audio_url" ]]; then
        curl -s -o "narrations/scene${scene_num}.mp3" "$audio_url"
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${scene_num}.mp3" 2>/dev/null)
        printf "   ✅ Scene %s: %.2fs\n" "$scene_num" "$duration"
    else
        echo "   ❌ Scene $scene_num: Failed"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Regeneration complete!"
echo ""
echo "📊 Final Duration Check:"
for i in {01..24}; do
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${i}.mp3" 2>/dev/null)
    status="✅"
    if (( $(echo "$duration > 8.0" | bc -l) )); then
        status="⚠️"
    fi
    printf "   %s Scene %s: %.2fs\n" "$status" "$i" "$duration"
done


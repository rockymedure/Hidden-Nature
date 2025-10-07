#!/bin/bash

source ../../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎙️ Final Aggressive Shortening (9 scenes)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Aggressively shortened (target 6-7s)
scene1="[warm] In a drop lives an artist. Invisible. Creating glass sculptures for two hundred million years."
scene16="[amazed] Diatomaceous earth. Mountains of diatom shells. White Cliffs of Dover—made by microscopic artists."
scene17="[curious] Humans mine these shells. In toothpaste, filters, dynamite. Ancient art, still useful."
scene18="[warm] The glass survives fire, pressure, time. The patterns remain. Perfect mathematics frozen forever."
scene20="[warm] New cells dividing. New shells forming. Same patterns. The art continues, unbroken."
scene21="[thoughtful] We walk on their shells. We breathe their oxygen. Yet never see them."
scene22="[curious] Evolution continues. New species emerge. New patterns appear. The gallery still accepts masterpieces."
scene23="[amazed] Every drop: thousands of diatoms. Every ocean: trillions. Mathematical perfection, repeated infinitely."
scene24="[warm] Diatoms: living glass art. Geometric masters painting with light for two hundred million years."

declare -a TEXTS=("$scene1" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "$scene16" "$scene17" "$scene18" "" "$scene20" "$scene21" "$scene22" "$scene23" "$scene24")
declare -a SCENES=(1 16 17 18 20 21 22 23 24)

for scene in "${SCENES[@]}"; do
    scene_num=$(printf "%02d" $scene)
    text="${TEXTS[$((scene-1))]}"
    
    echo "🎬 Scene $scene_num: Ultra-shortening..."
    
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
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Final check - All narrations:"
for i in {01..24}; do
    dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${i}.mp3" 2>/dev/null)
    printf "Scene %s: %.2fs\n" "$i" "$dur"
done


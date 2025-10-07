#!/bin/bash

source ../../../.env
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🔧 Regenerating 10 Cut-Off Scenes (Ultra-Short)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ULTRA SHORT versions (target ~6 seconds max)
declare -A ULTRA_SHORT=(
    [4]="[thoughtful] Two pieces. Like a glass petri dish. One fits inside the other."
    [9]="[curious] Time to reproduce. The glass shell splits. One becomes two."
    [12]="[excited] When too small, they shed shells. Grow huge again. Rebuild."
    [13]="[somber] After weeks, the diatom dies. Its shell sinks through dark water."
    [14]="[warm] It lands among billions. A graveyard of shells building over centuries."
    [15]="[thoughtful] Over millions of years, shells compress. Water squeezed out. Glass becomes stone."
    [16]="[amazed] Diatomaceous earth. White Cliffs of Dover—made by microscopic artists."
    [17]="[curious] Humans mine these shells. In toothpaste, filters, dynamite."
    [18]="[warm] The glass survives. Fire, pressure, time. Perfect mathematics frozen forever."
    [19]="[excited] But the story doesn't end. New diatoms are being born."
)

for scene in 4 9 12 13 14 15 16 17 18 19; do
    scene_num=$(printf "%02d" $scene)
    text="${ULTRA_SHORT[$scene]}"
    
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
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Now padding to 8.000s (WITHOUT truncation)..."
echo ""

for scene in 4 9 12 13 14 15 16 17 18 19; do
    scene_num=$(printf "%02d" $scene)
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${scene_num}.mp3" 2>/dev/null)
    
    # Only pad if UNDER 8 seconds (don't truncate)
    if (( $(echo "$duration < 8.0" | bc -l) )); then
        ffmpeg -y -i "narrations/scene${scene_num}.mp3" -af "apad=pad_dur=8.0" -t 8.0 "narrations/temp_scene${scene_num}.mp3" 2>/dev/null
        mv "narrations/temp_scene${scene_num}.mp3" "narrations/scene${scene_num}.mp3"
        new_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${scene_num}.mp3" 2>/dev/null)
        printf "Scene %s: %.3fs → %.3fs ✅\n" "$scene_num" "$duration" "$new_duration"
    else
        echo "⚠️ Scene $scene_num still too long: ${duration}s - needs MORE shortening"
    fi
done

echo ""
echo "✅ Fixed cut-off scenes regenerated!"


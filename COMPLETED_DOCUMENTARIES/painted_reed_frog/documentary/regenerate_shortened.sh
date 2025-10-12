#!/bin/bash
source ../../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎙️  REGENERATING SHORTENED NARRATIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Shortened narrations for scenes that were too long
declare -A scenes_to_fix=(
    [1]="She wakes invisible. Gray and unremarkable. Exactly what she needs for now."
    [2]="Fully camouflaged. Blending with dead reeds. A heron stalks past, unseeing."
    [3]="Males call from distant reeds. But in daylight, color means death."
    [4]="A snake investigates. She freezes, camouflage perfect. It moves past."
    [6]="She watches others interact. But must remain hidden. Dull means safe, means alone."
    [7]="The sun descends. Something shifts in her body. Chromatophores stirring."
    [8]="She positions herself perfectly. The transformation about to begin. Tonight changes everything."
    [9]="First whispers of color appear. Tiny flecks of purple. Transformation has begun."
    [10]="Color cells expand, contract, shift. Not magic. Biology looks like magic."
    [11]="Colors intensify rapidly. Purples deepen, oranges ignite. From drab to dazzling."
    [12]="Complete. A living painting. Vivid purple, orange, yellow. Unrecognizable now."
    [14]="The wetland transforms. Night creatures emerge. Other frogs begin displaying."
    [16]="She moves boldly now. At night predators hunt by sound, not color."
    [17]="Males display their colors, calling females. The wetland lit with colors."
    [18]="She observes. Colors matter. The most vibrant shows healthiest genes."
    [19]="They perform together. Colors flashing, moving in synchronized patterns."
    [20]="A bat swoops hunting. But hunts by echolocation. Bright colors invisible."
    [21]="Wide wetland view. Dozens of frogs in explosive colors. Hidden world."
    [24]="Dull once more. Another day of hiding. But tonight, she'll bloom again."
)

# Regenerate each problematic scene
for scene in "${!scenes_to_fix[@]}"; do
    narration="${scenes_to_fix[$scene]}"
    
    (
        echo "🎙️  Scene $(printf "%02d" $scene): Regenerating (shortened)..."
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration\",
                \"voice\": \"Charlotte\",
                \"model\": \"eleven_v3\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 0.7,
                \"speed\": 1.0
            }")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        if [[ -n "$audio_url" ]]; then
            curl -s -o "narrations/scene$(printf "%02d" $scene).mp3" "$audio_url"
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene$(printf "%02d" $scene).mp3" 2>/dev/null)
            echo "   ✅ Scene $(printf "%02d" $scene): Regenerated (${duration}s)"
        else
            echo "   ❌ Scene $(printf "%02d" $scene): Failed"
        fi
    ) &
    
    sleep 0.5
done

wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ REGENERATION COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "New durations:"
for i in {1..24}; do
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene$(printf "%02d" $i).mp3" 2>/dev/null)
    echo "Scene $(printf "%02d" $i): ${duration}s"
done

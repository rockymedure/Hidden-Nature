#!/bin/bash
source ../../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
mkdir -p narrations

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎙️  GENERATING ALL 24 NARRATIONS - Charlotte Voice"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# All 24 narration texts (15-20 words each)
declare -a narrations=(
    "She wakes invisible. Gray, dull, unremarkable. But that's exactly what she needs to be. For now."
    "Fully camouflaged now. Blending with the dead reeds. A heron stalks past, unseeing. This is survival."
    "Other males call from distant reeds, showing their colors. But in daylight, being colorful means death. She waits."
    "A snake investigates nearby reeds. She freezes. Her camouflage perfect. The snake moves past. Dull equals life."
    "The hottest part of day. She barely moves, conserving energy. Invisible in her dull disguise."
    "She watches other creatures interact, mate, communicate. But she must remain hidden. Dull means safe. Also means alone."
    "The sun begins its descent. Light changes. Something shifts in her body. Chromatophores stirring. Almost time."
    "Shadows lengthen. She positions herself perfectly. The transformation is about to begin. Tonight, she'll become someone else."
    "As twilight deepens, the first whispers of color appear. Tiny flecks of purple. The transformation has begun."
    "Microscopic color cells beneath her skin expand, contract, shift. Not magic. Biology. Looks like magic."
    "Colors intensify rapidly now. Purples deepen. Oranges ignite. Yellows glow. From drab to dazzling in real time."
    "Complete. She's now a living painting. Vivid purple, electric orange, bright yellow, deep magenta. Unrecognizable from her day form."
    "She stretches, showing off her new colors. This is who she really is. Hidden all day for survival."
    "Around her, the wetland transforms too. Night creatures emerge. Other reed frogs begin their displays. Night shift begins."
    "She calls for the first time today. A distinctive chirp. Now that she's vibrant, she can announce herself."
    "She moves boldly now. Displaying, calling, living fully. At night, predators hunt by sound, not color. She's finally free."
    "Other males display their colors, calling to attract females. A visual and vocal symphony. The wetland lit with colors."
    "She observes several males. Colors matter. The most vibrant shows the healthiest genes. She chooses one with exceptional purple."
    "They perform an intricate display together. Colors flashing, bodies moving in synchronized patterns. This is what transformation is for."
    "A bat swoops through, hunting. But it hunts by echolocation, not sight. Their bright colors are invisible."
    "Wide view of the wetland at night. Dozens of reed frogs in explosive colors. A hidden world that only exists in darkness."
    "The sky begins to lighten. She's with her chosen mate. But dawn is coming. Time to hide again."
    "As morning light grows, her colors begin to fade. Purples dim to gray. Oranges mute to brown."
    "She's dull once more. Invisible on her reed. Another day of hiding ahead. But tonight. Tonight she'll bloom again."
)

# Generate all narrations in parallel
for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"
    
    (
        echo "🎙️  Scene $(printf "%02d" $scene): Generating narration..."
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
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene$(printf "%02d" $scene).mp3" 2>/dev/null | cut -d. -f1)
            echo "   ✅ Scene $(printf "%02d" $scene): Narration saved (${duration}s)"
        else
            echo "   ❌ Scene $(printf "%02d" $scene): Failed"
            echo "$response" | jq '.'
        fi
    ) &
    
    # Stagger to avoid rate limits
    sleep 0.5
done

wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL NARRATIONS COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Saved to: documentary/narrations/"
ls -lh narrations/*.mp3 | wc -l | xargs echo "Total narrations:"

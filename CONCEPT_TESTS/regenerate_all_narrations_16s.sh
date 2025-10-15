#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎙️  REGENERATING ALL NARRATIONS AS 16-SECOND CONTINUOUS STORIES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# NEW 16-SECOND CONTINUOUS NARRATIONS
# Each tells one flowing story across both visual scenes

declare -A narrations=(
    ["jumping_spider"]="Deep in the undergrowth, a tiny hunter awakens. Eight eyes lock onto movement. A fly, unaware. Distance calculated in milliseconds. Muscles coil. Then... an explosive leap through the void. Contact. Victory. Another meal secured in the miniature jungle where precision is survival."
    
    ["cuttlefish"]="Danger approaches from above. A predator's shadow. But she has nature's ultimate superpower... the ability to vanish. In less than a heartbeat, her skin ripples, shifts, transforms. Now perfectly matched to the reef behind her. The shark passes, seeing nothing. And the most incredible part? She's colorblind. She did all that without ever seeing color."
    
    ["tardigrade"]="Meet the tardigrade. Less than a millimeter long, yet nearly indestructible. He can survive being frozen solid, boiled alive, even the vacuum of space. Watch as we add water to this dried-out specimen. His body expands, legs emerge, and just like that... he's awake. As if nothing happened. The ultimate survivor, animated by a single drop."
    
    ["venus_flytrap"]="She waits. Perfectly still. Jaws open wide, revealing that crimson interior. Six trigger hairs inside, like tripwires. An insect just has to touch two of them, and... snap. Shut in a tenth of a second. One of the fastest movements in the plant kingdom. Now sealed tight, she releases digestive enzymes. Over the next ten days, she'll dissolve him completely. Then the trap opens again, ready for the next victim."
    
    ["chameleon"]="His color is his mood made visible. Right now, bright green means calm, relaxed, at peace. But then... another male appears. A rival. Watch as his skin erupts into electric patterns of yellow, orange, red. A living billboard screaming territory, dominance, back off. The rival sees the message and retreats. And just like that, the colors fade. Back to peaceful green. That's how chameleons talk, through a language of living color."
    
    ["monarch"]="She just emerged. Wings still drying in the morning sun. But deep inside, something ancient is calling. South. Three thousand miles south to a forest she's never seen. A place her great-great-grandparents knew, but she never will... until now. Somehow, through genetic memory, she navigates across an entire continent. And finally, she arrives. Oyamel fir trees covered in millions of monarchs. She's never been here, but somehow... she's home."
)

declare -A concept_dirs=(
    ["jumping_spider"]="jumping_spider"
    ["cuttlefish"]="cuttlefish"
    ["tardigrade"]="tardigrade"
    ["venus_flytrap"]="venus_flytrap"
    ["chameleon"]="chameleon"
    ["monarch"]="monarch"
)

# Generate all 6 narrations
for concept in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    dir="${concept_dirs[$concept]}"
    narration="${narrations[$concept]}"
    
    echo "🎙️  $concept: Generating 16s continuous narration..."
    
    response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$narration\",
            \"voice\": \"$NARRATOR_VOICE_ID\",
            \"stability\": 0.5,
            \"similarity_boost\": 0.75,
            \"style\": 0.7,
            \"speed\": 1.0
        }")
    
    audio_url=$(echo "$response" | jq -r '.audio.url')
    if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
        curl -s -o "$dir/audio/narration_16s.mp3" "$audio_url"
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$dir/audio/narration_16s.mp3")
        echo "   ✅ Generated (${duration}s)"
        
        # Check if we need to adjust speed to fit 16s
        needs_adjustment=$(echo "$duration > 15.5" | bc -l)
        if [[ $needs_adjustment -eq 1 ]]; then
            speed=$(echo "$duration / 15.0" | bc -l)
            echo "   ⚙️  Adjusting speed to fit 16s..."
            ffmpeg -y -i "$dir/audio/narration_16s.mp3" -filter:a "atempo=$speed" "$dir/audio/narration_16s_adjusted.mp3" 2>/dev/null
            mv "$dir/audio/narration_16s_adjusted.mp3" "$dir/audio/narration_16s.mp3"
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$dir/audio/narration_16s.mp3")
            echo "   ✅ Adjusted to ${duration}s"
        fi
    else
        echo "   ❌ Failed to generate"
        echo "$response" | jq '.'
    fi
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL 16-SECOND NARRATIONS GENERATED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


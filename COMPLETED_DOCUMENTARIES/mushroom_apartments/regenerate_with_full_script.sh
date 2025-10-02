#!/bin/bash
# Regenerate all 26 narrations with FULL SCRIPT TEXT (using proper length)

set -e

cd /Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments

# Source environment
if [ -f .env ]; then
    source .env
elif [ -f ../../.env ]; then
    source ../../.env
else
    echo "❌ Error: .env file not found"
    exit 1
fi

echo "🎙️  REGENERATING WITH FULL SCRIPT NARRATIONS"
echo "==========================================="
echo "Voice: Jessica | Stability: 0.5 | Similarity: 0.75 | Style: 1.0 | Speed: 1.0"
echo "Using FULL narrations from THE_MUSHROOM_APARTMENTS_SCRIPT.md"
echo ""

TTS_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VOICE="Jessica"

# Backup current narrations
echo "📦 Backing up current narrations..."
mkdir -p mushroom_audio_fullscript_backup
cp mushroom_audio/*.mp3 mushroom_audio_fullscript_backup/ 2>/dev/null || true
echo "✅ Backup complete"
echo ""

# FULL narrations from THE_MUSHROOM_APARTMENTS_SCRIPT.md
declare -a narrations=(
    "This is Anju. Most people see mushrooms. She sees apartment buildings."
    "In three days, this mushroom becomes home to dozens of residents."
    "Day one. The doors just opened. The first tenants are already arriving."
    "Meet the pioneers - fungus gnats here to lay eggs."
    "Within hours, their larvae begin excavating tunnels through the flesh."
    "The beetles arrive next. They'll move in and never leave."
    "What looks simple is actually a thriving micro-city."
    "Some tenants are gourmets. This slug only eats specific species."
    "Its tongue has twenty-seven thousand teeth, adapted for fungal dining."
    "Springtails don't just eat mushrooms - they farm bacteria inside them."
    "Where there's prey, there are predators patrolling the corridors."
    "In the shadows, pseudoscorpions wait. Tiny venomous landlords."
    "Larger residents depend on mushrooms to survive winter."
    "Squirrels curate mushroom collections, drying them like jerky."
    "Deer seek specific species for minerals plants can't provide."
    "A single mushroom can house twenty species and hundreds of residents."
    "Some mushrooms are predators. This one sets microscopic snares."
    "Once trapped, the fungus injects enzymes. The worm becomes food."
    "This ant is dead - controlled by a fungus that hijacked its brain."
    "The fungus made it climb to exact height and temperature - then killed it."
    "Now it broadcasts spores to infect the next generation. Precise. Lethal. Beautiful."
    "Summit disease. This fungus forces flies to climb high - then erupts."
    "Week two. The apartment is condemned. Residents evacuate en masse."
    "As it dies, the mushroom releases trillions of spores - future cities."
    "Within days, new apartments rise. The cycle begins again."
    "Forests aren't just trees. They're cities within cities - and we're only beginning to see the residents."
)

# Generate all narrations in parallel (10 at a time)
echo "🎬 Generating all 26 FULL narrations..."
for i in "${!narrations[@]}"; do
    scene_num=$((i + 1))
    narration_text="${narrations[$i]}"
    
    (
        echo "  🎙️  Scene ${scene_num}: Generating..."
        
        response=$(curl -s -X POST "$TTS_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration_text\",
                \"voice\": \"$VOICE\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 1.0,
                \"speed\": 1.0
            }")
        
        audio_url=$(echo "$response" | jq -r '.audio.url')
        
        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            # Download raw audio
            curl -s -o "mushroom_audio/scene${scene_num}_raw.mp3" "$audio_url"
            
            # Get duration
            duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "mushroom_audio/scene${scene_num}_raw.mp3" 2>/dev/null)
            
            # Pad to exactly 8 seconds
            ffmpeg -y -i "mushroom_audio/scene${scene_num}_raw.mp3" \
                -af "apad=whole_dur=8" \
                -c:a libmp3lame -q:a 2 \
                "mushroom_audio/scene${scene_num}.mp3" 2>/dev/null
            
            # Clean up raw
            rm "mushroom_audio/scene${scene_num}_raw.mp3"
            
            echo "  ✅ Scene ${scene_num}: ${duration}s -> 8.000s"
        else
            echo "  ❌ Scene ${scene_num}: Failed"
            echo "Response: $response"
        fi
    ) &
    
    # Limit concurrent jobs to 10
    if (( (i + 1) % 10 == 0 )); then
        wait
    fi
done

# Wait for all remaining generations
wait

echo ""
echo "✨ ================================ ✨"
echo "   ALL NARRATIONS REGENERATED!"
echo "✨ ================================ ✨"
echo ""
echo "Voice: Jessica (perfect voice from Scene 1)"
echo "Using FULL script narrations (longer, more detailed)"
echo "All 26 narrations padded to exactly 8.000 seconds"
echo ""
echo "Previous narrations backed up to: mushroom_audio_fullscript_backup/"
echo ""


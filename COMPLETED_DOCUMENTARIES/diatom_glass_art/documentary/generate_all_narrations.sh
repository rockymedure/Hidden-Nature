#!/bin/bash

source ../../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎙️ DIATOM: Generating All 24 Narrations"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Voice: Charlotte"
echo "Model: eleven_v3 (expressive audio tags)"
echo "Settings: stability=0.5, style=0.7, similarity_boost=0.75"
echo ""

# All 24 narrations with expressive tags
declare -a NARRATIONS=(
    "[warm] In a single drop of seawater lives an artist. Invisible to the naked eye. Creating perfect glass sculptures. For two hundred million years."
    "[amazed] This is a diatom. It builds its shell from silicon—the same element in glass. It sculpts light itself into art."
    "[curious] Every species creates a different pattern. One hundred thousand designs. Each one mathematically perfect. Each one impossibly beautiful."
    "[thoughtful] The shell is built in two pieces. Like a tiny glass petri dish. One half fits perfectly inside the other."
    "[warm] It takes water, sunlight, and dissolved silicon. And from these simple ingredients, creates architecture that rivals any cathedral."
    "[excited] The new shell is complete. Perfect geometry. Flawless transparency. A newborn work of art floating in the sea."
    "[warm] Inside the glass house, chloroplasts work silently. Capturing sunlight. Converting it to oxygen. Every breath you take—diatoms helped make it."
    "[amazed] Twenty percent of Earth's oxygen comes from diatoms. These invisible artists are also invisible heroes. Breathing life into the ocean."
    "[curious] When it's time to reproduce, something remarkable happens. The glass shell splits open. One becomes two."
    "[warm] Each daughter cell builds a new bottom half. The pattern is copied perfectly. The geometry, flawless. Mathematical precision, written in DNA."
    "[thoughtful] But there's a problem. Each generation is slightly smaller. The daughter cells fit inside the parent's shell. Eventually, they'll be too tiny."
    "[excited] So diatoms have a secret weapon. When they get too small, they shed their shells. Grow huge again. Then rebuild their glass armor."
    "[somber] After weeks of life, the diatom dies. Its glass shell, perfect and empty, begins to sink. Down through the dark water."
    "[warm] It lands among billions of others. A microscopic graveyard. Shells upon shells upon shells. Building up over centuries."
    "[thoughtful] Over millions of years, the weight above presses down. The shells compress. Water is squeezed out. Glass becomes stone."
    "[amazed] This stone has a name: diatomaceous earth. Entire mountains made of diatom shells. The White Cliffs of Dover—made by microscopic artists."
    "[curious] Humans mine these ancient shells. Use them in toothpaste, filters, paint, even dynamite. Two-hundred-million-year-old art, still useful today."
    "[warm] The glass survives everything. Fire, pressure, time itself. The geometric patterns remain. Perfect mathematics, frozen forever in stone."
    "[excited] But the story doesn't end. Right now, at this very moment, in every ocean, new diatoms are being born."
    "[warm] New cells dividing. New shells forming. The same geometric patterns. The same golden glass. The art continues, unbroken, for two hundred million years."
    "[thoughtful] We walk beaches made of their shells. We breathe oxygen they created. Yet we never see them. The invisible artists work on."
    "[curious] And they're not finished. Evolution continues. New species emerge. New patterns appear. The art gallery is still accepting new masterpieces."
    "[amazed] In every drop of seawater, thousands of diatoms. In every ocean, trillions. Mathematical perfection, repeated infinitely, all across the planet."
    "[warm] Diatoms: living glass art. Nature's geometric masters. The invisible artists who've been painting with light and silicon for two hundred million years."
)

for i in {1..24}; do
    scene_num=$(printf "%02d" $i)
    idx=$((i-1))
    text="${NARRATIONS[$idx]}"
    
    echo "🎬 Scene $scene_num: Generating..."
    
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
        echo "$response" > "responses/scene${scene_num}_narration_error.json"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All 24 narrations generated!"
echo ""
echo "📊 Duration Summary:"
cd narrations
for f in scene*.mp3; do
    if [[ -f "$f" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null)
        printf "   %s: %.2fs\n" "$f" "$duration"
    fi
done


#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎙️  REGENERATING NARRATIONS - NATURAL 1X SPEED (NO ADJUSTMENTS)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Shorter narrations designed to naturally fit ~14-15 seconds at 1x speed

# Jumping Spider
echo "🎙️  Jumping Spider: Generating natural-length narration..."
narration="Eight eyes lock onto prey. Distance calculated. Muscles coil. An explosive leap across the void. Perfect contact. Another meal secured where precision means survival."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "jumping_spider/audio/narration_16s_natural.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "jumping_spider/audio/narration_16s_natural.mp3")
    echo "   ✅ Generated at natural 1x speed (${duration}s)"
fi

# Cuttlefish
echo "🎙️  Cuttlefish: Generating natural-length narration..."
narration="A predator approaches. But she has a superpower. Her skin ripples and transforms. Perfectly matched to the reef. The shark passes, seeing nothing. And she's colorblind. She did it all without seeing color."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "cuttlefish/audio/narration_16s_natural.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cuttlefish/audio/narration_16s_natural.mp3")
    echo "   ✅ Generated at natural 1x speed (${duration}s)"
fi

# Tardigrade
echo "🎙️  Tardigrade: Generating natural-length narration..."
narration="Meet the tardigrade. Nearly indestructible. Frozen, boiled, even sent to space. Watch as we add water. His body expands. Legs emerge. He's awake. The ultimate survivor, back from the dead."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "tardigrade/audio/narration_16s_natural.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "tardigrade/audio/narration_16s_natural.mp3")
    echo "   ✅ Generated at natural 1x speed (${duration}s)"
fi

# Venus Flytrap
echo "🎙️  Venus Flytrap: Generating natural-length narration..."
narration="She waits. Jaws open. Six trigger hairs inside. An insect touches two. Snap. Shut in a tenth of a second. Now sealed, enzymes release. Over ten days, complete digestion. Then it opens again."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "venus_flytrap/audio/narration_16s_natural.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "venus_flytrap/audio/narration_16s_natural.mp3")
    echo "   ✅ Generated at natural 1x speed (${duration}s)"
fi

# Chameleon
echo "🎙️  Chameleon: Generating natural-length narration..."
narration="His color is his mood. Bright green means calm. Then a rival appears. Watch his skin erupt. Yellow, orange, red. A living warning. The rival retreats. Colors fade back to green. That's how chameleons speak."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "chameleon/audio/narration_16s_natural.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "chameleon/audio/narration_16s_natural.mp3")
    echo "   ✅ Generated at natural 1x speed (${duration}s)"
fi

# Monarch
echo "🎙️  Monarch: Generating natural-length narration..."
narration="She just emerged. Wings drying. But something ancient calls. South. Three thousand miles to a forest she's never seen. Through genetic memory, she navigates. And arrives. Millions of monarchs. She's home."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "monarch/audio/narration_16s_natural.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "monarch/audio/narration_16s_natural.mp3")
    echo "   ✅ Generated at natural 1x speed (${duration}s)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL NARRATIONS GENERATED AT NATURAL 1X SPEED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Durations (natural pacing, no speed adjustments):"
for dir in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    if [[ -f "$dir/audio/narration_16s_natural.mp3" ]]; then
        dur=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$dir/audio/narration_16s_natural.mp3")
        echo "   $dir: ${dur}s"
    fi
done


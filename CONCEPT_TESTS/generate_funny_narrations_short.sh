#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "😂 GENERATING SHORT FUNNY NARRATIONS (1X SPEED)"
echo "   Designed to naturally fit ~15 seconds"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Jumping Spider - SHORT Funny Version
echo "🕷️  Jumping Spider: Generating short funny narration..."
narration="Eight eyes. Locked on. Wait for it. BOOM! Did you see that?! Spider parkour! That's what I call fast food."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "jumping_spider/audio/narration_funny_short.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "jumping_spider/audio/narration_funny_short.mp3")
    echo "   ✅ Generated at 1x speed (${duration}s)"
fi

# Cuttlefish - SHORT Funny Version
echo "🦑 Cuttlefish: Generating short funny narration..."
narration="Predator incoming. Watch this. WHAT?! She just disappeared! Best magic trick ever. And she's colorblind. Painting with her eyes closed!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "cuttlefish/audio/narration_funny_short.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cuttlefish/audio/narration_funny_short.mp3")
    echo "   ✅ Generated at 1x speed (${duration}s)"
fi

# Tardigrade - SHORT Funny Version
echo "🐻 Tardigrade: Generating short funny narration..."
narration="Meet the water bear. Tiny legs. Indestructible. Freeze him? Fine. Space? No problem. Add water and BOOM. He's back. Tiny adorable zombie!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "tardigrade/audio/narration_funny_short.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "tardigrade/audio/narration_funny_short.mp3")
    echo "   ✅ Generated at 1x speed (${duration}s)"
fi

# Venus Flytrap - SHORT Funny Version
echo "🌿 Venus Flytrap: Generating short funny narration..."
narration="Waiting. Trigger hairs set. Bug has no idea. SNAP! Gotcha! Faster than you can blink. Dinner time. No takebacks!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "venus_flytrap/audio/narration_funny_short.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "venus_flytrap/audio/narration_funny_short.mp3")
    echo "   ✅ Generated at 1x speed (${duration}s)"
fi

# Chameleon - SHORT Funny Version
echo "🦎 Chameleon: Generating short funny narration..."
narration="Green equals chill. But WAIT. Rival shows up! Full rainbow mode! Yellow orange red! THIS IS MY BRANCH! Other guy leaves. Back to green. Mood ring goals!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "chameleon/audio/narration_funny_short.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "chameleon/audio/narration_funny_short.mp3")
    echo "   ✅ Generated at 1x speed (${duration}s)"
fi

# Monarch - SHORT Funny Version
echo "🦋 Monarch: Generating short funny narration..."
narration="Just hatched. Wings wet. Somehow she knows. Go south. Three thousand miles. GPS? Nope. Genetic memory! She made it. Millions of butterflies. Home!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "monarch/audio/narration_funny_short.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "monarch/audio/narration_funny_short.mp3")
    echo "   ✅ Generated at 1x speed (${duration}s)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL SHORT FUNNY NARRATIONS GENERATED AT 1X SPEED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Durations (should be ~15s or less):"
for dir in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    if [[ -f "$dir/audio/narration_funny_short.mp3" ]]; then
        dur=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$dir/audio/narration_funny_short.mp3")
        echo "   $dir: ${dur}s"
    fi
done


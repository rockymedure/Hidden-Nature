#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "😂 REGENERATING MISSING FUNNY NARRATIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Cuttlefish - Funny Version
echo "🦑 Cuttlefish: Generating funny narration..."
narration="Uh oh, here comes trouble. She's like, I need to disappear right now. Watch this. WHAT?! Did she just become INVISIBLE?! That is the coolest magic trick ever! And get this, she's COLORBLIND! She can't even see what she's doing! That's like painting with your eyes closed!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "cuttlefish/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cuttlefish/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
else
    echo "   ❌ Failed - Error: $response"
fi

# Tardigrade - Funny Version
echo "🐻 Tardigrade: Generating funny narration..."
narration="Meet the tardigrade. Also known as the water bear. Look at those little legs! He's basically indestructible. Freeze him? No problem. Boil him? He's fine. Send him to SPACE?! He's like, whatever dude. Now watch, we add water and HE'S ALIVE! It's like a tiny adorable zombie!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "tardigrade/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "tardigrade/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
else
    echo "   ❌ Failed - Error: $response"
fi

# Venus Flytrap - Funny Version
echo "🌿 Venus Flytrap: Generating funny narration..."
narration="She's just sitting there waiting. Those are trigger hairs inside. If you touch two of them, you're done. Watch this bug. He has NO idea. SNAP! Gotcha! One tenth of a second! That's faster than you can blink! And now, dinnertime. The ultimate no takebacks situation!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "venus_flytrap/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "venus_flytrap/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
else
    echo "   ❌ Failed - Error: $response"
fi

# Chameleon - Funny Version
echo "🦎 Chameleon: Generating funny narration..."
narration="Green means chillin. He's like, life is good. But WAIT. Another dude shows up! Oh no he didn't! Watch him go full rainbow mode! Yellow! Orange! Red! He's basically screaming, THIS IS MY BRANCH BRO! Other guy's like, okay okay I'm leaving! And just like that, back to green. Mood ring goals!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "chameleon/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "chameleon/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
else
    echo "   ❌ Failed - Error: $response"
fi

# Monarch - Funny Version
echo "🦋 Monarch: Generating funny narration..."
narration="She literally JUST hatched. Wings are still wet. But somehow she knows. Go south! Three THOUSAND miles! To a place she's NEVER been! How does she even know?! GPS? Google Maps? Nope! Genetic memory! And look, she made it! Millions of butterflies! She's home. That's the ultimate trust the process story!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "monarch/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "monarch/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
else
    echo "   ❌ Failed - Error: $response"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL FUNNY NARRATIONS COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


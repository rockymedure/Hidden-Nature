#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "😂 GENERATING FUNNY AFV-STYLE NARRATIONS"
echo "   Using expressive audio tags for laughter & excitement!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Jumping Spider - Funny Version
echo "🕷️  Jumping Spider: Generating funny narration..."
narration="Okay, watch this little guy. *chuckles* He's got eight eyes, EIGHT! *laughs* And he just spotted lunch. Wait for it... wait for it... *gasps* OH! *excited* Did you see that?! He just FLEW through the air! *laughs* Nailed it! That's what I call fast food delivery!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "jumping_spider/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "jumping_spider/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
fi

# Cuttlefish - Funny Version
echo "🦑 Cuttlefish: Generating funny narration..."
narration="Uh oh, here comes trouble. *nervous laugh* She's like, \"I need to disappear right now.\" Watch this. *gasps* WHAT?! *laughs* Did she just... did she just become INVISIBLE?! *excited* That is the coolest magic trick ever! And get this... *chuckles* she's COLORBLIND! *laughs* She can't even see what she's doing! That's like painting a masterpiece with your eyes closed!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "cuttlefish/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cuttlefish/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
fi

# Tardigrade - Funny Version
echo "🐻 Tardigrade: Generating funny narration..."
narration="Meet the tardigrade. *chuckles* Also known as the water bear. *laughs* Look at those little legs! He's basically indestructible. Freeze him? *pfft* No problem. Boil him? He's fine. *excited* Send him to SPACE?! *laughs* He's like, \"Whatever, dude.\" Now watch... we add water and... *gasps* HE'S ALIVE! *laughs* It's like a tiny, adorable zombie! The ultimate \"I'm not dead yet!\""

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "tardigrade/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "tardigrade/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
fi

# Venus Flytrap - Funny Version
echo "🌿 Venus Flytrap: Generating funny narration..."
narration="She's just sitting there. *whispers* Waiting. *chuckles* Those are trigger hairs inside. If you touch two of them... *nervous laugh* You're done. Watch this bug. He has NO idea. *gasps* SNAP! *laughs* Gotcha! *excited* One tenth of a second! That's faster than you can blink! *chuckles* And now... dinnertime. *laughs* The ultimate \"No takebacks\" situation!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "venus_flytrap/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "venus_flytrap/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
fi

# Chameleon - Funny Version
echo "🦎 Chameleon: Generating funny narration..."
narration="Green means chillin'. *chuckles* He's like, \"Life is good.\" But WAIT. *gasps* Another dude shows up! *excited* Oh no he didn't! *laughs* Watch him go full rainbow mode! Yellow! Orange! Red! *laughs* He's basically screaming, \"THIS IS MY BRANCH, BRO!\" *chuckles* Other guy's like, \"Okay okay, I'm leaving!\" And just like that... *sighs happily* back to green. Mood ring goals!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "chameleon/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "chameleon/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
fi

# Monarch - Funny Version
echo "🦋 Monarch: Generating funny narration..."
narration="She literally JUST hatched. *chuckles* Wings are still wet. But somehow... *mysterious voice* she knows. *excited* Go south! Three THOUSAND miles! *laughs* To a place she's NEVER been! *gasps* How does she even know?! *chuckles* GPS? Google Maps? Nope! *laughs* Genetic memory! And look... *amazed* she made it! Millions of butterflies! *happy sigh* She's home. That's the ultimate \"trust the process\" story!"

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "monarch/audio/narration_funny.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "monarch/audio/narration_funny.mp3")
    echo "   ✅ Generated (${duration}s)"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL FUNNY NARRATIONS GENERATED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Durations:"
for dir in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    if [[ -f "$dir/audio/narration_funny.mp3" ]]; then
        dur=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$dir/audio/narration_funny.mp3")
        echo "   $dir: ${dur}s"
    fi
done


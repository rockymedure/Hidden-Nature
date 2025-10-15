#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎙️  REGENERATING ALL NARRATIONS AS 16-SECOND CONTINUOUS STORIES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Jumping Spider
echo "🎙️  Jumping Spider: Generating 16s continuous narration..."
narration="Deep in the undergrowth, a tiny hunter awakens. Eight eyes lock onto movement. A fly, unaware. Distance calculated in milliseconds. Muscles coil. Then... an explosive leap through the void. Contact. Victory. Another meal secured in the miniature jungle where precision is survival."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "jumping_spider/audio/narration_16s.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "jumping_spider/audio/narration_16s.mp3")
    echo "   ✅ Generated (${duration}s)"
    if (( $(echo "$duration > 15.5" | bc -l) )); then
        speed=$(echo "$duration / 15.0" | bc -l)
        ffmpeg -y -i "jumping_spider/audio/narration_16s.mp3" -filter:a "atempo=$speed" "jumping_spider/audio/temp.mp3" 2>/dev/null
        mv "jumping_spider/audio/temp.mp3" "jumping_spider/audio/narration_16s.mp3"
        echo "   ✅ Adjusted to fit 15s"
    fi
fi

# Cuttlefish
echo "🎙️  Cuttlefish: Generating 16s continuous narration..."
narration="Danger approaches from above. A predator's shadow. But she has nature's ultimate superpower... the ability to vanish. In less than a heartbeat, her skin ripples, shifts, transforms. Now perfectly matched to the reef behind her. The shark passes, seeing nothing. And the most incredible part? She's colorblind. She did all that without ever seeing color."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "cuttlefish/audio/narration_16s.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cuttlefish/audio/narration_16s.mp3")
    echo "   ✅ Generated (${duration}s)"
    if (( $(echo "$duration > 15.5" | bc -l) )); then
        speed=$(echo "$duration / 15.0" | bc -l)
        ffmpeg -y -i "cuttlefish/audio/narration_16s.mp3" -filter:a "atempo=$speed" "cuttlefish/audio/temp.mp3" 2>/dev/null
        mv "cuttlefish/audio/temp.mp3" "cuttlefish/audio/narration_16s.mp3"
        echo "   ✅ Adjusted to fit 15s"
    fi
fi

# Tardigrade
echo "🎙️  Tardigrade: Generating 16s continuous narration..."
narration="Meet the tardigrade. Less than a millimeter long, yet nearly indestructible. He can survive being frozen solid, boiled alive, even the vacuum of space. Watch as we add water to this dried-out specimen. His body expands, legs emerge, and just like that... he's awake. As if nothing happened. The ultimate survivor, animated by a single drop."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "tardigrade/audio/narration_16s.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "tardigrade/audio/narration_16s.mp3")
    echo "   ✅ Generated (${duration}s)"
    if (( $(echo "$duration > 15.5" | bc -l) )); then
        speed=$(echo "$duration / 15.0" | bc -l)
        ffmpeg -y -i "tardigrade/audio/narration_16s.mp3" -filter:a "atempo=$speed" "tardigrade/audio/temp.mp3" 2>/dev/null
        mv "tardigrade/audio/temp.mp3" "tardigrade/audio/narration_16s.mp3"
        echo "   ✅ Adjusted to fit 15s"
    fi
fi

# Venus Flytrap
echo "🎙️  Venus Flytrap: Generating 16s continuous narration..."
narration="She waits. Perfectly still. Jaws open wide, revealing that crimson interior. Six trigger hairs inside, like tripwires. An insect just has to touch two of them, and... snap. Shut in a tenth of a second. One of the fastest movements in the plant kingdom. Now sealed tight, she releases digestive enzymes. Over the next ten days, she'll dissolve him completely. Then the trap opens again, ready for the next victim."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "venus_flytrap/audio/narration_16s.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "venus_flytrap/audio/narration_16s.mp3")
    echo "   ✅ Generated (${duration}s)"
    if (( $(echo "$duration > 15.5" | bc -l) )); then
        speed=$(echo "$duration / 15.0" | bc -l)
        ffmpeg -y -i "venus_flytrap/audio/narration_16s.mp3" -filter:a "atempo=$speed" "venus_flytrap/audio/temp.mp3" 2>/dev/null
        mv "venus_flytrap/audio/temp.mp3" "venus_flytrap/audio/narration_16s.mp3"
        echo "   ✅ Adjusted to fit 15s"
    fi
fi

# Chameleon
echo "🎙️  Chameleon: Generating 16s continuous narration..."
narration="His color is his mood made visible. Right now, bright green means calm, relaxed, at peace. But then... another male appears. A rival. Watch as his skin erupts into electric patterns of yellow, orange, red. A living billboard screaming territory, dominance, back off. The rival sees the message and retreats. And just like that, the colors fade. Back to peaceful green. That's how chameleons talk, through a language of living color."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "chameleon/audio/narration_16s.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "chameleon/audio/narration_16s.mp3")
    echo "   ✅ Generated (${duration}s)"
    if (( $(echo "$duration > 15.5" | bc -l) )); then
        speed=$(echo "$duration / 15.0" | bc -l)
        ffmpeg -y -i "chameleon/audio/narration_16s.mp3" -filter:a "atempo=$speed" "chameleon/audio/temp.mp3" 2>/dev/null
        mv "chameleon/audio/temp.mp3" "chameleon/audio/narration_16s.mp3"
        echo "   ✅ Adjusted to fit 15s"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL 16-SECOND NARRATIONS GENERATED (Monarch already done)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


#!/bin/bash
source ../../../.env
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

# Scene 10 and 12 need even shorter text
echo "Fixing Scene 10 and 12..."

# Scene 10
response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"text":"Color cells expand and contract. Not magic, biology.","voice":"Charlotte","model":"eleven_v3","stability":0.5,"similarity_boost":0.75,"style":0.7,"speed":1.0}')
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
curl -s -o "narrations/scene10.mp3" "$audio_url"

# Scene 12
response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"text":"Complete. A living painting. Vivid purple and orange.","voice":"Charlotte","model":"eleven_v3","stability":0.5,"similarity_boost":0.75,"style":0.7,"speed":1.0}')
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
curl -s -o "narrations/scene12.mp3" "$audio_url"

echo "Done!"

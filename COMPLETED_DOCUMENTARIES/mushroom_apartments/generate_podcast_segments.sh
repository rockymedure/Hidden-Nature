#!/bin/bash

# Generate Podcast Segments
# Using Brooklyn for Anju and finding a good male voice for Jeff

echo "🎙️  GENERATING PODCAST SEGMENTS"
echo "================================"

ELEVENLABS_KEY="sk_348f3392778aca1c9efe1ecdb7fff4e4370d8c433aff9122"
OUTPUT_DIR="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments/podcast_segments"

mkdir -p "$OUTPUT_DIR"

# Test with a few key exchanges first
echo "Generating segment 1: Jeff's opening..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/gs0tAILXbY5DNrJrsM6F" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Welcome back to Hidden Nature. I'\''m Jeff, and today I'\''m sitting down with field ecologist Anju, who just returned from three weeks studying what she calls mushroom apartments in the Pacific Northwest. Anju, welcome.",
    "model_id": "eleven_multilingual_v2"
  }' \
  --output "${OUTPUT_DIR}/01_jeff_opening.mp3"

echo "Generating segment 2: Anju's response..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/zWoalRDt5TZrmW4ROIA7" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Thanks for having me, Jeff. I'\''m still finding forest dirt in my gear.",
    "model_id": "eleven_multilingual_v2"
  }' \
  --output "${OUTPUT_DIR}/02_anju_response.mp3"

echo "Generating segment 3: Jeff question..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/gs0tAILXbY5DNrJrsM6F" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "So, mushroom apartments. That'\''s not exactly standard scientific terminology.",
    "model_id": "eleven_multilingual_v2"
  }' \
  --output "${OUTPUT_DIR}/03_jeff_question.mp3"

echo "Generating segment 4: Anju's explanation..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/zWoalRDt5TZrmW4ROIA7" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "No, it'\''s not. But the first time I crouched down with my magnifying glass and really watched what was happening, that'\''s what I saw. Tiny residents moving in, setting up shop, raising families. Like watching a whole apartment complex come to life in fast-forward.",
    "model_id": "eleven_multilingual_v2"
  }' \
  --output "${OUTPUT_DIR}/04_anju_explanation.mp3"

echo ""
echo "✅ Sample segments generated!"
echo "Listen to: ${OUTPUT_DIR}/"
echo ""
echo "If these sound good, I can generate the full 20-minute podcast."


#!/bin/bash

# Generate Enhanced Podcast Segments with Audio Tags
# Using Brooklyn for Anju and Mark for Jeff

echo "🎙️  GENERATING ENHANCED PODCAST SEGMENTS"
echo "========================================"

ELEVENLABS_KEY="sk_348f3392778aca1c9efe1ecdb7fff4e4370d8c433aff9122"
OUTPUT_DIR="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments/podcast_segments_enhanced"

mkdir -p "$OUTPUT_DIR"

# Test with enhanced audio tags
echo "Generating segment 1: Jeff's opening (with audio tags)..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/gs0tAILXbY5DNrJrsM6F" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "[warm] Welcome back to Hidden Nature. I'\''m Jeff, and today I'\''m sitting down with field ecologist Anju, who just returned from three weeks studying what she calls mushroom apartments in the Pacific Northwest. [curious] Anju, welcome.",
    "model_id": "eleven_turbo_v2_5",
    "voice_settings": {
      "stability": 0.4,
      "similarity_boost": 0.75,
      "style": 0.5
    }
  }' \
  --output "${OUTPUT_DIR}/01_jeff_opening_enhanced.mp3"

echo "Generating segment 2: Anju's response (with audio tags)..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/zWoalRDt5TZrmW4ROIA7" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "[chuckles] Thanks for having me, Jeff. [sighs] I'\''m STILL finding forest dirt in my gear.",
    "model_id": "eleven_turbo_v2_5",
    "voice_settings": {
      "stability": 0.4,
      "similarity_boost": 0.75,
      "style": 0.5
    }
  }' \
  --output "${OUTPUT_DIR}/02_anju_response_enhanced.mp3"

echo "Generating segment 3: Jeff question (with audio tags)..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/gs0tAILXbY5DNrJrsM6F" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "[amused] So... mushroom apartments. That'\''s not exactly standard scientific terminology.",
    "model_id": "eleven_turbo_v2_5",
    "voice_settings": {
      "stability": 0.4,
      "similarity_boost": 0.75,
      "style": 0.5
    }
  }' \
  --output "${OUTPUT_DIR}/03_jeff_question_enhanced.mp3"

echo "Generating segment 4: Anju's explanation (with audio tags)..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/zWoalRDt5TZrmW4ROIA7" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "[laughs] No, it'\''s not. But the first time I crouched down with my magnifying glass and really watched what was happening... [excited] that'\''s what I saw. Tiny residents moving in, setting up shop, raising families. Like watching a whole apartment complex come to life in fast-forward.",
    "model_id": "eleven_turbo_v2_5",
    "voice_settings": {
      "stability": 0.4,
      "similarity_boost": 0.75,
      "style": 0.5
    }
  }' \
  --output "${OUTPUT_DIR}/04_anju_explanation_enhanced.mp3"

echo "Generating segment 5: Anju excited about gnats (with audio tags)..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/zWoalRDt5TZrmW4ROIA7" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "[thoughtful] Most people see a mushroom and think Oh, a mushroom. They see one thing. But I was tracking fungus gnats for another project, and I kept LOSING them. [frustrated] They'\''d just... vanish. [pause] Turns out they weren'\''t vanishing—[excited] they were checking into the mushroom hotel!",
    "model_id": "eleven_turbo_v2_5",
    "voice_settings": {
      "stability": 0.4,
      "similarity_boost": 0.75,
      "style": 0.5
    }
  }' \
  --output "${OUTPUT_DIR}/05_anju_gnats_enhanced.mp3"

echo "Generating segment 6: Anju on slug teeth (with audio tags)..."
curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/zWoalRDt5TZrmW4ROIA7" \
  -H "xi-api-key: ${ELEVENLABS_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "[laughs] The banana slug radula! [excited] That'\''s one of my FAVORITE shots. Most people think slugs just sort of... [slowly] ooze onto mushrooms and absorb them. But they have this ribbon of microscopic teeth—a radula—that'\''s specifically adapted for scraping fungal tissue. [amazed] 27,000 teeth, arranged in ROWS. It'\''s like a biological cheese grater.",
    "model_id": "eleven_turbo_v2_5",
    "voice_settings": {
      "stability": 0.4,
      "similarity_boost": 0.75,
      "style": 0.5
    }
  }' \
  --output "${OUTPUT_DIR}/06_anju_slug_teeth_enhanced.mp3"

echo ""
echo "✅ Enhanced sample segments generated!"
echo "Listen to: ${OUTPUT_DIR}/"
echo ""
echo "🎭 Audio tags used:"
echo "   - [chuckles], [sighs], [laughs]"
echo "   - [warm], [curious], [amused], [excited], [thoughtful]"
echo "   - [pause], [slowly], [amazed]"
echo "   - Capitalization for EMPHASIS"
echo ""
echo "Compare these to the non-enhanced versions to hear the difference!"
echo ""
echo "If these sound good, I can generate the FULL 46-exchange podcast."


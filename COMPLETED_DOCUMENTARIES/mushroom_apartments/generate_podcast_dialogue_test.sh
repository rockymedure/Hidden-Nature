#!/bin/bash

# Generate Podcast Using Text-to-Dialogue Model
# Model: fal-ai/elevenlabs/text-to-dialogue/eleven-v3
# This generates natural conversational audio with proper turn-taking

echo "🎙️  GENERATING PODCAST WITH DIALOGUE MODEL"
echo "=========================================="

FAL_KEY="9a4a90eb-250b-4953-95e4-86c2db1695fc:61a4e14a87c8e1e87820fe44e8317856"
OUTPUT_DIR="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments/podcast_dialogue"

mkdir -p "$OUTPUT_DIR"

# Generate opening conversation segment with audio tags
echo "📝 Creating dialogue with audio tags..."
echo ""

DIALOGUE_JSON=$(cat <<'EOF'
{
  "dialogue": [
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "[warm] Welcome back to Hidden Nature. I'm Jeff, and today I'm sitting down with field ecologist Anju, who just returned from three weeks studying what she calls mushroom apartments in the Pacific Northwest. [curious] Anju, welcome."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "[chuckles] Thanks for having me, Jeff. [sighs] I'm STILL finding forest dirt in my gear."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "[amused] So... mushroom apartments. That's not exactly standard scientific terminology."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "[laughs] No, it's not. But the first time I crouched down with my magnifying glass and really watched what was happening... [excited] that's what I saw. Tiny residents moving in, setting up shop, raising families. Like watching a whole apartment complex come to life in fast-forward."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "[interested] What made you start looking at mushrooms this way?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "[thoughtful] Most people see a mushroom and think Oh, a mushroom. They see one thing. But I was tracking fungus gnats for another project, and I kept LOSING them. [frustrated] They'd just... vanish. [pause] Turns out they weren't vanishing—[excited] they were checking into the mushroom hotel!"
    }
  ]
}
EOF
)

echo "🎬 Submitting to fal-ai/elevenlabs/text-to-dialogue/eleven-v3..."
echo "   Voice IDs:"
echo "   - Jeff: gs0tAILXbY5DNrJrsM6F (Mark)"
echo "   - Anju: zWoalRDt5TZrmW4ROIA7 (Brooklyn)"
echo ""

# Submit request to dialogue API
RESPONSE=$(curl -s -X POST "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3" \
  -H "Authorization: Key ${FAL_KEY}" \
  -H "Content-Type: application/json" \
  -d "$DIALOGUE_JSON")

REQUEST_ID=$(echo "$RESPONSE" | grep -o '"request_id":"[^"]*"' | cut -d'"' -f4)

if [ -z "$REQUEST_ID" ]; then
  echo "❌ Error: No request ID returned"
  echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
  exit 1
fi

echo "✅ Request submitted: $REQUEST_ID"
echo "⏳ Waiting for generation to complete..."
echo ""

# Poll for completion
MAX_ATTEMPTS=60
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  sleep 3
  ATTEMPT=$((ATTEMPT + 1))
  
  STATUS_RESPONSE=$(curl -s "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3/requests/${REQUEST_ID}/status" \
    -H "Authorization: Key ${FAL_KEY}")
  
  STATUS=$(echo "$STATUS_RESPONSE" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
  
  if [ "$STATUS" = "COMPLETED" ]; then
    echo "✅ Generation complete!"
    echo ""
    
    # Get the result
    RESULT=$(curl -s "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3/requests/${REQUEST_ID}" \
      -H "Authorization: Key ${FAL_KEY}")
    
    # Extract audio URL (check for audio_url or audio field)
    AUDIO_URL=$(echo "$RESULT" | jq -r '.audio_url.url // .audio.url // empty' 2>/dev/null)
    
    if [ -z "$AUDIO_URL" ]; then
      echo "❌ Error: No audio URL in response"
      echo "$RESULT" | jq '.' 2>/dev/null || echo "$RESULT"
      exit 1
    fi
    
    echo "📥 Downloading podcast audio..."
    curl -s -o "${OUTPUT_DIR}/podcast_opening_dialogue.mp3" "$AUDIO_URL"
    
    echo ""
    echo "🎉 SUCCESS!"
    echo "=========================================="
    echo "Podcast segment saved to:"
    echo "  ${OUTPUT_DIR}/podcast_opening_dialogue.mp3"
    echo ""
    echo "🎭 Features:"
    echo "  ✓ Natural turn-taking conversation"
    echo "  ✓ Audio tags: [chuckles], [sighs], [laughs], [excited]"
    echo "  ✓ Two-voice dialogue (Jeff & Anju)"
    echo "  ✓ 6 exchanges (~2-3 minutes)"
    echo ""
    echo "Listen to this to hear the difference from individual TTS!"
    echo ""
    
    exit 0
  elif [ "$STATUS" = "FAILED" ]; then
    echo "❌ Generation failed"
    echo "$STATUS_RESPONSE" | jq '.' 2>/dev/null || echo "$STATUS_RESPONSE"
    exit 1
  fi
  
  echo "   Processing... (attempt $ATTEMPT/$MAX_ATTEMPTS) Status: $STATUS"
done

echo "❌ Timeout waiting for generation"
exit 1


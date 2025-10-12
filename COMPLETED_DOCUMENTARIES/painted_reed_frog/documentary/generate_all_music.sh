#!/bin/bash
source ../../../.env

MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
mkdir -p music

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎵 GENERATING ALL 24 SCENE-SPECIFIC MUSIC CLIPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Read music prompts from file
mapfile -t prompts < MUSIC_PROMPTS.txt

# Generate all music clips in parallel (10 at a time)
for i in {0..23}; do
    scene=$((i + 1))
    prompt="${prompts[$i]}"
    
    (
        echo "🎵 Scene $(printf "%02d" $scene): Generating music..."
        response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"prompt\": \"$prompt\",
                \"seconds_total\": 8,
                \"num_inference_steps\": 8,
                \"guidance_scale\": 7
            }")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        
        if [[ -n "$audio_url" ]]; then
            curl -s -o "music/scene$(printf "%02d" $scene).mp3" "$audio_url"
            echo "   ✅ Scene $(printf "%02d" $scene): Music generated"
        else
            echo "   ❌ Scene $(printf "%02d" $scene): Failed"
            echo "$response" | jq '.'
        fi
    ) &
    
    # Limit concurrent jobs to 10
    if (( (i + 1) % 10 == 0 )); then
        wait
    fi
done

wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL 24 MUSIC CLIPS COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Total music files:" $(ls music/*.mp3 2>/dev/null | wc -l)

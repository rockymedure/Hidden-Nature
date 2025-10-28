#!/bin/bash

source ../../.env
NARRATOR="Rachel"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

scene=24
narration_text="Evolutionary masterpieces, hidden architects of survival, hiding in plain sight."
output_file="audio/scene${scene}.mp3"

echo "🎙️ Scene $scene: Snow leopard finale..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')

if [[ -n "$audio_url" ]]; then
    curl -s -o "$output_file" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
    if (( $(echo "$duration > 8.0" | bc -l) )); then
        echo "⚠️  Scene $scene: $(printf '%.3f' $duration)s - TOO LONG!"
    elif (( $(echo "$duration < 8.0" | bc -l) )); then
        ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null
        mv "audio/scene${scene}_temp.mp3" "$output_file"
        echo "✅ Scene $scene: $(printf '%.3f' $duration)s → padded to 8.000s"
    else
        echo "✅ Scene $scene: Perfect 8.000s!"
    fi
fi

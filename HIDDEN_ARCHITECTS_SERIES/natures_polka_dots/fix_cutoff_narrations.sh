#!/bin/bash

# Fix scenes with cut-off narrations (5, 9, 10, 14, 18, 21, 22, 24)

set -e
cd "$(dirname "$0")" || exit 1

source ../../.env
if [ -z "$FAL_API_KEY" ]; then
    echo "❌ ERROR: FAL_API_KEY not found in .env"
    exit 1
fi

echo "🎙️ FIXING CUT-OFF NARRATIONS"
echo "════════════════════════════════════════"
echo ""

NARRATOR="Rachel"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

# Scene 5 - Snow Leopard (Himalayas)
scene=5
narration_text="In the Himalayas, the snow leopard's gray rosettes mirror the rocky cliffs perfectly."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Snow leopard..."
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
sleep 0.3

# Scene 9 - Poison Dart Frog
scene=9
narration_text="The poison dart frog's electric blue spots deliver a chemical warning: deadly toxins lie beneath."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Poison dart frog..."
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
sleep 0.3

# Scene 10 - Ladybug
scene=10
narration_text="A ladybug's red spots work the same way. Predators never forget what those spots mean."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Ladybug..."
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
sleep 0.3

# Scene 14 - Hyenas
scene=14
narration_text="Spotted hyenas use their unique spot patterns to recognize clan members. Each pattern is a personal calling card."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Hyenas..."
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
sleep 0.3

# Scene 18 - Peacock Flounder
scene=18
narration_text="The peacock flounder rewrites its spots daily, adjusting color and spacing to match any surface."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Peacock flounder..."
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
sleep 0.3

# Scene 21 - Owl Butterfly
scene=21
narration_text="The owl butterfly's giant eyespots create a perfect illusion: a predator's eyes staring right back at you."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Owl butterfly..."
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
sleep 0.3

# Scene 22 - Pufferfish
scene=22
narration_text="When threatened, the pufferfish inflates, stretching its spots into a dizzying disorienting pattern."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Scene $scene: Pufferfish..."
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
sleep 0.3

# Scene 24 - Snow Leopard Finale
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

echo ""
echo "✨ NARRATION FIXES COMPLETE!"
echo ""

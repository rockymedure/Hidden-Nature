#!/bin/bash

# Re-generate narrations that are too long (scenes 3, 5, 7, 8, 9, 10, 14, 18, 20, 21, 22, 23, 24)

set -e
cd "$(dirname "$0")" || exit 1

source ../../.env
if [ -z "$FAL_API_KEY" ]; then
    echo "❌ ERROR: FAL_API_KEY not found in .env"
    exit 1
fi

echo "🎙️ RE-GENERATING LONG NARRATIONS (Shortened)"
echo "══════════════════════════════════════════"
echo ""

NARRATOR="Rachel"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

# Scene 3
scene=3
narration_text="From tiny ladybug spots to massive giraffe patches, spots come in every size and serve countless purposes."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 5
scene=5
narration_text="In the Himalayas, the snow leopard's gray rosettes mirror rocky cliffs, making this cat nearly invisible."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 7
scene=7
narration_text="The spotted ray buries itself in sand. Only its spots remain visible, mistaken for harmless pebbles."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 8
scene=8
narration_text="But not all spots hide. Some spots do the opposite: they scream notice me and stay away."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 9
scene=9
narration_text="The poison dart frog's electric blue spots deliver a chemical warning: deadly toxins lie beneath."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 10
scene=10
narration_text="A ladybug's red spots work the same way. Predators never forget, and those spots become a stop sign."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 14
scene=14
narration_text="Spotted hyenas use their markings to recognize clan members. Each pattern is a personal calling card."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 18
scene=18
narration_text="The peacock flounder rewrites its spots daily, adjusting color and spacing to match any surface."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 20
scene=20
narration_text="Evolution's most creative use of spots isn't for identity or camouflage. It's for trickery."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 21
scene=21
narration_text="The owl butterfly's wing spots are fake eyes designed to startle predators into fleeing."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 22
scene=22
narration_text="A pufferfish's spots scramble depth perception, making size impossible to judge before it inflates."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 23
scene=23
narration_text="From camouflage to warning, identity to illusion, spots solve hundreds of problems with one pattern."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi
sleep 0.3

# Scene 24
scene=24
narration_text="The next time you see spots in nature, remember: millions of years of innovation, painted in polka dots."
output_file="audio/scene${scene}.mp3"
echo "🎙️ Regenerating Scene $scene..."
response=$(curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then curl -s -o "$output_file" "$audio_url"; duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0"); if (( $(echo "$duration < 8.0" | bc -l) )); then ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null; mv "audio/scene${scene}_temp.mp3" "$output_file"; fi; echo "✅ Scene $scene: $(printf '%.3f' $duration)s"; fi

echo ""
echo "✨ NARRATION RE-GENERATION COMPLETE!"

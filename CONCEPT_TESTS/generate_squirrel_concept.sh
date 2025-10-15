#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte
SEED=99999

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐿️  GENERATING: THE NUT HEIST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create folder structure
mkdir -p squirrel_nut_heist/{audio,videos,music,final}

cd squirrel_nut_heist || exit

# Generate narration
echo "🎙️  Generating funny narration..."
narration="This is Fred. He just found THE nut. The one. Look at him. This is the most important moment of his life. Now he's paranoid. EVERYTHING is a threat. A leaf. A butterfly. THAT OTHER SQUIRREL IS LOOKING AT IT. Dude. Relax."

response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.9, \"speed\": 1.0}")

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "audio/narration.mp3" "$audio_url"
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "audio/narration.mp3")
    echo "   ✅ Narration generated (${duration}s)"
    
    # Adjust if needed
    if (( $(echo "$duration > 15.5" | bc -l) )); then
        speed=$(echo "$duration / 15.5" | bc -l)
        echo "   ⚙️  Adjusting to fit: ${speed}x"
        ffmpeg -y -i "audio/narration.mp3" -filter:a "atempo=$speed" "audio/narration_fitted.mp3" 2>/dev/null
        mv "audio/narration_fitted.mp3" "audio/narration.mp3"
    fi
fi

# Generate Scene 1 video
echo ""
echo "🎥 Scene 1: Generating video..."
visual1="Gray squirrel (Sciurus carolinensis) with bushy tail, small rounded ears, nimble paws with sharp claws, sitting on tree branch holding single large acorn in both paws, eyes wide with excitement and possessiveness, examining acorn from every angle like it's a precious gem, forest background with autumn trees, macro close-up showing squirrel's expressive face, natural daylight, comedic timing in movements, no speech, ambient forest sounds"

response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"prompt\": \"$visual1\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": $SEED, \"generate_audio\": true}")

video_url=$(echo "$response" | jq -r '.video.url // empty')
if [[ -n "$video_url" ]]; then
    curl -s -o "videos/scene1.mp4" "$video_url"
    echo "   ✅ Scene 1 video saved"
fi

# Generate Scene 2 video
echo ""
echo "🎥 Scene 2: Generating video..."
visual2="Gray squirrel (Sciurus carolinensis) with bushy tail, small rounded ears, nimble paws with sharp claws, now clutching acorn protectively to chest, head darting around frantically in all directions, suspicious eyes scanning for threats, tail twitching nervously, another squirrel visible in background just minding its own business, falling leaf drifting past, butterfly fluttering nearby, squirrel overreacting to everything, comedic paranoid behavior, forest setting, natural lighting, exaggerated movements, no speech, ambient forest sounds"

response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"prompt\": \"$visual2\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": $SEED, \"generate_audio\": true}")

video_url=$(echo "$response" | jq -r '.video.url // empty')
if [[ -n "$video_url" ]]; then
    curl -s -o "videos/scene2.mp4" "$video_url"
    echo "   ✅ Scene 2 video saved"
fi

# Generate Scene 1 music
echo ""
echo "🎵 Scene 1: Generating music..."
music1="Key: C Major, Tempo: 100 BPM, Instrumentation: Playful pizzicato strings, light woodwinds, whimsical xylophone, Mood: Discovery, excitement, comedic treasure moment, lighthearted adventure"

response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"prompt\": \"$music1\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}")

audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then
    curl -s -o "music/scene1.mp3" "$audio_url"
    echo "   ✅ Scene 1 music saved"
fi

# Generate Scene 2 music
echo ""
echo "🎵 Scene 2: Generating music..."
music2="Key: E minor, Tempo: 140 BPM, Instrumentation: Frantic pizzicato strings, quick woodwind runs, suspenseful brass stabs, Mood: Paranoia, comedy chase music, Looney Tunes style, building comedic tension"

response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"prompt\": \"$music2\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}")

audio_url=$(echo "$response" | jq -r '.audio.url // empty')
if [[ -n "$audio_url" ]]; then
    curl -s -o "music/scene2.mp3" "$audio_url"
    echo "   ✅ Scene 2 music saved"
fi

# Concatenate videos
echo ""
echo "📹 Combining videos..."
echo "file 'videos/scene1.mp4'" > video_concat.txt
echo "file 'videos/scene2.mp4'" >> video_concat.txt
ffmpeg -y -f concat -safe 0 -i video_concat.txt -c copy videos/combined_16s.mp4 2>/dev/null
echo "   ✅ Videos combined"

# Concatenate music
echo "🎵 Combining music..."
ffmpeg -y -i music/scene1.mp3 -i music/scene2.mp3 \
    -filter_complex "[0:a][1:a]concat=n=2:v=0:a=1[outa]" \
    -map "[outa]" music/combined_16s.mp3 2>/dev/null
echo "   ✅ Music combined"

# Mix all layers
echo ""
echo "🔊 Mixing all layers..."
ffmpeg -y -i videos/combined_16s.mp4 \
          -i audio/narration.mp3 \
          -i music/combined_16s.mp3 \
    -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
    -map 0:v -map "[audio]" \
    -c:v copy -c:a aac -ac 1 -ar 44100 \
    "../highlights/Squirrel_Nut_Heist_16s.mp4" 2>/dev/null

if [[ -f "../highlights/Squirrel_Nut_Heist_16s.mp4" ]]; then
    size=$(ls -lh "../highlights/Squirrel_Nut_Heist_16s.mp4" | awk '{print $5}')
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "../highlights/Squirrel_Nut_Heist_16s.mp4" | awk '{printf "%.1fs", $1}')
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ THE NUT HEIST COMPLETE!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📱 File: Squirrel_Nut_Heist_16s.mp4"
    echo "⏱️  Duration: $duration"
    echo "📏 Size: $size"
    echo "😂 Style: AFV comedy meets nature doc"
else
    echo "❌ Failed to create final video"
fi


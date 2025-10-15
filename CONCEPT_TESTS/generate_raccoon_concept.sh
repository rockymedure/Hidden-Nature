#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte
SEED=88888

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🦝 GENERATING: THE TRASH CAN HEIST"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create folder structure
mkdir -p raccoon_trash_heist/{audio,videos,music,final}

cd raccoon_trash_heist || exit

# Generate narration
echo "🎙️  Generating funny narration..."
narration="Meet Gerald. He's a professional. Ten years experience breaking into trash cans. This one looks easy. Watch the technique. Little paw action. Some shoulder work. NOPE. Lid's stuck. Okay Plan B. Brute force. Just gonna. Climb on top. And YES! We're in! Living his best life right now."

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
visual1="Raccoon (Procyon lotor) with distinctive black mask around eyes, ringed bushy tail, nimble human-like paws with dexterous fingers, gray-brown fur, standing next to residential trash can examining it with intense focus, using front paws to test the lid, professional burglar stance, backyard setting at dusk, macro shot showing raccoon's clever expression and hand movements, natural evening lighting, comedic determined behavior, no speech, ambient night sounds"

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
visual2="Raccoon (Procyon lotor) with distinctive black mask around eyes, ringed bushy tail, nimble human-like paws with dexterous fingers, gray-brown fur, now triumphantly sitting inside open trash can, front paws holding discarded pizza box, eating enthusiastically, completely satisfied expression, trash can tipped over with contents spilled around, backyard setting at night, victorious burglar who got the score, comedic success pose, natural moonlight, trash scattered around, no speech, ambient night sounds"

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
music1="Key: D minor, Tempo: 90 BPM, Instrumentation: Sneaky pizzicato strings, spy movie bass line, light percussion, playful but suspicious, Mood: Heist planning, Ocean's Eleven for raccoons, clever criminal energy, comedic tension"

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
music2="Key: F Major, Tempo: 120 BPM, Instrumentation: Triumphant horns, celebratory strings, victory fanfare, playful and over the top, Mood: Mission accomplished, comedy heist success, eating celebration, ridiculous triumph"

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
    "../highlights/Raccoon_Trash_Heist_16s.mp4" 2>/dev/null

if [[ -f "../highlights/Raccoon_Trash_Heist_16s.mp4" ]]; then
    size=$(ls -lh "../highlights/Raccoon_Trash_Heist_16s.mp4" | awk '{print $5}')
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "../highlights/Raccoon_Trash_Heist_16s.mp4" | awk '{printf "%.1fs", $1}')
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ THE TRASH CAN HEIST COMPLETE!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📱 File: Raccoon_Trash_Heist_16s.mp4"
    echo "⏱️  Duration: $duration"
    echo "📏 Size: $size"
    echo "🦝 Trash panda professional at work!"
else
    echo "❌ Failed to create final video"
fi



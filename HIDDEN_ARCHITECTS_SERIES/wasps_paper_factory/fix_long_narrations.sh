#!/bin/bash

source .env
NARRATOR="Rachel"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎙️  FIXING LONG NARRATIONS (Scenes 19-24)"
echo "════════════════════════════════════════"
echo ""

# Even more aggressively shortened for scenes 19-24
declare -a ultra_short=(
    # Scene 19 - was 8.20s
    "Design optimization. Structural integrity. Perfect."
    
    # Scene 20 - was 13.00s
    "No leader directs. Simple rules create complex structures."
    
    # Scene 21 - was 10.99s
    "Millions of years perfecting this. Evolution."
    
    # Scene 22 - was 11.78s
    "Every hexagon serves purpose. Function and form."
    
    # Scene 23 - was 8.00s
    "It's instinct. Millions of years of programming."
    
    # Scene 24 - was 9.82s
    "The hidden architect. Patient. Precise. Perfect."
)

for idx in {0..5}; do
    scene=$((19 + idx))
    narration_text="${ultra_short[$idx]}"
    output_file="audio/scene${scene}.mp3"
    
    echo "🎙️  Scene $scene: Shortening further..."
    
    response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$narration_text\",
            \"voice\": \"$NARRATOR\",
            \"stability\": 0.5,
            \"similarity_boost\": 0.75,
            \"style\": 0.5,
            \"speed\": 1.0,
            \"model_id\": \"eleven_turbo_v2_5\"
        }")
    
    audio_url=$(echo "$response" | jq -r '.audio.url // empty')
    if [[ -n "$audio_url" ]]; then
        curl -s -o "$output_file" "$audio_url"
        
        # Get duration
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
        
        # If still over 7.8, apply speedup
        if (( $(echo "$duration > 7.8" | bc -l) )); then
            speed=$(echo "scale=3; 7.5 / $duration" | bc)
            temp_file="audio/scene${scene}_temp.mp3"
            ffmpeg -y -i "$output_file" -filter:a "atempo=$speed" "$temp_file" 2>/dev/null
            mv "$temp_file" "$output_file"
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
        fi
        
        # Pad to 8.0
        if (( $(echo "$duration < 8.0" | bc -l) )); then
            temp_file="audio/scene${scene}_temp.mp3"
            ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "$temp_file" 2>/dev/null
            mv "$temp_file" "$output_file"
        fi
        
        final_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
        printf "   ✅ Scene $scene: %.2fs → 8.00s\n" "$duration"
    fi
    
    sleep 0.3
done

echo ""
echo "✅ Scenes 19-24 shortened!"
echo ""
echo "Now remixing these scenes and recompiling..."

# Remix scenes 19-24 for 16:9
for scene in {19..24}; do
    VIDEO_FILE="videos/scene${scene}.mp4"
    NARRATION_FILE="audio/scene${scene}.mp3"
    MUSIC_FILE="music/scene${scene}_music.wav"
    MIXED_16X9="final/scene${scene}_mixed.mp4"
    
    if [ -f "$VIDEO_FILE" ] && [ -f "$NARRATION_FILE" ] && [ -f "$MUSIC_FILE" ]; then
        ffmpeg -y -i "$VIDEO_FILE" -i "$NARRATION_FILE" -i "$MUSIC_FILE" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac -ac 1 -ar 44100 "$MIXED_16X9" 2>/dev/null
        echo "  ✅ Scene $scene: 16:9 remixed"
    fi
done

# Remix scenes 19-24 for 9:16
for scene in {19..24}; do
    VIDEO_FILE="videos_9x16/scene${scene}.mp4"
    NARRATION_FILE="audio/scene${scene}.mp3"
    MUSIC_FILE="music/scene${scene}_music.wav"
    MIXED_9X16="final_9x16/scene${scene}_mixed.mp4"
    
    if [ -f "$VIDEO_FILE" ] && [ -f "$NARRATION_FILE" ] && [ -f "$MUSIC_FILE" ]; then
        ffmpeg -y -i "$VIDEO_FILE" -i "$NARRATION_FILE" -i "$MUSIC_FILE" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac -ac 1 -ar 44100 "$MIXED_9X16" 2>/dev/null
        echo "  ✅ Scene $scene: 9:16 remixed"
    fi
done

echo ""
echo "Recompiling full documentaries..."

# Recompile 16:9
> final/scene_list.txt
for scene in {1..24}; do
    echo "file 'scene${scene}_mixed.mp4'" >> final/scene_list.txt
done

cd final
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4" 2>/dev/null
cd ..

# Recompile 9:16
> final_9x16/scene_list.txt
for scene in {1..24}; do
    echo "file 'scene${scene}_mixed.mp4'" >> final_9x16/scene_list.txt
done

cd final_9x16
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4" 2>/dev/null
cd ..

echo "✅ Recompiled documentaries"

echo ""
echo "Regenerating highlights..."

TIKTOK_FILE="final_9x16/THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4"
rm -rf highlights/*

segment_num=1
current_time=0
total_duration=192

while [ $current_time -lt $total_duration ]; do
    if [ $((segment_num % 2)) -eq 1 ]; then
        duration=16
    else
        duration=24
    fi
    
    if [ $((current_time + duration)) -le $total_duration ]; then
        output_file="highlights/highlight_${segment_num}_${duration}s.mp4"
        ffmpeg -y -i "$TIKTOK_FILE" -ss $current_time -t $duration -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$output_file" 2>/dev/null
        echo "✅ Highlight $segment_num: ${duration}s"
        
        current_time=$((current_time + duration))
        segment_num=$((segment_num + 1))
    else
        break
    fi
done

echo ""
echo "════════════════════════════════════════"
echo "✨ ALL LONG NARRATIONS FIXED!"
echo "════════════════════════════════════════"
echo ""
echo "📺 UPDATED & READY:"
echo "  ✅ final/THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4"
echo "  ✅ final_9x16/THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4"
echo "  ✅ highlights/ (regenerated)"

#!/bin/bash

echo "🎬 REMIXING ALL SCENES WITH SHORTENED NARRATIONS"
echo "════════════════════════════════════════════════"
echo ""

# Mix 16:9 version
echo "Remixing 16:9 version..."
for scene in {1..24}; do
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

# Mix 9:16 version
echo ""
echo "Remixing 9:16 version..."
for scene in {1..24}; do
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
echo "✅ All scenes remixed!"
echo ""
echo "Recompiling documentaries..."

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

echo "✅ Recompiled: YouTube 16:9 version"
echo "✅ Recompiled: TikTok 9:16 version"

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
echo "════════════════════════════════════════════════"
echo "✨ REMIXING AND RECOMPILATION COMPLETE!"
echo "════════════════════════════════════════════════"
echo ""
echo "📺 UPDATED OUTPUTS:"
echo "  ✅ final/THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4"
echo "  ✅ final_9x16/THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4"
echo "  ✅ highlights/ (new segments)"
echo ""
echo "Ready for upload!"

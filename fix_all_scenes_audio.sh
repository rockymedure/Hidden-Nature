#!/bin/bash

cd black_holes_5min_science

echo "🎬 Fixing all scenes with proper audio mixing..."

# Create new directory for properly mixed scenes
mkdir -p scenes_with_proper_audio

for scene in {1..60}; do
    video_file="raw_videos/scene${scene}.mp4"
    audio_file="raw_audio/scene${scene}.mp3"
    output_file="scenes_with_proper_audio/scene${scene}_mixed.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🔧 Processing scene $scene..."

        # Get video duration
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file")

        # Mix veo3 audio with narration (trimmed to video length)
        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[1:a]atrim=end=${duration},apad=pad_len=0[narration];[0:a][narration]amix=inputs=2:duration=first:dropout_transition=2,volume=1.2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene completed (${duration%.*}s)"
        else
            echo "❌ Scene $scene failed"
        fi
    else
        echo "⚠️  Scene $scene - missing files"
    fi
done

echo ""
echo "🎞️  Creating final documentary with properly mixed audio..."

# Create scene list for concatenation
SCENE_LIST="scenes_with_proper_audio/mixed_scene_list.txt"
> "$SCENE_LIST"

for scene in {1..60}; do
    mixed_file="scenes_with_proper_audio/scene${scene}_mixed.mp4"
    if [[ -f "$mixed_file" ]]; then
        echo "file '$mixed_file'" >> "$SCENE_LIST"
    fi
done

# Final compilation using concat demuxer (should work now with proper audio)
ffmpeg -y -f concat -safe 0 -i "$SCENE_LIST" -c copy "BLACK_HOLES_FINAL_WITH_MIXED_AUDIO.mp4"

if [[ -f "BLACK_HOLES_FINAL_WITH_MIXED_AUDIO.mp4" ]]; then
    # Get stats
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "BLACK_HOLES_FINAL_WITH_MIXED_AUDIO.mp4")
    filesize=$(ls -lh "BLACK_HOLES_FINAL_WITH_MIXED_AUDIO.mp4" | awk '{print $5}')

    echo ""
    echo "🎉 SUCCESS! Documentary with mixed audio completed:"
    echo "   📁 File: BLACK_HOLES_FINAL_WITH_MIXED_AUDIO.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "🎧 This version has:"
    echo "   • Veo3 ambient/background audio"
    echo "   • Rachel's narration mixed on top"
    echo "   • Proper timing sync for each scene"
    echo "   • Variable scene lengths (4/6/8 seconds)"

    # Create sample of first 30 seconds
    ffmpeg -y -i "BLACK_HOLES_FINAL_WITH_MIXED_AUDIO.mp4" -t 30 "sample_30sec_with_narration.mp4" > /dev/null 2>&1

    if [[ -f "sample_30sec_with_narration.mp4" ]]; then
        echo "   📄 Sample created: sample_30sec_with_narration.mp4"
    fi

else
    echo "❌ Failed to create final mixed documentary"
fi
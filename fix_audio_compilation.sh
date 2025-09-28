#!/bin/bash

# Fix audio compilation - rebuild with proper concatenation

echo "🎬 Rebuilding documentary with proper audio concatenation..."

# Create input file list for complex filter
inputs=""
concat_v=""
concat_a=""

for i in {1..60}; do
    inputs="$inputs -i final_scenes/scene${i}_final.mp4"
    concat_v="${concat_v}[$((i-1)):v]"
    concat_a="${concat_a}[$((i-1)):a]"
done

echo "🔧 Building complex filter command..."

# Build the filter complex command
filter_complex="${concat_v}${concat_a}concat=n=60:v=1:a=1[v][a]"

echo "⚡ Running FFmpeg with proper audio concatenation..."

# Run the command
ffmpeg -y $inputs \
    -filter_complex "$filter_complex" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -c:a aac \
    black_holes_5min_FIXED_AUDIO.mp4

if [[ -f "black_holes_5min_FIXED_AUDIO.mp4" ]]; then
    # Get stats
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "black_holes_5min_FIXED_AUDIO.mp4")
    filesize=$(ls -lh "black_holes_5min_FIXED_AUDIO.mp4" | awk '{print $5}')

    echo "✅ SUCCESS! Documentary with narration created:"
    echo "   File: black_holes_5min_FIXED_AUDIO.mp4"
    echo "   Duration: ${duration%.*}s"
    echo "   Size: $filesize"

    # Test audio levels
    ffmpeg -i "black_holes_5min_FIXED_AUDIO.mp4" -af "volumedetect" -vn -f null - 2>&1 | grep "mean_volume\|max_volume"
else
    echo "❌ Failed to create fixed documentary"
fi
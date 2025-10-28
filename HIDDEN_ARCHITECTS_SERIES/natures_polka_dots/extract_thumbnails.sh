#!/bin/bash

mkdir -p thumbnail_frames

echo "📸 EXTRACTING THUMBNAIL FRAMES"
echo "═══════════════════════════════════════"

# Extract one frame from the middle of each scene (4 seconds into each 8-second scene)
for scene in {1..24}; do
    # Calculate timestamp (scene-1)*8 + 4 seconds
    time_seconds=$(( (scene - 1) * 8 + 4 ))
    minutes=$((time_seconds / 60))
    seconds=$((time_seconds % 60))
    timestamp=$(printf "%d:%02d" $minutes $seconds)

    ffmpeg -y -ss $timestamp -i "final/NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4" \
        -frames:v 1 -q:v 2 \
        "thumbnail_frames/scene_$(printf '%02d' $scene)_frame.jpg" 2>/dev/null

    echo "✅ Scene $scene extracted ($timestamp)"
done

echo ""
echo "✨ Complete! Thumbnail options ready"
ls -1 thumbnail_frames/*.jpg | wc -l | xargs echo "Total frames:"

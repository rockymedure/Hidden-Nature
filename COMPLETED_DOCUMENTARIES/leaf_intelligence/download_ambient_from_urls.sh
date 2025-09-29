#!/bin/bash

echo "🍃 Downloading ambient leaf videos from provided URLs"

# Add the video URLs here as you get them from fal dashboard
declare -A video_urls=(
    # [3]="URL_FOR_SCENE_3"
    # [4]="URL_FOR_SCENE_4"
    # [11]="URL_FOR_SCENE_11"
    # [14]="URL_FOR_SCENE_14"
    # Add more as needed...
)

# Download each video
for scene in "${!video_urls[@]}"; do
    url="${video_urls[$scene]}"
    echo "📥 Downloading scene $scene..."
    curl -s -o "ambient_leaf_videos/scene${scene}.mp4" "$url"

    if [[ -f "ambient_leaf_videos/scene${scene}.mp4" ]]; then
        filesize=$(ls -lh "ambient_leaf_videos/scene${scene}.mp4" | awk '{print $5}')
        echo "✅ Scene $scene downloaded ($filesize)"
    else
        echo "❌ Failed to download scene $scene"
    fi
done

echo ""
echo "📊 Download complete!"
total=$(ls ambient_leaf_videos/*.mp4 2>/dev/null | wc -l)
echo "📁 Total ambient videos: $total/24"
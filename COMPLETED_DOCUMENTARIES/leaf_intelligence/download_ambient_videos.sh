#!/bin/bash

# Download remaining ambient leaf videos from saved response files

echo "🍃 Downloading remaining ambient leaf videos"

missing_scenes=(3 4 11 14 15 16 17 18 19 20 21 22 23 24)
downloaded=0

for scene in "${missing_scenes[@]}"; do
    if [ -f "ambient_leaf_videos/scene${scene}_response.json" ]; then
        echo "📥 Checking scene $scene response..."

        video_url=$(jq -r '.video.url' "ambient_leaf_videos/scene${scene}_response.json" 2>/dev/null)

        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            echo "   Downloading from: ${video_url:0:60}..."
            curl -s -o "ambient_leaf_videos/scene${scene}.mp4" "$video_url"

            if [ -f "ambient_leaf_videos/scene${scene}.mp4" ]; then
                filesize=$(ls -lh "ambient_leaf_videos/scene${scene}.mp4" | awk '{print $5}')
                echo "   ✅ Scene $scene downloaded ($filesize)"
                ((downloaded++))
            else
                echo "   ❌ Scene $scene download failed"
            fi
        else
            echo "   ⚠️  No URL found in response for scene $scene"
        fi
    else
        echo "❌ No response file for scene $scene"
    fi
done

echo ""
echo "📊 Downloaded $downloaded additional videos"
total=$(ls ambient_leaf_videos/*.mp4 2>/dev/null | wc -l)
echo "📁 Total ambient videos: $total/24"
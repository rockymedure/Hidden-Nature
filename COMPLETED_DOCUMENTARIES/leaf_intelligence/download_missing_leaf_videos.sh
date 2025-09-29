#!/bin/bash

# Recovery Script: Download Missing Leaf Intelligence Videos
# Fetches completed videos from fal.ai for scenes that didn't download initially

source ../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🍃 Downloading Missing Leaf Intelligence Videos"
echo "🔄 Checking for completed videos in fal.ai dashboard..."

# Check which videos are missing
missing_scenes=()
for scene in {1..24}; do
    if [[ ! -f "leaf_videos/scene${scene}.mp4" ]]; then
        missing_scenes+=($scene)
    fi
done

echo "📊 Missing videos: ${#missing_scenes[@]} out of 24"
echo "Missing scenes: ${missing_scenes[*]}"

if [[ ${#missing_scenes[@]} -eq 0 ]]; then
    echo "✅ All videos already downloaded!"
    exit 0
fi

echo ""
echo "🔍 Fetching completed requests from fal.ai..."

# Get all completed requests
completed_requests=$(curl -s -H "Authorization: Key $FAL_API_KEY" \
    "https://fal.run/fal-ai/veo3/fast/requests" | \
    jq -r '.requests[] | select(.status == "COMPLETED") | "\(.request_id)|\(.input.prompt)|\(.output.video.url)"' 2>/dev/null)

if [[ -z "$completed_requests" ]]; then
    echo "❌ Could not fetch completed requests from fal.ai"
    echo "Please check your API key and try again"
    exit 1
fi

echo "✅ Found completed requests, matching with missing scenes..."

# Download missing videos
for scene in "${missing_scenes[@]}"; do
    echo "🔍 Looking for scene $scene..."

    # Match by seed number in prompt (60000 + scene - 1)
    seed=$((60000 + scene - 1))

    # Find matching request by searching for seed in prompt
    video_url=$(echo "$completed_requests" | grep "seed.*$seed" | cut -d'|' -f3 | head -1)

    if [[ -n "$video_url" && "$video_url" != "null" ]]; then
        echo "📥 Downloading scene $scene from: ${video_url:0:50}..."

        curl -s -o "leaf_videos/scene${scene}.mp4" "$video_url"

        if [[ -f "leaf_videos/scene${scene}.mp4" ]]; then
            filesize=$(ls -lh "leaf_videos/scene${scene}.mp4" | awk '{print $5}')
            echo "✅ Scene $scene downloaded successfully ($filesize)"
        else
            echo "❌ Failed to download scene $scene"
        fi
    else
        echo "❌ Could not find completed video for scene $scene (seed $seed)"
    fi

    sleep 1
done

echo ""
echo "📊 Download Recovery Complete!"

# Final count
total_videos=$(find leaf_videos/ -name "*.mp4" | wc -l)
echo "📁 Total videos now: $total_videos/24"

if [[ $total_videos -eq 24 ]]; then
    echo "🎉 All leaf intelligence videos are now ready!"
    echo ""
    echo "🎬 Next steps:"
    echo "   1. Run audio/video mixing (Step 3 of original script)"
    echo "   2. Create final documentary compilation"
    echo ""
    echo "Ready to continue with: cd /Users/rockymedure/Desktop/hidden_nature/leaf_intelligence_jewel && ./generate_leaf_intelligence.sh"
    echo "(The script will skip video generation and proceed to mixing)"
else
    echo "⚠️  Still missing $((24 - total_videos)) videos"
    echo "You may need to check the fal.ai dashboard manually for remaining videos"
fi
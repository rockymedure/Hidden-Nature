#!/bin/bash

# IMPROVED GENERATION TEMPLATE - Captures URLs immediately
# Prevents lost videos by saving responses as they complete

source ../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🎬 Improved Video Generation with URL Capture"

mkdir -p video_responses video_urls

# Generate videos and IMMEDIATELY capture responses
for scene in {1..24}; do
    (
        echo "📹 Generating scene $scene..."

        # Save full response to file
        response_file="video_responses/scene${scene}_response.json"

        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$prompt\", \"duration\": 8, \"seed\": $seed}" \
            > "$response_file"

        # Extract and save URL immediately
        video_url=$(jq -r '.video.url' "$response_file")

        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            # Save URL to file for recovery
            echo "$video_url" > "video_urls/scene${scene}.url"

            # Download video
            curl -s -o "videos/scene${scene}.mp4" "$video_url"

            echo "✅ Scene $scene: URL saved and video downloaded"
        else
            echo "❌ Scene $scene: Failed - check response file"
        fi
    ) &
    sleep 2
done

wait

echo "📊 Generation complete!"
echo "✅ URLs saved in video_urls/ for recovery"
echo "✅ Full responses saved in video_responses/ for debugging"
#!/bin/bash

source ../.env

echo "🍃 Fetching and downloading ambient leaf videos from fal"
echo ""

# Request IDs provided by user
declare -a request_ids=(
    "4d7e9c36-7977-4568-96ca-1a7673de7a19"
    "c3b00a8e-ebef-4692-97a9-3ef4d06f4fea"
    "49d54c40-3ef6-40cd-9a90-1b855bf677a1"
    "f275a22a-73be-4064-9c88-b8060e86a37d"
    "88bb9515-d628-4f4b-b0f9-f43490f0bd62"
    "0c95ff4b-02a1-4825-9385-ca79384424a8"
    "e0fb6401-0d44-429c-9ce4-e1ba7f5bb384"
    "b1f19cad-9435-4671-95e3-a0aab2497974"
    "67ecc8f1-a2e3-464a-a6a6-3ded71414b28"
    "7c1ac875-3540-43b8-951c-ed10217ff014"
    "4c2f573c-6ba0-41ab-9595-b5d211885842"
    "a8ae75f3-ff60-486d-9bb0-b6f96aae2cc0"
)

# Missing scenes that need downloading
missing_scenes=(3 4 11 14 15 16 17 18 19 20 21 22 23 24)

# Try to fetch each request
for i in "${!request_ids[@]}"; do
    request_id="${request_ids[$i]}"

    # Map to scene number (handle array bounds)
    if [[ $i -lt ${#missing_scenes[@]} ]]; then
        scene="${missing_scenes[$i]}"
    else
        scene=$((i + 3))  # Fallback scene numbering
    fi

    echo "📥 Fetching scene $scene (request: ${request_id:0:8}...)"

    # Try the GET endpoint for completed requests
    response=$(curl -s -X GET \
        -H "Authorization: Key $FAL_API_KEY" \
        "https://fal.run/fal-ai/veo3/fast/requests/$request_id" 2>/dev/null)

    # Extract video URL from response
    video_url=$(echo "$response" | jq -r '.video.url' 2>/dev/null)

    if [[ -n "$video_url" && "$video_url" != "null" ]]; then
        echo "   Downloading video..."
        curl -s -o "ambient_leaf_videos/scene${scene}.mp4" "$video_url"

        if [[ -f "ambient_leaf_videos/scene${scene}.mp4" ]]; then
            filesize=$(ls -lh "ambient_leaf_videos/scene${scene}.mp4" | awk '{print $5}')
            echo "   ✅ Scene $scene saved ($filesize)"
        else
            echo "   ❌ Download failed"
        fi
    else
        echo "   ⚠️  Could not get video URL"
        echo "   Response: $(echo "$response" | head -100)"
    fi

    sleep 1
done

echo ""
echo "📊 Download complete!"
total=$(ls ambient_leaf_videos/*.mp4 2>/dev/null | wc -l)
echo "📁 Total ambient videos: $total/24"
#!/bin/bash

source ../../.env

echo "🍃 Fetching ambient leaf videos from fal.ai"
echo ""

# You need to provide the request IDs from your fal dashboard
# These are example IDs - replace with your actual request IDs
declare -a request_ids=(
    "764cabcf-b745-4b3e-ae38-1200304cf45b"  # Scene 3
    # Add more request IDs here for scenes 4, 11, 14-24
)

missing_scenes=(3 4 11 14 15 16 17 18 19 20 21 22 23 24)

echo "⚠️  Please provide the request IDs from your fal dashboard"
echo "Looking for scenes: ${missing_scenes[*]}"
echo ""

# For now, let's try to fetch using the queue API
for scene in "${missing_scenes[@]}"; do
    echo "🔍 Scene $scene: Checking fal queue..."

    # Try different approaches to get the video
    # First, let's check if we can list recent requests
    response=$(curl -s -H "Authorization: Key $FAL_API_KEY" \
        "https://fal.run/queue/requests" 2>/dev/null)

    if [[ -n "$response" ]]; then
        echo "Got response from fal, parsing..."
        echo "$response" | head -200
    fi

    break  # Just test with one for now
done
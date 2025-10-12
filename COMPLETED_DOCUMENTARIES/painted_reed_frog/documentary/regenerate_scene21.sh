#!/bin/bash
source ../../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
SEED=77777

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎥 REGENERATING SCENE 21 (More Naturalistic)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# More grounded, documentary-style visual description
visual_prompt="Painted Reed Frog (Hyperolius marmoratus) with smooth amphibian skin, compact body typical of reed frogs, large expressive eyes, delicate limbs with adhesive toe pads, on wetland reed stem, brilliant marbled pattern of vivid purple, electric orange, bright yellow, deep magenta. Naturalistic wide shot of nighttime wetland showing main frog in foreground with 3-4 other colorful frogs visible on different reeds in mid-ground and background, natural spacing between frogs, subtle moonlight illumination, realistic nighttime wetland atmosphere, documentary photography style, authentic frog behavior, natural wetland vegetation, organic composition, no speech, ambient wetland sounds with distant frog calls"

echo "🎥 Scene 21: Generating more naturalistic version..."
echo ""

response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
        \"prompt\": \"$visual_prompt\",
        \"duration\": 8,
        \"aspect_ratio\": \"16:9\",
        \"resolution\": \"1080p\",
        \"seed\": $SEED,
        \"generate_audio\": true
    }")

video_url=$(echo "$response" | jq -r '.video.url // empty')
if [[ -n "$video_url" ]]; then
    curl -s -o "videos/scene21.mp4" "$video_url"
    size=$(ls -lh "videos/scene21.mp4" | awk '{print $5}')
    echo "✅ Scene 21: Regenerated with naturalistic approach ($size)"
    echo ""
    echo "Changes made:"
    echo "  • Reduced frog count (3-4 instead of dozens)"
    echo "  • Natural spacing between frogs"
    echo "  • Subtle moonlight instead of dramatic lighting"
    echo "  • Documentary photography style"
    echo "  • Authentic behavior emphasis"
else
    echo "❌ Scene 21: Failed to regenerate"
    echo "$response" | jq '.'
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

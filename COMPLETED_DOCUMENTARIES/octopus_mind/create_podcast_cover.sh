#!/bin/bash
# Create podcast cover image: Mark + Charlotte in living room setting
# Step 1: Generate Mark in podcast room
# Step 2: Composite Charlotte into the scene

set -e

cd /Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/octopus_mind

# Source .env file
if [ -f .env ]; then
    source .env
elif [ -f ../../.env ]; then
    source ../../.env
else
    echo "❌ Error: .env file not found"
    exit 1
fi

echo "🎨 CREATING PODCAST COVER IMAGE"
echo "==============================="
echo ""

CHARLOTTE_IMAGE="field_journal_enhanced/day1_charlotte_introduction.jpg"

if [[ ! -f "$CHARLOTTE_IMAGE" ]]; then
    echo "❌ Charlotte's image not found at $CHARLOTTE_IMAGE"
    exit 1
fi

echo "📸 Step 1: Generating Mark in podcast living room..."
echo ""

# Generate Mark in the podcast room setting
MARK_PROMPT="Warm inviting podcast living room setting, cozy leather couches facing each other, soft ambient lighting from floor lamps, bookshelf with nature books in background, vintage rug, plants, warm golden hour lighting, professional but relaxed atmosphere, side table with microphones and coffee mugs, photorealistic interior design photography, 16:9 cinematic composition, with a relaxed hippie-style male podcaster with beard sitting on left couch, casual button-up shirt, friendly welcoming smile, documentary filmmaker aesthetic, Natural Geographic quality"

# Call nano-banana to generate the base scene
response=$(curl -s -X POST "https://fal.run/fal-ai/nano-banana" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
        \"prompt\": \"$MARK_PROMPT\",
        \"num_images\": 1,
        \"output_format\": \"jpeg\"
    }")

# Extract the image URL
mark_room_url=$(echo "$response" | jq -r '.images[0].url')

if [[ -z "$mark_room_url" || "$mark_room_url" == "null" ]]; then
    echo "❌ Failed to generate Mark in podcast room"
    echo "Response: $response"
    exit 1
fi

# Download the base scene
curl -s -o "podcast_room_with_mark.jpg" "$mark_room_url"
echo "✅ Mark in podcast room generated"
echo ""

echo "📸 Step 2: Uploading Charlotte's image to fal storage..."
# Upload Charlotte's image to fal storage
charlotte_upload_response=$(curl -s -X POST "https://fal.run/fal-ai/files/upload" \
    -H "Authorization: Key $FAL_API_KEY" \
    -F "file=@$CHARLOTTE_IMAGE")

charlotte_url=$(echo "$charlotte_upload_response" | jq -r '.url // .file_url // empty')

if [[ -z "$charlotte_url" ]]; then
    echo "⚠️  Direct upload failed, using podcast_room_with_mark.jpg as base"
    charlotte_url="$mark_room_url"
fi

echo "✅ Images ready for compositing"
echo ""

echo "🎨 Step 3: Compositing Charlotte into the podcast room with Mark..."
echo ""

# Use nano-banana edit to add Charlotte to the scene
COMPOSITE_PROMPT="Add the young female marine biologist Charlotte sitting on the right couch across from Mark, both in conversation, natural body language, Charlotte wearing casual field work clothes, both looking engaged and friendly, photorealistic podcast interview scene, warm lighting, National Geographic documentary quality"

composite_response=$(curl -s -X POST "https://fal.run/fal-ai/nano-banana/edit" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
        \"prompt\": \"$COMPOSITE_PROMPT\",
        \"image_urls\": [\"$mark_room_url\", \"$charlotte_url\"],
        \"num_images\": 1,
        \"output_format\": \"jpeg\"
    }")

# Extract the final composited image
final_url=$(echo "$composite_response" | jq -r '.images[0].url')

if [[ -z "$final_url" || "$final_url" == "null" ]]; then
    echo "❌ Failed to composite Charlotte into scene"
    echo "Response: $composite_response"
    exit 1
fi

# Download the final cover image
curl -s -o "PODCAST_COVER_CHARLOTTE_AND_MARK.jpg" "$final_url"

echo "✅ Final podcast cover created!"
echo ""

echo "🎨 ================================= 🎨"
echo "   PODCAST COVER IMAGE COMPLETE!"
echo "🎨 ================================= 🎨"
echo ""
echo "📁 Generated files:"
ls -lh podcast_room_with_mark.jpg PODCAST_COVER_CHARLOTTE_AND_MARK.jpg 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
echo ""
echo "🖼️  Final cover: PODCAST_COVER_CHARLOTTE_AND_MARK.jpg"
echo "   • Mark (hippie podcaster) on left couch"
echo "   • Charlotte (marine biologist) on right couch"
echo "   • Warm living room podcast setting"
echo "   • Professional but relaxed atmosphere"
echo ""
echo "🎧 Ready for podcast distribution!"
echo ""


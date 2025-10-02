#!/bin/bash
# Create 9:16 mobile version of The Mushroom Apartments

set -e

cd /Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments

echo "📱 CREATING 9:16 MOBILE VERSION"
echo "================================"
echo ""

INPUT_VIDEO="THE_MUSHROOM_APARTMENTS_FINAL.mp4"
OUTPUT_VIDEO="THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4"

if [[ ! -f "$INPUT_VIDEO" ]]; then
    echo "❌ Error: Input video not found: $INPUT_VIDEO"
    exit 1
fi

echo "Input: $INPUT_VIDEO"
echo "Output: $OUTPUT_VIDEO"
echo ""
echo "Converting 16:9 (1920x1080) to 9:16 (1080x1920)..."
echo "Using center crop with slight zoom for mobile optimization"
echo ""

# Calculate crop dimensions
# Original: 1920x1080
# Target: 1080x1920 (9:16)
# Strategy: Crop to 1080x1080 square, then scale to 1080x1920 with slight zoom

ffmpeg -y -i "$INPUT_VIDEO" \
    -vf "crop=1080:1080:(iw-1080)/2:(ih-1080)/2,scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920" \
    -c:v libx264 -preset medium -crf 23 \
    -c:a copy \
    "$OUTPUT_VIDEO" 2>&1 | grep -E "(Duration|time=|Stream)" | head -20

echo ""

if [[ -f "$OUTPUT_VIDEO" ]]; then
    filesize=$(ls -lh "$OUTPUT_VIDEO" | awk '{print $5}')
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT_VIDEO" 2>/dev/null | cut -d. -f1)
    
    echo "✅ MOBILE VERSION COMPLETE!"
    echo ""
    echo "📊 Video Details:"
    echo "   File: $OUTPUT_VIDEO"
    echo "   Duration: $((duration / 60))m $((duration % 60))s"
    echo "   Size: $filesize"
    echo "   Format: 9:16 (1080x1920)"
    echo "   Optimized for: Instagram Reels, TikTok, YouTube Shorts"
    echo ""
    echo "📱 Ready for mobile upload!"
else
    echo "❌ Failed to create mobile version"
    exit 1
fi

echo ""


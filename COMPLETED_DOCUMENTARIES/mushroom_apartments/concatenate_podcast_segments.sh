#!/bin/bash

# Concatenate All Podcast Segments into Full Episode

echo "🎙️  CONCATENATING PODCAST SEGMENTS"
echo "=================================="
echo ""

SEGMENTS_DIR="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments/podcast_segments_full"
OUTPUT_FILE="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments/PODCAST_MUSHROOM_APARTMENTS_FULL.mp3"

# Check if segments exist
if [ ! -d "$SEGMENTS_DIR" ]; then
    echo "❌ Error: Segments directory not found"
    echo "   Run generate_podcast_full_segmented.sh first"
    exit 1
fi

# Count segments
SEGMENT_COUNT=$(ls -1 "$SEGMENTS_DIR"/segment_*.mp3 2>/dev/null | wc -l)

if [ $SEGMENT_COUNT -eq 0 ]; then
    echo "❌ Error: No segments found"
    echo "   Run generate_podcast_full_segmented.sh first"
    exit 1
fi

echo "📊 Found $SEGMENT_COUNT segments"
echo ""

# Create concat list
CONCAT_LIST="/tmp/podcast_concat_list.txt"
> "$CONCAT_LIST"

# Add segments in order
for i in {01..09}; do
    SEGMENT_FILE=$(ls -1 "$SEGMENTS_DIR"/segment_${i}_*.mp3 2>/dev/null | head -1)
    if [ -f "$SEGMENT_FILE" ]; then
        echo "file '$SEGMENT_FILE'" >> "$CONCAT_LIST"
        SEGMENT_NAME=$(basename "$SEGMENT_FILE" .mp3)
        echo "   ✓ $SEGMENT_NAME"
    fi
done

echo ""
echo "🎬 Concatenating segments..."

# Concatenate with ffmpeg
ffmpeg -f concat -safe 0 -i "$CONCAT_LIST" -c copy "$OUTPUT_FILE" -y 2>/dev/null

if [ $? -eq 0 ]; then
    # Get duration
    DURATION=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$OUTPUT_FILE" 2>/dev/null)
    MINUTES=$(echo "$DURATION / 60" | bc)
    SECONDS=$(echo "$DURATION % 60" | bc)
    
    echo ""
    echo "🎉 SUCCESS!"
    echo "=================================="
    echo "Full podcast created:"
    echo "   $OUTPUT_FILE"
    echo ""
    echo "Duration: ${MINUTES}m ${SECONDS%.*}s"
    echo ""
    echo "📂 Individual segments available in:"
    echo "   $SEGMENTS_DIR/"
    echo ""
else
    echo "❌ Error: Concatenation failed"
    exit 1
fi

# Cleanup
rm "$CONCAT_LIST"


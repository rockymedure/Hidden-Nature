#!/bin/bash

# Compile FULL Ambient Leaf Documentary with all 24 original videos
echo "🍃 Creating Complete Ambient Leaf Meditation"
echo "📊 Using all 24 leaf intelligence videos"
echo ""

# Create list of all leaf videos
> full_leaf_list.txt
for i in {1..24}; do
    echo "file 'leaf_videos/scene${i}.mp4'" >> full_leaf_list.txt
    echo "✅ Including scene $i"
done

# Compile all videos
echo ""
echo "🎬 Creating full visual compilation..."
ffmpeg -y -f concat -safe 0 -i full_leaf_list.txt -c copy "FULL_AMBIENT_LEAF_VISUALS.mp4" 2>/dev/null

if [[ -f "FULL_AMBIENT_LEAF_VISUALS.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "FULL_AMBIENT_LEAF_VISUALS.mp4" | cut -d. -f1)
    filesize=$(ls -lh "FULL_AMBIENT_LEAF_VISUALS.mp4" | awk '{print $5}')

    echo ""
    echo "✨ Full Ambient Leaf Visuals Ready!"
    echo "   📁 File: FULL_AMBIENT_LEAF_VISUALS.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🎬 All 24 leaf intelligence scenes included"

    # Add music if we have it
    if [[ -f "Canopy_Whisper_2025-09-28T133339.mp3" ]]; then
        echo ""
        echo "🎵 Adding Canopy Whisper soundtrack..."
        ffmpeg -y -i "FULL_AMBIENT_LEAF_VISUALS.mp4" -i "Canopy_Whisper_2025-09-28T133339.mp3" \
            -c:v copy -c:a aac -shortest "FINAL_FULL_AMBIENT_LEAF.mp4" 2>/dev/null

        if [[ -f "FINAL_FULL_AMBIENT_LEAF.mp4" ]]; then
            final_size=$(ls -lh "FINAL_FULL_AMBIENT_LEAF.mp4" | awk '{print $5}')
            echo "✅ FINAL_FULL_AMBIENT_LEAF.mp4 created ($final_size)"
        fi
    fi
else
    echo "❌ Failed to create compilation"
fi

echo ""
echo "🍃 Complete ambient leaf journey ready!"
#!/bin/bash

# Compile Ambient Leaf Documentary from available videos
# Works with whatever videos we have

echo "🍃 Compiling Ambient Leaf Meditation Documentary"
echo "🎵 Ready for music overlay"

mkdir -p ambient_final

# Check what we have
echo "📊 Checking available videos..."
available_videos=$(ls ambient_leaf_videos/*.mp4 2>/dev/null | sort -V)
video_count=$(echo "$available_videos" | wc -l)

echo "Found $video_count ambient leaf videos"

# Create list of available videos
> ambient_list.txt
for video in $available_videos; do
    echo "file '$video'" >> ambient_list.txt
    echo "✅ Including: $(basename $video)"
done

# Compile without audio first (for music overlay later)
echo ""
echo "🎬 Creating visual compilation..."
ffmpeg -y -f concat -safe 0 -i ambient_list.txt -c copy "AMBIENT_LEAF_VISUALS.mp4" 2>/dev/null

if [[ -f "AMBIENT_LEAF_VISUALS.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "AMBIENT_LEAF_VISUALS.mp4" | cut -d. -f1)
    filesize=$(ls -lh "AMBIENT_LEAF_VISUALS.mp4" | awk '{print $5}')

    echo ""
    echo "✨ Ambient Leaf Visuals Ready!"
    echo "   📁 File: AMBIENT_LEAF_VISUALS.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🎬 Videos included: $video_count scenes"
    echo ""
    echo "   🎵 Next step: Add your meditative leaf music!"
    echo "   Command: ffmpeg -i AMBIENT_LEAF_VISUALS.mp4 -i your_music.mp3 -c:v copy -c:a aac -shortest FINAL_AMBIENT_LEAF.mp4"
else
    echo "❌ Failed to create compilation"
fi

echo ""
echo "🍃 Ready for the meditative leaf journey!"
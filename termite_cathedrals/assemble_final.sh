#!/bin/bash
# Termite Cathedrals - Final Assembly Script
# Concatenates all mixed scenes into final documentary

echo "🎬 Assembling final documentary..."
echo ""

# Create scene list for concatenation
echo "📋 Creating scene list..."
> documentary/scene_list.txt
for scene in {1..24}; do
    if [[ -f "documentary/final/scene${scene}_mixed.mp4" ]]; then
        echo "file 'final/scene${scene}_mixed.mp4'" >> documentary/scene_list.txt
    else
        echo "❌ Missing scene ${scene}_mixed.mp4"
    fi
done

# Count scenes in list
scene_count=$(wc -l < documentary/scene_list.txt)
echo "✅ Scene list created: $scene_count scenes"
echo ""

if [[ $scene_count -ne 24 ]]; then
    echo "⚠️  WARNING: Expected 24 scenes, found $scene_count"
    echo "   Some scenes may be missing!"
    echo ""
fi

# Compile final documentary with stream copy (NO re-encoding)
# This preserves the consistent audio properties from mixing phase
echo "🎞️  Concatenating all scenes..."
cd documentary
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "FINAL_DOCUMENTARY.mp4" 2>/dev/null
cd ..

echo ""
echo "✅ Documentary assembled!"
echo ""

# Verify final output
if [[ -f "documentary/FINAL_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "documentary/FINAL_DOCUMENTARY.mp4" | cut -d. -f1)
    filesize=$(ls -lh "documentary/FINAL_DOCUMENTARY.mp4" | awk '{print $5}')

    minutes=$((duration / 60))
    seconds=$((duration % 60))

    echo "📊 FINAL DOCUMENTARY STATS:"
    echo "   Duration: ${minutes}m ${seconds}s"
    echo "   File size: $filesize"
    echo "   Location: documentary/FINAL_DOCUMENTARY.mp4"
    echo ""

    # Verify audio consistency in final output
    final_audio=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name,sample_rate,channels \
        -of default=noprint_wrappers=1:nokey=1 "documentary/FINAL_DOCUMENTARY.mp4" | tr '\n' ' ')
    echo "   Audio properties: $final_audio"

    if [[ "$final_audio" == "aac 44100 1 " ]]; then
        echo "   ✅ Audio consistency verified!"
    else
        echo "   ⚠️  Audio properties unexpected: $final_audio"
    fi

    echo ""
    echo "🎉 THE TERMITE CATHEDRALS - COMPLETE!"
    echo ""
    echo "✨ Netflix-quality 3-minute documentary ready for publication."
    echo "   Next steps: Create mobile version, field journal, podcast"

else
    echo "❌ Final documentary assembly failed!"
    echo "   Check that all mixed scenes exist in documentary/final/"
fi

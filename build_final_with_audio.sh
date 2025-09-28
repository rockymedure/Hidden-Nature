#!/bin/bash

cd black_holes_5min_science

echo "🎬 Building final documentary with working audio..."

# Create 12 chunks of 5 scenes each
for chunk in {1..12}; do
    start_scene=$(((chunk - 1) * 5 + 1))
    end_scene=$((chunk * 5))

    echo "🔧 Building chunk $chunk (scenes $start_scene-$end_scene)..."

    # Build FFmpeg command for this chunk
    inputs=""
    filter=""
    for i in $(seq $start_scene $end_scene); do
        if [[ -f "final_scenes/scene${i}_final.mp4" ]]; then
            inputs="$inputs -i final_scenes/scene${i}_final.mp4"
            scene_idx=$((i - start_scene))
            filter="${filter}[$scene_idx:v][$scene_idx:a]"
        fi
    done

    # Only proceed if we have scenes for this chunk
    if [[ ! -z "$inputs" ]]; then
        scenes_in_chunk=$((end_scene - start_scene + 1))
        ffmpeg -y $inputs \
            -filter_complex "${filter}concat=n=${scenes_in_chunk}:v=1:a=1[v][a]" \
            -map "[v]" -map "[a]" \
            -c:v libx264 -c:a aac \
            "chunk${chunk}_with_audio.mp4" > /dev/null 2>&1

        if [[ -f "chunk${chunk}_with_audio.mp4" ]]; then
            echo "✅ Chunk $chunk completed"
        else
            echo "❌ Chunk $chunk failed"
        fi
    fi
done

echo "🎞️  Combining all chunks into final documentary..."

# Combine all chunks
chunk_inputs=""
chunk_filter=""
chunk_count=0

for chunk in {1..12}; do
    if [[ -f "chunk${chunk}_with_audio.mp4" ]]; then
        chunk_inputs="$chunk_inputs -i chunk${chunk}_with_audio.mp4"
        chunk_filter="${chunk_filter}[$chunk_count:v][$chunk_count:a]"
        ((chunk_count++))
    fi
done

if [[ $chunk_count -gt 0 ]]; then
    ffmpeg -y $chunk_inputs \
        -filter_complex "${chunk_filter}concat=n=${chunk_count}:v=1:a=1[v][a]" \
        -map "[v]" -map "[a]" \
        -c:v libx264 -c:a aac \
        "black_holes_COMPLETE_WITH_NARRATION.mp4"

    if [[ -f "black_holes_COMPLETE_WITH_NARRATION.mp4" ]]; then
        # Get stats
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "black_holes_COMPLETE_WITH_NARRATION.mp4")
        filesize=$(ls -lh "black_holes_COMPLETE_WITH_NARRATION.mp4" | awk '{print $5}')

        echo ""
        echo "🎉 SUCCESS! Complete documentary with Rachel's narration:"
        echo "   📁 File: black_holes_COMPLETE_WITH_NARRATION.mp4"
        echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
        echo "   💾 Size: $filesize"

        # Test first few seconds of audio
        echo ""
        echo "🎧 Audio test - extracting first 10 seconds..."
        ffmpeg -y -i "black_holes_COMPLETE_WITH_NARRATION.mp4" -t 10 -vn -acodec copy "test_narration_sample.m4a" > /dev/null 2>&1

        if [[ -f "test_narration_sample.m4a" ]]; then
            echo "✅ Audio sample created: test_narration_sample.m4a"
            echo "   This should contain Rachel saying 'Welcome to The Cosmos Chronicles...'"
        fi

        # Clean up chunks
        echo ""
        echo "🧹 Cleaning up temporary chunks..."
        rm -f chunk*_with_audio.mp4

        echo ""
        echo "🎬 Your Netflix-quality black hole documentary with full narration is ready!"

    else
        echo "❌ Failed to create final documentary"
    fi
else
    echo "❌ No chunks were created successfully"
fi
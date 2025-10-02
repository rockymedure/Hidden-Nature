#!/bin/bash
# SIMPLE FINAL COMPILATION - The Mushroom Apartments
# Each scene MUST have: video + audio + music

set -e

cd /Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments

echo "🍄 THE MUSHROOM APARTMENTS - FINAL COMPILATION"
echo "=============================================="
echo ""

# STEP 1: Verify all components exist
echo "STEP 1: VERIFYING ALL COMPONENTS"
echo "---------------------------------"
missing=0
for scene in {1..26}; do
    video="mushroom_videos/scene${scene}.mp4"
    audio="mushroom_audio/scene${scene}.mp3"
    music="mushroom_music/scene${scene}_music.wav"
    
    if [[ ! -f "$video" ]]; then
        echo "❌ Scene $scene: Missing video"
        missing=1
    fi
    if [[ ! -f "$audio" ]]; then
        echo "❌ Scene $scene: Missing audio"
        missing=1
    fi
    if [[ ! -f "$music" ]]; then
        echo "❌ Scene $scene: Missing music"
        missing=1
    fi
done

if [[ $missing -eq 1 ]]; then
    echo ""
    echo "❌ COMPILATION ABORTED: Missing components"
    exit 1
fi

echo "✅ All 26 scenes have video + audio + music"
echo ""

# STEP 2: Mix each scene (video + audio + music)
echo "STEP 2: MIXING ALL 26 SCENES"
echo "-----------------------------"
mkdir -p mushroom_mixed

for scene in {1..26}; do
    video="mushroom_videos/scene${scene}.mp4"
    audio="mushroom_audio/scene${scene}.mp3"
    music="mushroom_music/scene${scene}_music.wav"
    output="mushroom_mixed/scene${scene}_mixed.mp4"
    
    echo "🔊 Scene $scene: Mixing video + audio + music..."
    
    # Mix: Video ambient (17.5%) + Narration (130%) + Music (20%)
    ffmpeg -y \
        -i "$video" \
        -i "$audio" \
        -i "$music" \
        -filter_complex "\
            [0:a]volume=0.175[ambient];\
            [1:a]volume=1.3[narration];\
            [2:a]volume=0.20[music];\
            [ambient][narration][music]amix=inputs=3:duration=first[audio]" \
        -map 0:v \
        -map "[audio]" \
        -c:v copy \
        -c:a aac -ac 1 -ar 44100 \
        "$output" 2>/dev/null
    
    if [[ -f "$output" ]]; then
        size=$(ls -lh "$output" | awk '{print $5}')
        echo "   ✅ Scene $scene mixed ($size)"
    else
        echo "   ❌ Scene $scene FAILED"
        exit 1
    fi
done

echo ""
echo "✅ All 26 scenes successfully mixed"
echo ""

# STEP 3: Create playlist for final assembly
echo "STEP 3: ASSEMBLING FINAL DOCUMENTARY"
echo "-------------------------------------"

> mushroom_final_playlist.txt
for scene in {1..26}; do
    echo "file 'mushroom_mixed/scene${scene}_mixed.mp4'" >> mushroom_final_playlist.txt
done

echo "📝 Playlist created with 26 scenes"
echo ""

# STEP 4: Compile final video
echo "🎬 Concatenating all scenes..."
ffmpeg -y \
    -f concat \
    -safe 0 \
    -i mushroom_final_playlist.txt \
    -c copy \
    "THE_MUSHROOM_APARTMENTS_FINAL.mp4" 2>/dev/null

echo ""

# STEP 5: Verify final output
if [[ -f "THE_MUSHROOM_APARTMENTS_FINAL.mp4" ]]; then
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_MUSHROOM_APARTMENTS_FINAL.mp4" 2>/dev/null | cut -d. -f1)
    filesize=$(ls -lh "THE_MUSHROOM_APARTMENTS_FINAL.mp4" | awk '{print $5}')
    
    echo "🍄 ========================================== 🍄"
    echo "   THE MUSHROOM APARTMENTS - COMPLETE!"
    echo "🍄 ========================================== 🍄"
    echo ""
    echo "📊 Final Documentary:"
    echo "   File: THE_MUSHROOM_APARTMENTS_FINAL.mp4"
    echo "   Duration: $((duration / 60))m $((duration % 60))s"
    echo "   Size: $filesize"
    echo "   Scenes: 26"
    echo ""
    echo "✅ Each scene contains:"
    echo "   • Video visuals"
    echo "   • Jessica narration (8s)"
    echo "   • Scene-specific music"
    echo ""
    echo "🎬 Ready for YouTube upload!"
else
    echo "❌ COMPILATION FAILED"
    exit 1
fi

echo ""


#!/bin/bash

echo "🔧 Padding ALL narrations to exactly 8.000s"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for i in {01..24}; do
    if [[ -f "narrations/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${i}.mp3")
        
        # Pad to exactly 8.000s
        ffmpeg -y -i "narrations/scene${i}.mp3" -af "apad=pad_dur=8.0" -t 8.0 "narrations/temp_scene${i}.mp3" 2>/dev/null
        mv "narrations/temp_scene${i}.mp3" "narrations/scene${i}.mp3"
        
        new_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "narrations/scene${i}.mp3")
        printf "Scene %s: %.3fs → %.3fs ✅\n" "$i" "$duration" "$new_duration"
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All narrations padded to exactly 8.000 seconds!"
echo "   No audio bleeding possible between scenes"


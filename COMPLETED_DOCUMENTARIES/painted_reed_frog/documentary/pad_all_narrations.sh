#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏱️  PADDING ALL NARRATIONS TO EXACTLY 8.000s"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for i in {1..24}; do
    scene_file="narrations/scene$(printf "%02d" $i).mp3"
    
    if [[ -f "$scene_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$scene_file")
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "Scene $(printf "%02d" $i): ${duration}s → 8.000s (padding)"
            ffmpeg -y -i "$scene_file" -af "apad=pad_dur=8.0" -t 8.0 "narrations/temp_scene$(printf "%02d" $i).mp3" 2>/dev/null
            mv "narrations/temp_scene$(printf "%02d" $i).mp3" "$scene_file"
        else
            echo "Scene $(printf "%02d" $i): ${duration}s (already 8.000s or longer, truncating to 8.000s)"
            ffmpeg -y -i "$scene_file" -t 8.0 "narrations/temp_scene$(printf "%02d" $i).mp3" 2>/dev/null
            mv "narrations/temp_scene$(printf "%02d" $i).mp3" "$scene_file"
        fi
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL NARRATIONS PADDED TO 8.000s"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

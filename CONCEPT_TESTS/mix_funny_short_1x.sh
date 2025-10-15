#!/bin/bash
source ../.env

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "😂 MIXING SHORT FUNNY NARRATIONS AT 1X SPEED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for dir in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    case "$dir" in
        jumping_spider) display_name="Jumping_Spider" ;;
        cuttlefish) display_name="Cuttlefish" ;;
        tardigrade) display_name="Tardigrade" ;;
        venus_flytrap) display_name="Venus_Flytrap" ;;
        chameleon) display_name="Chameleon" ;;
        monarch) display_name="Monarch_Butterfly" ;;
    esac
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "😄 $display_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    cd "$dir" || continue
    
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "audio/narration_funny_short.mp3")
    echo "   Narration duration: ${duration}s"
    
    # Only adjust if over 15.5s (to prevent cutoff)
    needs_adjustment=$(echo "$duration > 15.5" | bc -l)
    
    if [[ $needs_adjustment -eq 1 ]]; then
        speed=$(echo "$duration / 15.5" | bc -l)
        echo "   ⚙️  Slight adjustment: ${speed}x (still very natural)"
        ffmpeg -y -i "audio/narration_funny_short.mp3" \
            -filter:a "atempo=$speed" \
            "audio/narration_funny_final.mp3" 2>/dev/null
    else
        echo "   ✅ Perfect at 1x - no adjustment needed"
        cp "audio/narration_funny_short.mp3" "audio/narration_funny_final.mp3"
    fi
    
    # Mix with video and music
    echo "   🔊 Mixing..."
    ffmpeg -y -i videos/combined_16s.mp4 \
              -i audio/narration_funny_final.mp3 \
              -i music/combined_16s.mp3 \
        -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
        -map 0:v -map "[audio]" \
        -c:v copy -c:a aac -ac 1 -ar 44100 \
        "../highlights/${display_name}_16s_FUNNY.mp4" 2>/dev/null
    
    if [[ -f "../highlights/${display_name}_16s_FUNNY.mp4" ]]; then
        size=$(ls -lh "../highlights/${display_name}_16s_FUNNY.mp4" | awk '{print $5}')
        echo "   ✨ ${display_name}_16s_FUNNY.mp4 ($size)"
    else
        echo "   ❌ Failed"
    fi
    
    cd ..
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL FUNNY VERSIONS REMIXED AT 1X SPEED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


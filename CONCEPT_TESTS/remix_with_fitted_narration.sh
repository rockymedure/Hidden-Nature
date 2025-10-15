#!/bin/bash
source ../.env

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔊 REMIXING WITH FITTED NARRATIONS (NO CUTOFF)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Loop through each concept
for dir in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    # Convert directory name to display name
    case "$dir" in
        jumping_spider) display_name="Jumping_Spider" ;;
        cuttlefish) display_name="Cuttlefish" ;;
        tardigrade) display_name="Tardigrade" ;;
        venus_flytrap) display_name="Venus_Flytrap" ;;
        chameleon) display_name="Chameleon" ;;
        monarch) display_name="Monarch_Butterfly" ;;
    esac
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎬 $display_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    cd "$dir" || continue
    
    echo "   🔊 Mixing with fitted narration..."
    
    ffmpeg -y -i videos/combined_16s.mp4 \
              -i audio/narration_16s_fitted.mp3 \
              -i music/combined_16s.mp3 \
        -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
        -map 0:v -map "[audio]" \
        -c:v copy -c:a aac -ac 1 -ar 44100 \
        "../highlights/${display_name}_16s_FINAL.mp4" 2>/dev/null
    
    if [[ -f "../highlights/${display_name}_16s_FINAL.mp4" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "../highlights/${display_name}_16s_FINAL.mp4" | awk '{printf "%.1fs", $1}')
        size=$(ls -lh "../highlights/${display_name}_16s_FINAL.mp4" | awk '{print $5}')
        echo "   ✨ ${display_name}_16s_FINAL.mp4 ($size, $duration)"
    else
        echo "   ❌ Failed to create final mix"
    fi
    
    cd ..
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL CONCEPTS REMIXED - NO CUTOFF!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Final versions in highlights/ folder:"
ls -lh highlights/*_FINAL.mp4 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'


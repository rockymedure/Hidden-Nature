#!/bin/bash
source ../.env

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔊 REMIXING ALL CONCEPTS WITH 16-SECOND CONTINUOUS NARRATIONS"
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
    
    # Step 1: Concatenate videos (scene1 + scene3)
    echo "   📹 Concatenating videos..."
    echo "file 'videos/scene1.mp4'" > video_concat.txt
    echo "file 'videos/scene3.mp4'" >> video_concat.txt
    
    ffmpeg -y -f concat -safe 0 -i video_concat.txt -c copy videos/combined_16s.mp4 2>/dev/null
    echo "      ✅ Videos combined"
    
    # Step 2: Concatenate music (scene1 + scene3) with re-encoding
    echo "   🎵 Concatenating music..."
    ffmpeg -y -i music/scene1.mp3 -i music/scene3.mp3 \
        -filter_complex "[0:a][1:a]concat=n=2:v=0:a=1[outa]" \
        -map "[outa]" music/combined_16s.mp3 2>/dev/null
    echo "      ✅ Music combined"
    
    # Step 3: Mix video + continuous narration + music
    echo "   🔊 Mixing all layers..."
    mkdir -p final
    
    ffmpeg -y -i videos/combined_16s.mp4 \
              -i audio/narration_16s.mp3 \
              -i music/combined_16s.mp3 \
        -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
        -map 0:v -map "[audio]" \
        -c:v copy -c:a aac -ac 1 -ar 44100 \
        "../highlights/${display_name}_16s_v2.mp4" 2>/dev/null
    
    if [[ -f "../highlights/${display_name}_16s_v2.mp4" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "../highlights/${display_name}_16s_v2.mp4" | awk '{printf "%.1fs", $1}')
        size=$(ls -lh "../highlights/${display_name}_16s_v2.mp4" | awk '{print $5}')
        echo "   ✨ ${display_name}_16s_v2.mp4 ($size, $duration)"
    else
        echo "   ❌ Failed to create final mix"
    fi
    
    cd ..
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ ALL CONCEPTS REMIXED WITH CONTINUOUS NARRATIONS!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 New versions in highlights/ folder:"
ls -lh highlights/*_v2.mp4 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'


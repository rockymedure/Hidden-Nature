#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔊 MIXING AND COMPILING ALL 6 CONCEPT TESTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

concepts=("jumping_spider" "cuttlefish" "tardigrade" "venus_flytrap" "chameleon" "monarch")
names=("Jumping_Spider" "Cuttlefish" "Tardigrade" "Venus_Flytrap" "Chameleon" "Monarch_Butterfly")

for i in "${!concepts[@]}"; do
    concept="${concepts[$i]}"
    name="${names[$i]}"
    
    echo "🎬 Processing: $name"
    cd "$concept" || continue
    mkdir -p final
    
    # Mix each scene (3-layer audio: video ambient + narration + music)
    for scene in {1..3}; do
        VIDEO="videos/scene${scene}.mp4"
        NARRATION="audio/scene${scene}.mp3"
        MUSIC="music/scene${scene}.mp3"
        OUTPUT="final/scene${scene}_mixed.mp4"
        
        if [[ -f "$VIDEO" && -f "$NARRATION" && -f "$MUSIC" ]]; then
            ffmpeg -y -i "$VIDEO" -i "$NARRATION" -i "$MUSIC" \
                -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
                -map 0:v -map "[audio]" \
                -c:v copy -c:a aac -ac 1 -ar 44100 \
                "$OUTPUT" 2>/dev/null
            
            echo "   ✅ Scene $scene mixed"
        else
            echo "   ❌ Scene $scene: Missing files"
        fi
    done
    
    # Concatenate 3 scenes into 24-second short
    if [[ -f "final/scene1_mixed.mp4" && -f "final/scene2_mixed.mp4" && -f "final/scene3_mixed.mp4" ]]; then
        cat > final/concat_list.txt << EOF
file 'scene1_mixed.mp4'
file 'scene2_mixed.mp4'
file 'scene3_mixed.mp4'
EOF
        
        ffmpeg -y -f concat -safe 0 -i final/concat_list.txt -c copy "../${name}_24s.mp4" 2>/dev/null
        
        if [[ -f "../${name}_24s.mp4" ]]; then
            size=$(ls -lh "../${name}_24s.mp4" | awk '{print $5}')
            echo "   ✨ ${name}_24s.mp4 compiled ($size)"
        fi
    fi
    
    cd ..
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL 6 CONCEPT TEST SHORTS COMPLETE (24s each)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Final shorts (9:16 format):"
ls -lh *_24s.mp4 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'



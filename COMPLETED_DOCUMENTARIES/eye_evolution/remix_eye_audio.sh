#!/bin/bash

# Remix Eye Evolution Documentary - Enhanced Veo Audio Presence
# Boost ambient video audio while maintaining clear narration

echo "🎵 Remixing Eye Evolution Documentary with Enhanced Veo Audio"
echo "🔊 Boosting ambient video audio for more cinematic presence"

mkdir -p eye_remixed_final

# Enhanced audio mixing - boost ambient from 0.05 to 0.25 for more presence
echo "🎼 STEP 1: Remixing all scenes with enhanced ambient audio..."

for scene in {1..24}; do
    video_file="eye_videos/scene${scene}.mp4"
    audio_file="eye_audio/scene${scene}.mp3"
    output_file="eye_remixed_final/scene${scene}_remixed.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🎵 Scene $scene: Enhanced remix (ambient: 0.05 → 0.25)"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Enhanced remix complete"
        fi
    fi
done

echo ""
echo "🎞️ STEP 2: Creating enhanced final documentary..."

# Create enhanced scene list
> eye_remixed_list.txt
for scene in {1..24}; do
    echo "file 'eye_remixed_final/scene${scene}_remixed.mp4'" >> eye_remixed_list.txt
done

# Final enhanced compilation
ffmpeg -y -f concat -safe 0 -i eye_remixed_list.txt -c copy "EYE_EVOLUTION_ENHANCED_AUDIO.mp4"

if [[ -f "EYE_EVOLUTION_ENHANCED_AUDIO.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "EYE_EVOLUTION_ENHANCED_AUDIO.mp4" | cut -d. -f1)
    filesize=$(ls -lh "EYE_EVOLUTION_ENHANCED_AUDIO.mp4" | awk '{print $5}')

    echo ""
    echo "🔊 SUCCESS! Enhanced Audio Eye Evolution Documentary Complete!"
    echo "   📁 File: EYE_EVOLUTION_ENHANCED_AUDIO.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "   🎵 Audio Enhancements:"
    echo "   • Ambient video audio: 0.05 → 0.25 (5x boost)"
    echo "   • Narration slightly reduced: 1.5 → 1.3 for balance"
    echo "   • Longer crossfade: 2s → 3s for smoother transitions"
    echo "   • More cinematic and immersive audio experience"
    echo ""
    echo "   Compare with original:"
    echo "   📁 Original: EYE_EVOLUTION_JEWEL_1080P.mp4"
    echo "   📁 Enhanced: EYE_EVOLUTION_ENHANCED_AUDIO.mp4"
else
    echo "❌ Failed to create enhanced audio compilation"
fi

echo ""
echo "🎵 Enhanced audio remix complete!"
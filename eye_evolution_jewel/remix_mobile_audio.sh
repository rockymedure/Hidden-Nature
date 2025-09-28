#!/bin/bash

# Remix Eye Evolution Mobile Documentary - Enhanced Veo Audio Presence
# Standardized cinematic audio mix for mobile version

echo "📱 Remixing Eye Evolution Mobile Documentary with Enhanced Veo Audio"
echo "🔊 Applying standardized cinematic audio mix to mobile version"

mkdir -p eye_mobile_remixed_final

# Enhanced audio mixing - standardized cinematic levels
echo "🎼 STEP 1: Remixing all mobile scenes with cinematic audio..."

for scene in {1..24}; do
    video_file="eye_mobile_videos/scene${scene}_mobile.mp4"
    audio_file="eye_audio/scene${scene}.mp3"
    output_file="eye_mobile_remixed_final/scene${scene}_mobile_remixed.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🎵 Mobile Scene $scene: Cinematic remix"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Mobile Scene $scene: Cinematic remix complete"
        fi
    fi
done

echo ""
echo "🎞️ STEP 2: Creating enhanced mobile documentary..."

# Create enhanced mobile scene list
> eye_mobile_remixed_list.txt
for scene in {1..24}; do
    echo "file 'eye_mobile_remixed_final/scene${scene}_mobile_remixed.mp4'" >> eye_mobile_remixed_list.txt
done

# Final enhanced mobile compilation
ffmpeg -y -f concat -safe 0 -i eye_mobile_remixed_list.txt -c copy "EYE_EVOLUTION_MOBILE_ENHANCED_9x16.mp4"

if [[ -f "EYE_EVOLUTION_MOBILE_ENHANCED_9x16.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "EYE_EVOLUTION_MOBILE_ENHANCED_9x16.mp4" | cut -d. -f1)
    filesize=$(ls -lh "EYE_EVOLUTION_MOBILE_ENHANCED_9x16.mp4" | awk '{print $5}')

    echo ""
    echo "📱 SUCCESS! Enhanced Mobile Eye Evolution Documentary Complete!"
    echo "   📁 File: EYE_EVOLUTION_MOBILE_ENHANCED_9x16.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "   🎵 Standardized Cinematic Audio:"
    echo "   • Ambient video audio: 0.25x (cinematic presence)"
    echo "   • Narration: 1.3x (clear and balanced)"
    echo "   • Crossfade: 3s (smooth transitions)"
    echo "   • Optimized for mobile viewing with immersive audio"
    echo ""
    echo "   📱 Perfect for:"
    echo "   • TikTok"
    echo "   • Instagram Reels"
    echo "   • YouTube Shorts"
    echo "   • All 9:16 vertical platforms"
else
    echo "❌ Failed to create enhanced mobile compilation"
fi

echo ""
echo "🎵 Mobile version now has the same cinematic audio quality as desktop!"
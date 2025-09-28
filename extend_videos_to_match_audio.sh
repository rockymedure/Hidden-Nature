#!/bin/bash

cd black_holes_5min_science

echo "🎬 Extending videos to match audio duration..."

# Create directory for extended videos
mkdir -p extended_videos

for scene in {1..60}; do
    video_file="raw_videos/scene${scene}.mp4"
    audio_file="raw_audio/scene${scene}_4s.mp3"  # From regeneration

    if [[ ! -f "$audio_file" ]]; then
        audio_file="raw_audio/scene${scene}_6s.mp3"
    fi
    if [[ ! -f "$audio_file" ]]; then
        audio_file="raw_audio/scene${scene}_8s.mp3"
    fi
    if [[ ! -f "$audio_file" ]]; then
        # Fall back to original
        audio_file="raw_audio/scene${scene}.mp3"
    fi

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        # Get durations
        video_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file")
        audio_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")

        video_dur_int=${video_duration%.*}
        audio_dur_int=${audio_duration%.*}

        echo "🔧 Scene $scene: Video ${video_dur_int}s, Audio ${audio_dur_int}s"

        if (( audio_dur_int > video_dur_int )); then
            # Need to extend video to match audio
            extension_needed=$(echo "$audio_duration - $video_duration" | bc)

            echo "   📏 Extending video by ${extension_needed%.*}s to match narration"

            # Create extended video by looping/slowing the last frame
            extended_file="extended_videos/scene${scene}_extended.mp4"

            # Method: Loop the video to match audio duration
            ffmpeg -y -stream_loop -1 -i "$video_file" -t "$audio_duration" \
                -c:v libx264 -c:a copy \
                "$extended_file" > /dev/null 2>&1

            if [[ -f "$extended_file" ]]; then
                echo "   ✅ Extended video created"

                # Now mix with audio
                final_file="final_scenes/scene${scene}_extended_mixed.mp4"
                ffmpeg -y -i "$extended_file" -i "$audio_file" \
                    -filter_complex "[0:a][1:a]amix=inputs=2:duration=first:dropout_transition=2,volume=1.2[audio]" \
                    -map 0:v -map "[audio]" \
                    -c:v copy -c:a aac \
                    "$final_file" > /dev/null 2>&1

                if [[ -f "$final_file" ]]; then
                    echo "   🎬 Mixed extended scene created"
                else
                    echo "   ❌ Mixing failed"
                fi
            else
                echo "   ❌ Extension failed"
            fi
        else
            # Video is same length or longer - use as is
            echo "   ✅ Video length is adequate"

            final_file="final_scenes/scene${scene}_extended_mixed.mp4"
            ffmpeg -y -i "$video_file" -i "$audio_file" \
                -filter_complex "[0:a][1:a]amix=inputs=2:duration=longest:dropout_transition=2,volume=1.2[audio]" \
                -map 0:v -map "[audio]" \
                -c:v copy -c:a aac \
                "$final_file" > /dev/null 2>&1

            if [[ -f "$final_file" ]]; then
                echo "   🎬 Mixed scene created"
            fi
        fi
    else
        echo "⚠️  Scene $scene - missing files"
    fi
done

echo ""
echo "🎞️  Creating final documentary with extended scenes..."

# Create final compilation with extended scenes
EXTENDED_SCENE_LIST="extended_scene_list.txt"
> "$EXTENDED_SCENE_LIST"

for scene in {1..60}; do
    extended_file="final_scenes/scene${scene}_extended_mixed.mp4"
    if [[ -f "$extended_file" ]]; then
        echo "file '$extended_file'" >> "$EXTENDED_SCENE_LIST"
    fi
done

ffmpeg -y -f concat -safe 0 -i "$EXTENDED_SCENE_LIST" -c copy "BLACK_HOLES_EXTENDED_SCENES.mp4"

if [[ -f "BLACK_HOLES_EXTENDED_SCENES.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "BLACK_HOLES_EXTENDED_SCENES.mp4")
    filesize=$(ls -lh "BLACK_HOLES_EXTENDED_SCENES.mp4" | awk '{print $5}')

    echo ""
    echo "🎉 SUCCESS! Documentary with extended scenes:"
    echo "   📁 File: BLACK_HOLES_EXTENDED_SCENES.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "🎯 Features:"
    echo "   • Videos extended to match Rachel's full narration"
    echo "   • No audio truncation - complete thoughts preserved"
    echo "   • Natural pacing with proper breathing room"
    echo "   • Veo3 ambient audio mixed with narration"

    # Create preview
    ffmpeg -y -i "BLACK_HOLES_EXTENDED_SCENES.mp4" -t 90 "PREVIEW_extended_90sec.mp4" > /dev/null 2>&1

    if [[ -f "PREVIEW_extended_90sec.mp4" ]]; then
        echo "   🎬 Preview: PREVIEW_extended_90sec.mp4"
    fi

else
    echo "❌ Failed to create extended documentary"
fi

echo ""
echo "🎧 Your documentary now has complete narration without cutting off Rachel's explanations!"
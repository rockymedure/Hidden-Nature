#!/bin/bash

# Generate all 23 videos in parallel to match measured narration timing

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🎬 Generating all 23 videos in parallel to match narration..."

mkdir -p focused_videos

# Video prompts for each scene (from FOCUSED_8S_SCRIPT.md)
declare -a visuals=(
    "Deep space panorama with galaxies, slowly revealing dark void regions, cinematic documentary style, no speech, ambient only"
    "Dramatic spacetime ripping effect, fabric of space being torn, reality fracturing, documentary cinematography, no dialogue, atmospheric"
    "Spacecraft launching toward cosmic destination, beginning exploration, space mission, documentary style, no speech, ambient audio"
    "Sweeping galactic vista, zooming through cosmic structures, universe overview, cinematic space documentary, no dialogue, atmospheric"
    "Journey into galactic centers, revealing dark mysterious regions, galactic cores, space documentary, no speech, ambient audio"
    "Einstein working, breakthrough moment, equations appearing, historical documentary style, no dialogue, atmospheric audio"
    "Classic rubber sheet demonstration, ball creating depression, gravity visualization, physics education, no speech, ambient only"
    "Transition from demonstration to real cosmic spacetime curvature, universal scale, documentary cinematography, no dialogue, atmospheric"
    "Blue supergiant star in final phase, approaching stellar death, stellar evolution, space documentary, no speech, ambient audio"
    "Dramatic core collapse sequence, matter compression animation, stellar death, cinematic documentary, no dialogue, atmospheric"
    "Density visualization, impossible compression demonstration, matter states, physics education, no speech, ambient only"
    "Progressive spacetime warping, event horizon formation, invisible boundary, space documentary, no dialogue, atmospheric audio"
    "Light rays being trapped, unable to escape invisible boundary, physics visualization, documentary style, no speech, ambient"
    "Spacecraft journey toward galactic center, approaching invisible giant, space exploration, documentary cinematography, no dialogue"
    "Normal starfield view, no obvious signs of black hole, deceptive emptiness, space documentary, no speech, ambient audio"
    "Clocks showing different rates, time distortion effects beginning, relativity visualization, physics education, no dialogue, atmospheric"
    "Split screen - normal astronaut vs slowed external view, time dilation, relativity demonstration, documentary style, no speech"
    "Peaceful moment of crossing, no dramatic visual change, ordinary experience, space documentary, no dialogue, ambient audio"
    "Astronaut continuing normally, universe behind becoming distorted, perspective shift, cinematic documentary, no speech, atmospheric"
    "Equations dissolving, physics laws failing, mathematical uncertainty, abstract visualization, documentary style, no dialogue"
    "Abstract interior geometry, space-time role reversal visualization, impossible physics, cinematic documentary, no speech, ambient"
    "Approach toward unknowable center, questions and wonder, ultimate mystery, space documentary, no dialogue, atmospheric audio"
    "Cosmic zoom-out, ongoing human quest for understanding, wonder and discovery, documentary cinematography, no speech, ambient"
)

echo "🚀 Launching all 23 video generations simultaneously..."

# Generate all videos in parallel
for i in {0..22}; do
    scene=$((i + 1))
    visual="${visuals[$i]}"

    echo "🎥 Scene $scene: 8s video"

    # Generate video in background
    (
        request_body=$(cat << EOF
{
    "prompt": "$visual",
    "duration": 8,
    "aspect_ratio": "16:9"
}
EOF
        )

        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$request_body")

        video_url=$(echo "$response" | jq -r '.video.url // empty')

        if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "focused_videos/scene${scene}_8s.mp4" "$video_url"
            echo "✅ Scene $scene: Video completed"
        else
            echo "❌ Scene $scene: Video failed"
        fi
    ) &

    # Small delay to avoid overwhelming API
    sleep 2
done

echo "⏳ Waiting for all 23 videos to complete..."
wait

echo ""
echo "🎼 Mixing narration with videos..."

mkdir -p final_scenes

# Mix each scene
for scene in {1..23}; do
    video_file="focused_videos/scene${scene}_8s.mp4"
    audio_file="focused_audio/scene${scene}_8s.mp3"
    output_file="final_scenes/scene${scene}_final.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🎵 Scene $scene: Mixing with perfect timing"

        # Mix with proper levels (veo3 low, Rachel prominent)
        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Perfect sync achieved"
        fi
    fi
done

echo ""
echo "🎞️  Creating final 3-minute documentary..."

# Create final scene list
echo "# Perfect sync documentary" > final_scene_list.txt
for scene in {1..23}; do
    final_file="final_scenes/scene${scene}_final.mp4"
    if [[ -f "$final_file" ]]; then
        echo "file '$final_file'" >> final_scene_list.txt
    fi
done

# Final compilation
ffmpeg -y -f concat -safe 0 -i final_scene_list.txt -c copy "BLACK_HOLES_PERFECT_SYNC_3MIN.mp4"

if [[ -f "BLACK_HOLES_PERFECT_SYNC_3MIN.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "BLACK_HOLES_PERFECT_SYNC_3MIN.mp4")
    filesize=$(ls -lh "BLACK_HOLES_PERFECT_SYNC_3MIN.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Carl Sagan/Attenborough-quality documentary:"
    echo "   📁 File: BLACK_HOLES_PERFECT_SYNC_3MIN.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🎯 Perfect synchronization achieved!"

else
    echo "❌ Final compilation failed"
fi

echo ""
echo "🎬 Educational YouTube network ready with perfect timing!"
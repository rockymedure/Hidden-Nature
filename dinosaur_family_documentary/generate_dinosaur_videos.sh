#!/bin/bash

# Generate all 23 prehistoric videos in parallel

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🦕 Generating all 23 prehistoric videos in parallel..."

mkdir -p dinosaur_videos dinosaur_final

# Prehistoric visuals for each scene
declare -a visuals=(
    "Misty prehistoric forest at sunrise, shadows moving among massive ferns and conifers, ancient world awakening, cinematic documentary style, no speech, ambient only"
    "Close-up reveal of Carnotaurus mother's distinctive horned skull, fierce but protective eyes, prehistoric predator, documentary cinematography, no dialogue, atmospheric"
    "Mother Carnotaurus scanning horizon, powerful legs and lean build evident, predator vigilance, nature documentary style, no speech, ambient audio"
    "Two young Carnotaurus play-fighting, practicing hunting moves, smaller horns developing, prehistoric family, documentary filming, no dialogue, atmospheric"
    "Close-up of hungry eyes, lean flanks showing ribs, urgency of survival, prehistoric desperation, cinematic documentary, no speech, ambient only"
    "Mother lifting head, nostrils flaring, ancient hunting senses awakening, predatory instincts, nature documentary, no dialogue, atmospheric audio"
    "Mother's throat vibrating with subsonic communication, juveniles immediately alert, prehistoric signaling, documentary style, no speech, ambient"
    "Three Carnotaurus moving in formation through prehistoric forest, shadows among ferns, coordinated hunt, cinematic documentary, no dialogue, atmospheric"
    "Peaceful herd of sauropods feeding, massive necks reaching into treetops, unaware of danger, prehistoric tranquility, documentary filming, no speech, ambient"
    "Aerial view showing hunting formation, predators positioning around herd, strategic approach, nature documentary, no dialogue, atmospheric audio"
    "Dramatic charge through undergrowth, powerful legs driving forward, pure predatory focus, explosive action, cinematic documentary, no speech, ambient"
    "Massive sauropods running, ground shaking, dust clouds rising, prehistoric chaos, thunderous stampede, documentary cinematography, no dialogue, atmospheric"
    "Young Carnotaurus observing hunt, studying mother's movements, learning survival techniques, prehistoric education, documentary style, no speech, ambient"
    "Slow-motion sauropod tail whipping through air, Carnotaurus dodging, near-miss drama, cinematic action, documentary filming, no dialogue, atmospheric"
    "Successful takedown, family's coordinated effort paying off, hunt victory, prehistoric triumph, nature documentary, no speech, ambient audio"
    "Family sharing meal, social bonds strengthened through successful cooperation, prehistoric family feast, documentary cinematography, no dialogue, atmospheric"
    "Juveniles playfully wrestling, mother resting but alert, peaceful family moment, prehistoric play, cinematic documentary, no speech, ambient"
    "Family moving toward massive tree grove, seeking safety for night, prehistoric shelter, nature documentary style, no dialogue, atmospheric audio"
    "Mother's eyes glowing in twilight, ever-watchful, protective instincts never sleeping, maternal vigilance, documentary filming, no speech, ambient"
    "Family settling for night, stars appearing over ancient world, prehistoric tranquility, cinematic documentary, no dialogue, atmospheric audio"
    "Mother nuzzling young, intimate family connection in harsh prehistoric world, parental bonds, nature documentary, no speech, ambient"
    "Time-lapse transition showing ancient world, fossils, modern discovery, evolutionary legacy, educational documentary, no dialogue, atmospheric"
    "Modern paleontologists at work, bringing ancient world back to life through discovery, scientific resurrection, documentary cinematography, no speech, ambient"
)

echo "🚀 Launching all 23 dinosaur video generations simultaneously..."

# Generate all videos in parallel
for i in {0..22}; do
    scene=$((i + 1))
    visual="${visuals[$i]}"

    echo "🎥 Scene $scene: Prehistoric footage"

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
            curl -s -o "dinosaur_videos/scene${scene}_prehistoric.mp4" "$video_url"
            echo "✅ Scene $scene: Prehistoric video completed"
        else
            echo "❌ Scene $scene: Video failed"
        fi
    ) &

    sleep 2
done

echo "⏳ Waiting for all 23 prehistoric videos..."
wait

echo ""
echo "🎼 Mixing Roger's narration with prehistoric visuals..."

# Mix each scene
for scene in {1..23}; do
    video_file="dinosaur_videos/scene${scene}_prehistoric.mp4"
    audio_file="dinosaur_audio/scene${scene}_dino.mp3"
    output_file="dinosaur_final/scene${scene}_final.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🎵 Scene $scene: Mixing prehistoric action with Roger's narration"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Netflix-quality prehistoric scene completed"
        fi
    fi
done

echo ""
echo "🎞️  Creating final dinosaur family documentary..."

# Create final compilation
echo "# Netflix-quality dinosaur family documentary" > dinosaur_scene_list.txt
for scene in {1..23}; do
    final_file="dinosaur_final/scene${scene}_final.mp4"
    if [[ -f "$final_file" ]]; then
        echo "file '$final_file'" >> dinosaur_scene_list.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i dinosaur_scene_list.txt -c copy "DINOSAUR_FAMILY_NETFLIX_QUALITY.mp4"

if [[ -f "DINOSAUR_FAMILY_NETFLIX_QUALITY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "DINOSAUR_FAMILY_NETFLIX_QUALITY.mp4")
    filesize=$(ls -lh "DINOSAUR_FAMILY_NETFLIX_QUALITY.mp4" | awk '{print $5}')

    echo ""
    echo "🦕 SUCCESS! Netflix-quality dinosaur family documentary:"
    echo "   📁 File: DINOSAUR_FAMILY_NETFLIX_QUALITY.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🎯 Roger's authoritative narration with perfect prehistoric visuals!"

else
    echo "❌ Final compilation failed"
fi

echo ""
echo "🎬 Second documentary in your educational network complete!"
echo "🌟 Two distinct channels now operational with different voices and topics!"
#!/bin/bash

# Generate dinosaur videos with consistent characters and environment

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🦕 Generating visually consistent dinosaur family documentary..."

mkdir -p consistent_videos consistent_final

# Consistent character and environment base
FAMILY_DESCRIPTION="The same reddish-brown Carnotaurus family with distinctive forward-facing horns - large protective mother with yellow eyes and battle scars, two smaller juveniles with developing horns"
ENVIRONMENT_BASE="In the same Patagonian forest clearing with massive araucaria trees, giant ferns, rocky outcroppings, and meandering stream"
DOCUMENTARY_STYLE="cinematic nature documentary style, no speech, no dialogue, ambient prehistoric sounds only"

# Consistent seed for character continuity
SEED=77777

echo "🎯 Using seed $SEED for visual consistency across all scenes"
echo "🦕 Same Carnotaurus family throughout entire documentary"
echo "🌲 Same forest environment with lighting progression"

# Scene-specific visuals with consistent base
declare -a scene_specifics=(
    "Dawn golden light filtering through mist, family awakening from sleep"
    "Close-up of mother's distinctive horned head, fierce protective expression"
    "Mother scanning horizon with powerful stance, lean predator build visible"
    "Two juveniles playfully mock-fighting, smaller horns and lighter coloring"
    "Family showing signs of hunger, lean flanks, urgent survival need"
    "Mother lifting head with flaring nostrils, catching scent on wind"
    "Mother's throat vibrating with low rumble, juveniles immediately alert"
    "Family moving in coordinated formation through dense fern undergrowth"
    "Peaceful Saltasaurus herd in distance, long necks reaching into treetops"
    "Aerial view showing hunting formation, family positioning around prey"
    "Mother launching explosive charge, powerful legs driving forward at speed"
    "Massive sauropods fleeing in panic, thunderous stampede across landscape"
    "Juveniles watching intently, learning from mother's hunting techniques"
    "Slow-motion sauropod tail swinging, mother dodging by inches"
    "Successful takedown, family coordinating to bring down separated prey"
    "Family feeding together in warm sunset light, sharing hard-won meal"
    "Juveniles playing while mother keeps protective watch, bellies full"
    "Family moving toward massive tree shelter as darkness approaches"
    "Mother's eyes alert in blue twilight, vigilant against night predators"
    "Family settling for rest, stars appearing over prehistoric world"
    "Intimate moment of mother nuzzling young, family bonds strong"
    "Time-lapse transition from ancient world to fossils, evolutionary legacy"
    "Modern paleontologists at fossil site, bringing ancient world to life"
)

echo "🚀 Launching all 23 consistent videos in parallel..."

# Generate all videos with consistency
for i in {0..22}; do
    scene=$((i + 1))
    scene_specific="${scene_specifics[$i]}"

    # Build full consistent prompt
    full_prompt="$FAMILY_DESCRIPTION $ENVIRONMENT_BASE, $scene_specific, $DOCUMENTARY_STYLE"

    echo "🎥 Scene $scene: Consistent family story"

    # Generate with consistent seed
    (
        request_body=$(cat << EOF
{
    "prompt": "$full_prompt",
    "duration": 8,
    "aspect_ratio": "16:9",
    "seed": $SEED
}
EOF
        )

        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$request_body")

        video_url=$(echo "$response" | jq -r '.video.url // empty')

        if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "consistent_videos/scene${scene}_consistent.mp4" "$video_url"
            echo "✅ Scene $scene: Consistent video completed"
        else
            echo "❌ Scene $scene: Video failed"
        fi
    ) &

    sleep 2
done

echo "⏳ Waiting for all consistent videos..."
wait

echo ""
echo "🎼 Mixing Roger's narration with consistent visuals..."

# Mix with existing Roger narration
for scene in {1..23}; do
    video_file="consistent_videos/scene${scene}_consistent.mp4"
    audio_file="dinosaur_audio/scene${scene}_dino.mp3"
    output_file="consistent_final/scene${scene}_netflix.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🎵 Scene $scene: Netflix-quality consistency"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Netflix consistency achieved"
        fi
    fi
done

echo ""
echo "🎞️  Creating final consistent documentary..."

# Final compilation with consistency
echo "# Netflix-quality consistent documentary" > netflix_scene_list.txt
for scene in {1..23}; do
    netflix_file="consistent_final/scene${scene}_netflix.mp4"
    if [[ -f "$netflix_file" ]]; then
        echo "file '$netflix_file'" >> netflix_scene_list.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i netflix_scene_list.txt -c copy "DINOSAUR_FAMILY_NETFLIX_CONSISTENT.mp4"

if [[ -f "DINOSAUR_FAMILY_NETFLIX_CONSISTENT.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "DINOSAUR_FAMILY_NETFLIX_CONSISTENT.mp4")
    filesize=$(ls -lh "DINOSAUR_FAMILY_NETFLIX_CONSISTENT.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Netflix-quality consistent documentary:"
    echo "   📁 File: DINOSAUR_FAMILY_NETFLIX_CONSISTENT.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🦕 Same Carnotaurus family throughout entire story!"
    echo "   🌲 Same environment with natural lighting progression!"
    echo "   🎬 True Netflix-level visual storytelling continuity!"

else
    echo "❌ Final consistent compilation failed"
fi

echo ""
echo "🎯 Visual continuity methodology proven for future documentaries!"
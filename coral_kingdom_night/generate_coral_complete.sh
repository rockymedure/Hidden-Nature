#!/bin/bash

# Complete coral kingdom night documentary production

source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🐠 Creating Netflix-quality coral kingdom night transformation..."

mkdir -p coral_audio coral_videos coral_final

# STEP 1: Generate all narration first
echo "🎵 STEP 1: Generating Charlotte's underwater narration..."

declare -a narrations=(
    "As tropical sunlight illuminates the coral kingdom, a vibrant world thrives in harmony."
    "These ancient coral polyps have built a metropolis that houses millions of creatures."
    "Parrotfish graze peacefully while angelfish patrol their carefully defended territories."
    "In crevices and caves, the night hunters rest, waiting for darkness to fall."
    "But as the sun sinks toward the horizon, this peaceful world prepares to transform."
    "In the gathering dusk, the reef's nocturnal residents begin to stir from their slumber."
    "Daytime fish seek shelter in coral branches as more dangerous hunters take their place."
    "Moray eels slide from their caves while reef sharks begin their nightly patrol."
    "In minutes, the peaceful coral garden becomes a theater of life and death."
    "Under cover of darkness, the reef's most skilled predators begin their nightly hunt."
    "A grouper strikes with lightning speed, swallowing its prey in a single gulp."
    "The moray eel rules the night, its powerful jaws capable of crushing bone."
    "Smaller fish flatten against coral walls, hoping to become invisible to passing predators."
    "The reef shark glides silently through its domain, senses tuned to movement."
    "As midnight approaches, the reef reveals its most spectacular secret - living light."
    "Tonight is spawning night, when corals release millions of eggs in synchronized celebration."
    "Fish glow like underwater spirits, their scales reflecting the coral's ethereal light."
    "Disturbed plankton create galaxies of light, each movement sparking blue fire in water."
    "The reef becomes a living constellation, pulsing with ancient rhythms of the sea."
    "As dawn breaks through the water, the magical lights begin to fade away."
    "The night hunters retreat to their caves as the day shift prepares to emerge."
    "Once again, the reef transforms into the peaceful kingdom we know by day."
    "This ancient rhythm continues as it has for millions of years, night after night."
)

# Generate all narrations in parallel
for i in {0..22}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    (
        curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"text\": \"$narration\", \"voice\": \"Charlotte\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
            | jq -r '.audio.url' | xargs -I {} curl -s -o "coral_audio/scene${scene}.mp3" {}
        echo "✅ Scene $scene: Coral narration completed"
    ) &
    sleep 0.5
done

echo "⏳ Waiting for all coral narration..."
wait

echo ""
echo "🎥 STEP 2: Generating 1080p videos with environmental transformation..."

# Reef location with environmental moods
REEF_BASE="The same vibrant coral reef with distinctive brain coral formations, colorful parrotfish, and territorial angelfish"

declare -A environments=(
    ["daylight_reef"]="99999|Bright tropical sunlight filtering through clear blue water, vibrant coral colors, peaceful daytime activity"
    ["twilight_reef"]="99990|Dimming light with deeper blue water, shadows growing, atmospheric transition to night"
    ["night_reef"]="99991|Dark underwater environment with mysterious shadows, nocturnal predators active, dramatic lighting"
    ["bioluminescent_reef"]="99992|Magical bioluminescent glow, fluorescent coral, glowing plankton, ethereal underwater light show"
)

declare -a scene_environments=(
    "daylight_reef" "daylight_reef" "daylight_reef" "daylight_reef" "daylight_reef"    # Scenes 1-5
    "twilight_reef" "twilight_reef" "twilight_reef" "twilight_reef"                    # Scenes 6-9
    "night_reef" "night_reef" "night_reef" "night_reef" "night_reef"                   # Scenes 10-14
    "bioluminescent_reef" "bioluminescent_reef" "bioluminescent_reef" "bioluminescent_reef" "bioluminescent_reef" # Scenes 15-19
    "daylight_reef" "daylight_reef" "daylight_reef" "daylight_reef"                    # Scenes 20-23 (RETURN)
)

declare -a scene_actions=(
    "peaceful daytime coral reef activity, colorful fish swimming casually"
    "close-up of healthy coral formations with tiny fish darting between branches"
    "parrotfish grazing and angelfish patrolling, normal daytime behavior"
    "dormant predators hiding in caves and shadows, waiting for night"
    "light beginning to dim, subtle color changes, anticipation building"
    "night creatures stirring in crevices, eyes glowing, nocturnal awakening"
    "small fish hiding in coral protection, seeking safe spaces from predators"
    "dramatic emergence of eels and sharks, predatory transformation beginning"
    "same reef now darker and more dramatic, completely different atmosphere"
    "multiple predators moving through dark reef, coordinated night hunting"
    "dramatic predation event, swift grouper attack, life-and-death moment"
    "moray eel hunting in coral crevices, intimidating nocturnal presence"
    "fish camouflaging against coral walls, survival tactics in darkness"
    "reef shark gliding silently, elegant predatory movement through darkness"
    "coral beginning to fluoresce, bioluminescent plankton, magical underwater glow"
    "dramatic coral spawning event, clouds of eggs, underwater snow effect"
    "fluorescent fish swimming through glowing reef, otherworldly beauty"
    "bioluminescent plankton clouds, magical light trails, underwater aurora"
    "wide shot of entire reef glowing, pulsing patterns, breathtaking bioluminescence"
    "early morning light returning, bioluminescence fading, peaceful transition"
    "sharks and eels returning to hiding spots, day shift preparing"
    "same reef as opening, bright and colorful, normal daytime restoration"
    "final wide shot of peaceful reef, eternal cycle completing"
)

# Generate all videos in parallel
for i in {0..22}; do
    scene=$((i + 1))
    env_key="${scene_environments[$i]}"
    env_data="${environments[$env_key]}"
    IFS='|' read -r seed env_description <<< "$env_data"
    scene_action="${scene_actions[$i]}"

    full_prompt="$REEF_BASE in $env_description, $scene_action, cinematic underwater documentary style, no speech, no dialogue, ambient ocean sounds only"

    echo "🌊 Scene $scene: $env_key (Seed $seed)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "coral_videos/scene${scene}_${env_key}.mp4" {}
        echo "✅ Scene $scene: Coral transformation completed"
    ) &
    sleep 2
done

echo "⏳ Waiting for all 1080p coral transformation videos..."
wait

echo ""
echo "🎼 STEP 3: Mixing Charlotte's narration with coral visuals..."

# Mix all scenes
for i in {0..22}; do
    scene=$((i + 1))
    env_key="${scene_environments[$i]}"
    video_file="coral_videos/scene${scene}_${env_key}.mp4"
    audio_file="coral_audio/scene${scene}.mp3"
    output_file="coral_final/scene${scene}_coral_1080p.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🌊 Scene $scene: Mixing ${env_key} with Charlotte's narration"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Coral magic achieved"
        fi
    fi
done

echo ""
echo "🎞️  STEP 4: Creating final coral kingdom documentary..."

# Final compilation
for scene in {1..23}; do
    echo "file 'coral_final/scene${scene}_coral_1080p.mp4'" >> coral_final_list.txt
done

ffmpeg -y -f concat -safe 0 -i coral_final_list.txt -c copy "CORAL_KINGDOM_NIGHT_NETFLIX_1080P.mp4"

if [[ -f "CORAL_KINGDOM_NIGHT_NETFLIX_1080P.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "CORAL_KINGDOM_NIGHT_NETFLIX_1080P.mp4")
    filesize=$(ls -lh "CORAL_KINGDOM_NIGHT_NETFLIX_1080P.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Coral Kingdom Night Documentary:"
    echo "   📁 File: CORAL_KINGDOM_NIGHT_NETFLIX_1080P.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🐠 Charlotte's calming narration with underwater wonder!"
    echo "   ✨ Bioluminescent magic and coral transformation!"
    echo "   🎬 Environmental storytelling: Day → Night → Bioluminescence → Dawn!"

else
    echo "❌ Final coral compilation failed"
fi

echo ""
echo "🌊 Fourth documentary in your educational network complete!"
echo "🎯 Underwater visual dynamics methodology proven!"
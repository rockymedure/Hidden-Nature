#!/bin/bash

# Eye Evolution Documentary - The Jewel of Evolution
# Using seed drift for smooth evolutionary progression

source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "👁️ Creating 'The Jewel of Evolution: Eyes Across Life' Documentary"
echo "🌟 Using seed drift (50000-50023) for evolutionary progression"

mkdir -p eye_audio eye_videos eye_final

# STEP 1: Generate all narration
echo "🎵 STEP 1: Generating Rachel's narration about the jewels of evolution..."

declare -a narrations=(
    "Five hundred million years ago, the first eye appeared - just a patch of light-sensitive cells."
    "The Cambrian explosion brought compound eyes - suddenly, predators could see prey."
    "Trilobites invented lenses from calcite crystals - nature's first high-definition vision."
    "Dragonflies see the world through thirty thousand tiny lenses, each capturing its own image."
    "Fish eyes evolved spherical lenses - perfect for focusing light in water's density."
    "The four-eyed fish splits its vision - half for air, half for water simultaneously."
    "In the abyss, eyes grow enormous, capturing every photon in perpetual darkness."
    "Mantis shrimp see sixteen types of color receptors - we have only three."
    "Chameleons rotate each eye independently - three hundred sixty degree awareness."
    "Cat eyes maximize night vision - pupils that open eight times wider than humans."
    "Eagles possess vision eight times sharper than ours, spotting prey from miles above."
    "Gecko eyes are three hundred fifty times more light-sensitive than human eyes."
    "Butterflies see ultraviolet patterns invisible to us - hidden messages on every flower."
    "Jumping spiders have telephoto eyes - tubes that extend deep into their heads."
    "Scallops use mirrors instead of lenses - up to two hundred tiny reflecting telescopes."
    "Octopus eyes evolved separately yet match ours perfectly - convergent evolution's masterpiece."
    "Owl eyes are tubes, not spheres - fixed telescopes that occupy seventy percent of their skulls."
    "Pit vipers see heat itself - infrared vision revealing warm-blooded prey in total darkness."
    "Bees detect polarized light patterns, using the sun's position even through clouds."
    "Dolphins see equally well in air and water - eyes that conquer two worlds."
    "Human eyes distinguish ten million colors, focus from inches to infinity in milliseconds."
    "Alone among animals, human eyes evolved white sclera - revealing our thoughts and intentions."
    "From simple light detection to nature's most complex organ - the eye, jewel of evolution."
    "Every eye that ever evolved shares the same purpose - to capture ancient starlight."
)

# Generate all narrations in parallel
for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    (
        curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"text\": \"$narration\", \"voice\": \"Rachel\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
            | jq -r '.audio.url' | xargs -I {} curl -s -o "eye_audio/scene${scene}.mp3" {}
        echo "✅ Scene $scene: Narration complete"
    ) &
    sleep 0.5
done

echo "⏳ Waiting for all narration..."
wait

echo ""
echo "👁️ STEP 2: Generating eye evolution videos with seed drift..."

# Visual descriptions with evolutionary progression
declare -a visuals=(
    "Primordial ocean with simple eyespot on ancient organism, first light detection beginning, dawn of vision"
    "Trilobite compound eyes with crystalline lenses, ancient ocean predator, Cambrian explosion visualization"
    "Close-up trilobite eye showing calcite crystal structure, light bending through mineral lens, nature's optics"
    "Dragonfly compound eye surface showing thousands of ommatidia, mosaic vision pattern, jewel-like iridescence"
    "Fish eye cross-section showing spherical lens, underwater light rays converging, aquatic adaptation"
    "Four-eyed fish Anableps with horizontally divided eyes, simultaneous air and water vision, unique adaptation"
    "Giant squid colossal eye in deep ocean darkness, bioluminescent environment, extreme size comparison"
    "Mantis shrimp eye with complex color receptors, rainbow spectrum visualization, most advanced color vision"
    "Chameleon eyes rotating independently, 360-degree coverage demonstration, precise targeting system"
    "Cat eye with vertical pupil dilating, tapetum lucidum glowing, superior night vision capability"
    "Eagle eye anatomy showing dual fovea system, incredible zoom capability, aerial predator vision"
    "Gecko eye at night showing massive pupils, specialized photoreceptors, seeing color in darkness"
    "Butterfly eye perspective showing ultraviolet flower patterns, hidden UV messages revealed, pollinator vision"
    "Jumping spider anterior eyes showing telescopic tubes, depth perception mechanism, predator precision"
    "Scallop with hundreds of tiny mirror eyes, unique reflection-based vision, crystalline array"
    "Octopus eye structure compared with human eye, convergent evolution example, independent development"
    "Owl eye tubular structure filling skull, enormous size relative to head, night hunting perfection"
    "Pit viper heat vision showing infrared detection, thermal imaging overlay, warm prey visibility"
    "Bee compound eye detecting polarized light, navigation by sky patterns, solar compass"
    "Dolphin eye adapted for air and water, amphibious vision system, marine mammal evolution"
    "Human eye cross-section showing complex structure, iris patterns unique as fingerprints, focusing mechanism"
    "Human eyes showing emotions through white sclera, unique communication feature, social evolution"
    "Montage of all eye types from simple to complex, evolutionary tree visualization, diversity celebration"
    "Zoom from human eye iris pattern to cosmos, starlight entering pupil, universal connection to light"
)

echo "🚀 Launching all 24 videos with evolutionary seed drift..."

# Generate videos with seed drift
for i in {0..23}; do
    scene=$((i + 1))
    seed=$((50000 + i))  # Seed drift: 50000 → 50023
    visual="${visuals[$i]}"

    full_prompt="$visual, macro photography style, crystalline detail, jewel-like quality, cinematic documentary, no speech, ambient only"

    echo "👁️ Scene $scene: Generating with seed $seed (evolutionary stage $((i + 1))/24)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "eye_videos/scene${scene}.mp4" {}
        echo "✅ Scene $scene: Eye visualization complete (seed: $seed)"
    ) &
    sleep 2
done

echo "⏳ Waiting for all eye evolution videos..."
wait

echo ""
echo "🎼 STEP 3: Mixing audio and video..."

# Mix all scenes
for scene in {1..24}; do
    video_file="eye_videos/scene${scene}.mp4"
    audio_file="eye_audio/scene${scene}.mp3"
    output_file="eye_final/scene${scene}_final.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "👁️ Scene $scene: Creating final mix"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Complete"
        fi
    fi
done

echo ""
echo "🎞️ STEP 4: Creating final documentary..."

# Create scene list
for scene in {1..24}; do
    echo "file 'eye_final/scene${scene}_final.mp4'" >> eye_final_list.txt
done

# Final compilation
ffmpeg -y -f concat -safe 0 -i eye_final_list.txt -c copy "EYE_EVOLUTION_JEWEL_1080P.mp4"

if [[ -f "EYE_EVOLUTION_JEWEL_1080P.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "EYE_EVOLUTION_JEWEL_1080P.mp4")
    filesize=$(ls -lh "EYE_EVOLUTION_JEWEL_1080P.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Eye Evolution Documentary Complete!"
    echo "   📁 File: EYE_EVOLUTION_JEWEL_1080P.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "   👁️ Features:"
    echo "   • 500 million years of eye evolution"
    echo "   • 24 different vision systems"
    echo "   • Seed drift creating smooth visual evolution"
    echo "   • From simple light detection to human vision"
    echo "   • The jewel of evolution revealed!"
else
    echo "❌ Failed to create final compilation"
fi

echo ""
echo "👁️ 'Hidden Worlds: The Jewel of Evolution' documentary complete!"
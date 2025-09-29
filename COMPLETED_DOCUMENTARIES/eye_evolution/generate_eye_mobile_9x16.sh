#!/bin/bash

# Mobile Version - Eye Evolution Documentary (9:16 vertical format)
# Perfect for TikTok, Instagram Reels, YouTube Shorts

source ../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "📱 Creating Mobile Version: 'The Jewel of Evolution'"
echo "🌟 9:16 vertical format with seed drift (50000-50023)"

mkdir -p eye_mobile_videos eye_mobile_final

# Check if we already have the audio from desktop version
if [[ -d "eye_audio" && $(ls eye_audio/*.mp3 2>/dev/null | wc -l) -eq 24 ]]; then
    echo "✅ Using existing audio from desktop version"
else
    echo "🎵 Generating mobile narration..."

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

    for i in {0..23}; do
        scene=$((i + 1))
        narration="${narrations[$i]}"

        (
            curl -s -X POST "$AUDIO_ENDPOINT" \
                -H "Authorization: Key $FAL_API_KEY" \
                -H "Content-Type: application/json" \
                -d "{\"text\": \"$narration\", \"voice\": \"Rachel\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
                | jq -r '.audio.url' | xargs -I {} curl -s -o "eye_audio/scene${scene}.mp3" {}
            echo "✅ Scene $scene: Audio ready"
        ) &
        sleep 0.5
    done

    echo "⏳ Waiting for audio generation..."
    wait
fi

echo ""
echo "📱 STEP 2: Generating mobile 9:16 videos with evolutionary seed drift..."

# Mobile-optimized visual descriptions (vertical framing)
declare -a mobile_visuals=(
    "Vertical view primordial ocean, simple eyespot organism centered, first light detection, mobile format"
    "Portrait trilobite compound eyes, crystalline lenses close-up, Cambrian predator, vertical framing"
    "Vertical macro shot trilobite eye, calcite crystal structure visible, nature's optics, mobile optimized"
    "Portrait dragonfly compound eye, thousands of ommatidia visible, jewel-like surface, 9:16 format"
    "Vertical fish eye cross-section, spherical lens detail, underwater optics, mobile screen optimized"
    "Portrait four-eyed fish Anableps, split vision system visible, unique adaptation, vertical composition"
    "Vertical giant squid eye, enormous size comparison, deep ocean darkness, mobile format"
    "Portrait mantis shrimp eyes, complex color receptors, rainbow visualization, 9:16 framing"
    "Vertical chameleon face, eyes rotating independently, 360-degree awareness, mobile optimized"
    "Portrait cat eye dilating, vertical pupil expanding, night vision, mobile screen format"
    "Vertical eagle eye close-up, dual fovea visible, predator precision, 9:16 composition"
    "Portrait gecko eye at night, massive pupil, darkness vision, mobile vertical format"
    "Vertical butterfly eye view, UV patterns revealed, hidden messages, mobile optimized"
    "Portrait jumping spider eyes, telescopic tubes visible, depth perception, vertical framing"
    "Vertical scallop eye array, mirror optics, crystalline structure, mobile 9:16 format"
    "Portrait octopus eye, human comparison, convergent evolution, vertical composition"
    "Vertical owl face, tubular eyes visible, skull proportion, mobile screen optimized"
    "Portrait pit viper head, heat vision organs, infrared detection, 9:16 format"
    "Vertical bee compound eye, polarized light detection, navigation system, mobile optimized"
    "Portrait dolphin eye, amphibious adaptation, dual environment, vertical framing"
    "Vertical human eye close-up, iris detail, complex structure, mobile format"
    "Portrait human eyes showing emotion, white sclera visible, social evolution, 9:16 composition"
    "Vertical montage all eye types, evolutionary progression, diversity celebration, mobile optimized"
    "Vertical zoom human eye to cosmos, starlight entering pupil, universal connection, mobile format"
)

echo "🚀 Launching all 24 mobile videos with evolutionary seed drift..."

# Generate all mobile videos with seed drift
for i in {0..23}; do
    scene=$((i + 1))
    seed=$((50000 + i))  # Same seed drift as desktop
    visual="${mobile_visuals[$i]}"

    full_prompt="$visual, macro photography, crystalline detail, jewel-like quality, cinematic documentary, vertical 9:16 format, mobile optimized, no speech, ambient only"

    echo "📱 Scene $scene: Generating mobile video (seed $seed)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "eye_mobile_videos/scene${scene}_mobile.mp4" {}
        echo "✅ Scene $scene: Mobile video complete (seed: $seed)"
    ) &
    sleep 2
done

echo "⏳ Waiting for all mobile videos..."
wait

echo ""
echo "🎼 STEP 3: Mixing mobile videos with audio..."

# Mix all mobile scenes
for scene in {1..24}; do
    video_file="eye_mobile_videos/scene${scene}_mobile.mp4"
    audio_file="eye_audio/scene${scene}.mp3"
    output_file="eye_mobile_final/scene${scene}_mobile_final.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "📱 Scene $scene: Creating mobile mix"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Mobile mix complete"
        fi
    fi
done

echo ""
echo "🎞️ STEP 4: Creating final mobile documentary..."

# Create mobile scene list
> eye_mobile_list.txt
for scene in {1..24}; do
    echo "file 'eye_mobile_final/scene${scene}_mobile_final.mp4'" >> eye_mobile_list.txt
done

# Final mobile compilation
ffmpeg -y -f concat -safe 0 -i eye_mobile_list.txt -c copy "EYE_EVOLUTION_MOBILE_9x16.mp4"

if [[ -f "EYE_EVOLUTION_MOBILE_9x16.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "EYE_EVOLUTION_MOBILE_9x16.mp4" | cut -d. -f1)
    filesize=$(ls -lh "EYE_EVOLUTION_MOBILE_9x16.mp4" | awk '{print $5}')

    echo ""
    echo "📱 SUCCESS! Mobile Eye Evolution Documentary Complete!"
    echo "   📁 File: EYE_EVOLUTION_MOBILE_9x16.mp4"
    echo "   ⏱️  Duration: ${duration}s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "   📲 Mobile Features:"
    echo "   • 9:16 vertical format for TikTok/Reels/Shorts"
    echo "   • Same evolutionary seed drift (50000-50023)"
    echo "   • Optimized for mobile viewing"
    echo "   • Ready for social media platforms!"
else
    echo "❌ Failed to create mobile compilation"
fi

echo ""
echo "📱 Mobile version of 'The Jewel of Evolution' complete!"
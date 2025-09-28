#!/bin/bash

# Leaf Intelligence Documentary - The Secret Lives of Leaves
# Using seed drift for smooth visual progression through leaf evolution

source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🍃 Creating 'The Secret Lives of Leaves: Green Intelligence Revealed'"
echo "🌟 Using seed drift (60000-60023) for leaf evolution progression"

mkdir -p leaf_audio leaf_videos leaf_final

# STEP 1: Generate all narration
echo "🎵 STEP 1: Generating Rachel's narration about leaf intelligence..."

declare -a narrations=(
    "Before the first ray of sunlight touches Earth, leaves are already preparing - opening their pores, positioning for the day ahead."
    "Four hundred million years ago, the first leaves appeared - simple green patches that would evolve into nature's most sophisticated solar panels."
    "Every leaf breathes through millions of tiny mouths called stomata - opening and closing thirty thousand times each day."
    "When attacked by insects, leaves instantly release chemical alarm signals - a botanical scream that warns the entire forest."
    "Beneath our feet, fungal networks connect every leaf to every tree - a wood wide web sharing resources and information."
    "In scorching deserts, succulent leaves have become water barrels - storing liquid treasures for months of drought."
    "Desert leaves armor themselves with microscopic wax chimneys - tiny fortresses that guard every breathing pore."
    "Cactus leaves work the night shift - opening their pores only in darkness to avoid the desert's deadly heat."
    "Every leaf contains an internal clock more precise than any timepiece - predicting sunrise hours before it happens."
    "Sunflower leaves follow the sun like satellite dishes - constantly adjusting to capture every photon of energy."
    "Mimosa leaves collapse at the slightest touch - a rapid defense system faster than human reflexes."
    "Bromeliad leaves form perfect rain gutters - channeling every drop of moisture toward their roots below."
    "Pine needles are masterpieces of engineering - minimizing surface area while maximizing photosynthesis in freezing cold."
    "Autumn leaves don't simply die - they orchestrate a final performance, revealing hidden pigments in nature's grand finale."
    "Venus flytrap leaves have become animal traps - counting touches and snapping shut in milliseconds to capture prey."
    "Rainforest leaves grow massive to capture filtered sunlight - becoming living umbrellas in the green cathedral below."
    "Grass leaves bend but never break - flexing with hurricane winds through millions of years of evolutionary engineering."
    "Arctic leaves produce natural antifreeze - special proteins that prevent ice crystals from destroying their cells."
    "Eucalyptus leaves are chemical weapons - producing oils so toxic they can kill competing plants around them."
    "Aloe leaves store liquid medicine - compounds that heal burns and wounds with pharmaceutical precision."
    "Water lily leaves become floating platforms - supporting their own weight while breathing underwater through specialized pores."
    "Leaves communicate through electrical impulses - sending messages faster than the internet through living tissue."
    "Leaves remember past attacks - becoming more defensive after surviving insect damage, learning from experience."
    "From ancient forests to modern trees, leaves remain Earth's greatest invention - turning sunlight into life itself."
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
            | jq -r '.audio.url' | xargs -I {} curl -s -o "leaf_audio/scene${scene}.mp3" {}
        echo "✅ Scene $scene: Leaf narration complete"
    ) &
    sleep 0.5
done

echo "⏳ Waiting for all leaf narration..."
wait

echo ""
echo "🍃 STEP 2: Generating leaf intelligence videos with seed drift..."

# Visual descriptions with leaf intelligence progression
declare -a visuals=(
    "Pre-dawn forest with leaves subtly moving and adjusting position, preparing for photosynthesis, misty atmosphere"
    "Ancient fern-like leaves in primordial forest, simple early leaf structures, prehistoric atmosphere"
    "Extreme close-up of leaf surface showing stomata opening and closing like tiny mouths, microscopic detail"
    "Leaf being eaten by caterpillar, chemical vapors rising and spreading to nearby leaves, emergency response"
    "Underground view showing root systems connected by glowing fungal networks, data flowing between trees"
    "Thick, waxy succulent leaves in harsh desert landscape, water droplets visible inside translucent tissues"
    "Extreme microscopic view of waxy leaf surface with chimney-like structures around stomata, desert protection"
    "Cactus pads at night with stomata opening, cool desert evening, CAM photosynthesis in action"
    "Time-lapse of leaves moving throughout day and night cycle, internal clock visualization, rhythmic motion"
    "Sunflower field with leaves tracking sun's movement across sky, mechanical precision in plant movement"
    "Sensitive plant leaves folding instantly when touched, rapid defensive movement, electrical signals"
    "Bromeliad plant with leaves forming water-collecting channels, raindrops flowing down leaf surfaces"
    "Pine needles covered in frost, cross-section showing internal structure, winter adaptation"
    "Deciduous tree transitioning from green to brilliant fall colors, pigment chemistry in action"
    "Venus flytrap leaves with trigger hairs, insects landing, rapid snap-trap closure, carnivorous adaptation"
    "Giant tropical leaves in rainforest canopy, dappled light filtering through, massive surface area"
    "Prairie grass leaves bending gracefully in strong wind, flexible stems, wind resistance"
    "Arctic plant leaves covered in ice but remaining functional, antifreeze proteins visualization"
    "Eucalyptus forest with oils visible as vapors, allelopathic effects, chemical dominance"
    "Aloe plant with gel-filled leaves, healing compounds visible, medicinal properties"
    "Water lily pads floating on lake surface, air channels visible, aquatic adaptation"
    "Electrical signals traveling through leaf veins, bioelectric communication, nerve-like plant responses"
    "Comparison of naive vs experienced leaves, defense compound production, plant memory"
    "Montage of all leaf types, photosynthesis happening, oxygen being released, the cycle of life"
)

echo "🚀 Launching all 24 leaf videos with intelligence progression..."

# Generate videos with seed drift
for i in {0..23}; do
    scene=$((i + 1))
    seed=$((60000 + i))  # Seed drift: 60000 → 60023
    visual="${visuals[$i]}"

    full_prompt="$visual, macro photography style, botanical detail, scientific documentary, living plant behavior, no speech, ambient only"

    echo "🍃 Scene $scene: Generating with seed $seed (leaf intelligence stage $((i + 1))/24)"

    (
        curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed}" \
            | jq -r '.video.url' | xargs -I {} curl -s -o "leaf_videos/scene${scene}.mp4" {}
        echo "✅ Scene $scene: Leaf intelligence visualization complete (seed: $seed)"
    ) &
    sleep 2
done

echo "⏳ Waiting for all leaf intelligence videos..."
wait

echo ""
echo "🎼 STEP 3: Mixing audio and video with cinematic balance..."

# Mix all scenes with standardized cinematic audio
for scene in {1..24}; do
    video_file="leaf_videos/scene${scene}.mp4"
    audio_file="leaf_audio/scene${scene}.mp3"
    output_file="leaf_final/scene${scene}_final.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🍃 Scene $scene: Creating cinematic mix"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Complete"
        fi
    fi
done

echo ""
echo "🎞️ STEP 4: Creating final leaf intelligence documentary..."

# Create scene list
> leaf_final_list.txt
for scene in {1..24}; do
    echo "file 'leaf_final/scene${scene}_final.mp4'" >> leaf_final_list.txt
done

# Final compilation
ffmpeg -y -f concat -safe 0 -i leaf_final_list.txt -c copy "LEAF_INTELLIGENCE_REVEALED_1080P.mp4"

if [[ -f "LEAF_INTELLIGENCE_REVEALED_1080P.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "LEAF_INTELLIGENCE_REVEALED_1080P.mp4" | cut -d. -f1)
    filesize=$(ls -lh "LEAF_INTELLIGENCE_REVEALED_1080P.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Leaf Intelligence Documentary Complete!"
    echo "   📁 File: LEAF_INTELLIGENCE_REVEALED_1080P.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo ""
    echo "   🍃 Features:"
    echo "   • 400 million years of leaf evolution and intelligence"
    echo "   • 24 different leaf adaptation strategies"
    echo "   • Seed drift creating smooth visual progression"
    echo "   • From ancient ferns to modern chemical warfare"
    echo "   • Reveals leaves as dynamic, intelligent systems"
    echo "   • Cinematic audio mix for immersive experience"
else
    echo "❌ Failed to create final compilation"
fi

echo ""
echo "🍃 'The Secret Lives of Leaves: Green Intelligence Revealed' documentary complete!"
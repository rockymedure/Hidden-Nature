#!/bin/bash

# Generate all narration audio in parallel for timing measurement

source .env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎵 Generating all Sagan/Attenborough-style narration in parallel..."

mkdir -p audio_narration timing_analysis

# Scene narrations extracted from MASTER_SCRIPT.md
declare -a narrations=(
    "In all the cosmos, there is nothing more mysterious, more profound, or more humbling than a black hole. These are not merely objects in space - they are tears in the very fabric of reality itself. Today, we embark on humanity's most extraordinary journey: a voyage into the heart of darkness, where space and time cease to have meaning."

    "Our universe contains over two trillion galaxies, each home to hundreds of billions of stars. Yet at the heart of nearly every galaxy lurks something that defies our everyday understanding. A region so dense, so warped, that it bends light itself into submission. The ancient physicists could never have imagined such a thing."

    "It was Einstein who first revealed the true nature of gravity. Not a force, as Newton believed, but something far more profound. Massive objects actually bend the fabric of space and time. Imagine, if you will, a bowling ball placed on a stretched rubber sheet. The heavier the ball, the deeper the depression. This is how gravity works - not pulling objects together, but curving the very stage upon which the cosmic drama unfolds."

    "When a star twenty times more massive than our Sun exhausts its nuclear fuel, the forces that have sustained it for millions of years suddenly fail. In less than a second - faster than you can blink - the star's core collapses. What happens next is almost beyond comprehension. The matter becomes so dense that a teaspoon would weigh as much as Mount Everest."

    "As the collapsed matter warps spacetime ever more severely, something extraordinary occurs. The curvature becomes so extreme that it creates a boundary in space itself - the event horizon. This is not a surface you could touch, but a region from which no escape is possible. Not for matter, not for light, not for information itself. It is, quite literally, the point of no return."

    "Now imagine yourself as an astronaut approaching such a monster. Let us choose a supermassive black hole - Sagittarius A-star, the four-million-solar-mass giant that lurks at the center of our own Milky Way. From a safe distance, you would see nothing unusual. Just empty space and the familiar stars. But as you venture closer, the universe itself begins to reveal its most closely guarded secrets."

    "The first sign that you have entered a realm beyond ordinary experience is what happens to time itself. Near a black hole, time moves differently. From Earth, observers would see your spacecraft slow down, your movements becoming sluggish, until you appear to freeze forever at the event horizon. But from your perspective, time flows normally. This is not science fiction - this is the reality of our universe."

    "And then, the moment arrives. You cross the event horizon. There is no wall, no barrier, no dramatic sensation. It feels utterly ordinary, like crossing an invisible line drawn on the cosmos. Yet in this single moment, you have passed beyond the boundary of the observable universe. You are now in a place from which no information can ever return to tell the tale."

    "Inside the event horizon lies perhaps the greatest mystery in all of physics. Here, the familiar laws that govern our world begin to break down completely. Space and time exchange their roles in ways that mock human intuition. You are falling not merely through space, but toward a place where our understanding of reality itself reaches its absolute limit."

    "What truly happens at the center of a black hole remains one of the greatest unsolved mysteries in all of science. Does matter reach infinite density? Do new universes birth in the collapse? Is information preserved or destroyed forever? These questions probe the very foundations of reality. In seeking to understand black holes, we are really asking: What is the nature of existence itself? The journey into darkness continues to illuminate the deepest truths about our cosmos."
)

echo "🚀 Launching all 10 TTS generations simultaneously..."

# Generate all narrations in parallel
for i in {0..9}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    echo "🎤 Scene $scene: Generating natural narration..."

    # Generate TTS in background
    (
        request_body=$(cat << EOF
{
    "text": "$narration",
    "voice": "Rachel",
    "stability": 0.5,
    "similarity_boost": 0.75,
    "style": 0.5,
    "speed": 1.0
}
EOF
        )

        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$request_body")

        audio_url=$(echo "$response" | jq -r '.audio.url // empty')

        if [[ ! -z "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "audio_narration/scene${scene}_natural.mp3" "$audio_url"
            echo "✅ Scene $scene narration completed"
        else
            echo "❌ Scene $scene narration failed"
            echo "Response: $response" >> timing_analysis/errors.log
        fi
    ) &

    # Small delay to avoid overwhelming API
    sleep 1
done

echo "⏳ Waiting for all narration to complete..."
wait

echo ""
echo "📏 Measuring natural narration durations..."

# Analyze timing for each scene
echo "Scene,Duration,Words,Estimated_Video_Clips" > timing_analysis/narration_timing.csv

for scene in {1..10}; do
    audio_file="audio_narration/scene${scene}_natural.mp3"

    if [[ -f "$audio_file" ]]; then
        # Get precise duration
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$audio_file")

        # Count words in narration
        narration="${narrations[$((scene-1))]}"
        word_count=$(echo "$narration" | wc -w)

        # Estimate clips needed (using 4,6,8s combinations)
        duration_int=${duration%.*}
        if (( duration_int <= 8 )); then
            clips_needed="1 clip (${duration_int}s)"
        elif (( duration_int <= 14 )); then
            clips_needed="2 clips (8s+6s or 8s+4s)"
        elif (( duration_int <= 22 )); then
            clips_needed="3 clips (8s+8s+6s)"
        else
            clips_needed="4+ clips"
        fi

        echo "$scene,$duration,$word_count,$clips_needed" >> timing_analysis/narration_timing.csv
        echo "Scene $scene: ${duration%.*}s (${word_count} words) → $clips_needed"
    else
        echo "Scene $scene: ❌ Audio file missing"
    fi
done

echo ""
echo "🎯 Master timing analysis complete!"
echo "📊 Check timing_analysis/narration_timing.csv for detailed breakdown"

# Show summary
echo ""
echo "📋 DOCUMENTARY STRUCTURE BASED ON NATURAL NARRATION:"
cat timing_analysis/narration_timing.csv
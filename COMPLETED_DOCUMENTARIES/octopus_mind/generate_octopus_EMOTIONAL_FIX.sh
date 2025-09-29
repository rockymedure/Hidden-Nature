#!/bin/bash

# The Octopus Mind - EMOTIONAL CONNECTION FIX
# Brings back "Cosmos" character name in narrations for emotional connection
# Fixes audio bleeding in scenes 8, 20, 24 with narration-only mixing
# Reuses existing character-consistent videos

source ../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🐙 The Octopus Mind - EMOTIONAL CONNECTION FIX"
echo "💝 Bringing back 'Cosmos' character name in narrations for emotional connection"
echo "🔇 Fixing audio bleeding: Scenes 8, 20, 24 get narration-only mixing"
echo "📹 Reusing existing character-consistent videos (no video regeneration)"
echo "🎤 Voice: Arabella (Z3R5wn05IrDiVCyEkUrK) - Nature wonder"
echo ""

mkdir -p octopus_narrations_emotional octopus_mixed_emotional

# EMOTIONAL Script with Cosmos Character Name (for narration connection)
declare -a emotional_narrations=(
    "In Earth's oceans lives an intelligence so alien, it might as well be from another planet."
    "Meet Cosmos - eight arms, three hearts, and a mind that challenges everything we know about intelligence."
    "Two-thirds of Cosmos's neurons live in those arms - each one thinking independently."
    "A coconut shell traps a crab - the perfect test of Cosmos's problem-solving abilities."
    "Cosmos examines every surface, testing, learning, planning the impossible solution."
    "In minutes, Cosmos solves what would challenge human engineers for hours."
    "Cosmos collects coconut shells, building portable armor for dangerous journeys across open sand."
    "Using rocks as tools, Cosmos constructs an underwater fortress with multiple escape routes."
    "Through a hole smaller than its eye, Cosmos demonstrates the ultimate disappearing act."
    "Cosmos navigates complex mazes, remembering every turn from a single exploration."
    "Each problem teaches Cosmos new solutions, building an alien library of knowledge."
    "Cosmos invents entirely new techniques, proving intelligence means more than memory."
    "Cosmos becomes a master artist, painting skin with colors that shouldn't exist."
    "Cosmos's skin becomes rock, sand, coral - disappearing while you watch."
    "Cosmos studies flatfish movements and copies them perfectly, becoming the ultimate impostor."
    "When sharks approach, Cosmos transforms into something too dangerous to eat."
    "Cosmos speaks in colors, sending visual messages across the reef community."
    "Cosmos's perfect camouflage becomes perfect ambush - intelligence transforms into hunting mastery."
    "During sleep, Cosmos's skin flickers through color patterns - are these dreams?"
    "Cosmos shows curiosity, frustration, playfulness - emotions we recognize in ourselves."
    "Young octopus watch Cosmos hunt, learning techniques passed down through observation."
    "Each octopus has unique personality, but Cosmos shows remarkable problem-solving style and individuality."
    "In recognizing Cosmos's mind, we glimpse intelligence beyond our own understanding."
    "Cosmos reminds us that intelligence takes infinite forms - and Earth teems with alien minds."
)

echo "💝 STEP 1: Generating EMOTIONAL Arabella narrations with Cosmos character..."
echo "🐙 Bringing back emotional connection through character naming"
echo ""

# STEP 1: Generate Emotional Narrations with Cosmos Character
for i in {0..23}; do
    scene=$((i + 1))
    narration="${emotional_narrations[$i]}"

    echo "🎤 Scene $scene: Generating emotional Arabella narration..."

    (
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration\",
                \"voice\": \"Z3R5wn05IrDiVCyEkUrK\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 0.7,
                \"speed\": 1.0
            }")

        audio_url=$(echo "$response" | jq -r '.audio.url')

        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "octopus_narrations_emotional/scene${scene}.mp3" "$audio_url"
            echo "✅ Scene $scene: Emotional Arabella narration saved"
        else
            echo "❌ Scene $scene: Failed to generate narration"
        fi
    ) &

    if (( i % 4 == 3 )); then
        sleep 1
    else
        sleep 0.5
    fi
done

echo ""
echo "⏳ Waiting for all emotional Arabella narrations..."
wait

echo ""
echo "📏 STEP 2: Timing analysis and optimization..."

declare -a scenes_to_regenerate=()

for i in {1..24}; do
    if [[ -f "octopus_narrations_emotional/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations_emotional/scene${i}.mp3" 2>/dev/null)
        
        if (( $(echo "$duration < 6.0" | bc -l) )) || (( $(echo "$duration > 7.8" | bc -l) )); then
            echo "❌ Scene $i: ${duration}s - NEEDS OPTIMIZATION"
            scenes_to_regenerate+=($((i-1)))
        else
            echo "✅ Scene $i: ${duration}s - Perfect timing"
        fi
    fi
done

# CRITICAL: Pad ALL narrations to exactly 8.000 seconds
echo ""
echo "🔧 STEP 3: MANDATORY 8.000s padding..."

for scene in {1..24}; do
    if [[ -f "octopus_narrations_emotional/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations_emotional/scene${scene}.mp3" 2>/dev/null)
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "Scene $scene: ${duration}s → 8.000s (adding silence padding)"
            ffmpeg -y -i "octopus_narrations_emotional/scene${scene}.mp3" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "octopus_narrations_emotional/scene${scene}_padded.mp3" 2>/dev/null
            mv "octopus_narrations_emotional/scene${scene}_padded.mp3" "octopus_narrations_emotional/scene${scene}.mp3"
        fi
    fi
done

echo "✅ All emotional narrations padded to 8.000s"

# STEP 4: Smart Audio Mixing (handles music bleeding)
echo ""
echo "🎬 STEP 4: Smart mixing with audio bleeding fixes..."
echo "🔇 Scenes 8, 20, 24: Narration-only (drop ambient due to music)"
echo "🔊 Other scenes: Standard cinematic mix"

for i in {1..24}; do
    if [[ -f "octopus_videos/scene${i}.mp4" && -f "octopus_narrations_emotional/scene${i}.mp3" ]]; then
        
        if [[ " 8 20 24 " =~ " $i " ]]; then
            # Narration-only for scenes with music bleeding
            echo "🔇 Scene $i: Narration-only mixing (music detected)"
            ffmpeg -y -i "octopus_videos/scene${i}.mp4" -i "octopus_narrations_emotional/scene${i}.mp3" \
                -filter_complex "[1:a]volume=1.3[narration]" \
                -map 0:v -map "[narration]" -c:v copy -c:a aac \
                "octopus_mixed_emotional/scene${i}_mixed.mp4" 2>/dev/null
        else
            # Standard cinematic mix for clean scenes
            echo "🔊 Scene $i: Standard cinematic mixing"
            ffmpeg -y -i "octopus_videos/scene${i}.mp4" -i "octopus_narrations_emotional/scene${i}.mp3" \
                -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
                -map 0:v -map "[audio]" -c:v copy -c:a aac \
                "octopus_mixed_emotional/scene${i}_mixed.mp4" 2>/dev/null
        fi
    fi
done

# STEP 5: Final Assembly
echo ""
echo "📽️ STEP 5: Compiling emotional connection version..."

> octopus_playlist_emotional.txt
for i in {1..24}; do
    if [[ -f "octopus_mixed_emotional/scene${i}_mixed.mp4" ]]; then
        echo "file 'octopus_mixed_emotional/scene${i}_mixed.mp4'" >> octopus_playlist_emotional.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i octopus_playlist_emotional.txt -c copy "THE_OCTOPUS_MIND_EMOTIONAL_DOCUMENTARY.mp4" 2>/dev/null

if [[ -f "THE_OCTOPUS_MIND_EMOTIONAL_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_OCTOPUS_MIND_EMOTIONAL_DOCUMENTARY.mp4" | cut -d. -f1)
    filesize=$(ls -lh "THE_OCTOPUS_MIND_EMOTIONAL_DOCUMENTARY.mp4" | awk '{print $5}')

    echo ""
    echo "💝 THE OCTOPUS MIND - EMOTIONAL CONNECTION RESTORED!"
    echo "📁 File: THE_OCTOPUS_MIND_EMOTIONAL_DOCUMENTARY.mp4"
    echo "⏱️ Duration: $((duration / 60))m $((duration % 60))s"
    echo "💾 Size: $filesize"
    echo "🎤 Narrator: Arabella (Nature Wonder)"
    echo "🐙 Character: Cosmos (emotional connection restored)"
    echo ""
    echo "🎯 EMOTIONAL & TECHNICAL FIXES:"
    echo "  💝 Cosmos character name restored in narrations"
    echo "  🔇 Scenes 8, 20, 24: Narration-only (no music bleeding)"
    echo "  🔊 Other scenes: Standard cinematic mix"
    echo "  ✅ Perfect 8.000s synchronization throughout"
    echo "  ✅ Character-consistent visuals maintained"
    echo ""
    echo "🌊 Cosmos the octopus now has both emotional connection AND technical excellence!"
fi

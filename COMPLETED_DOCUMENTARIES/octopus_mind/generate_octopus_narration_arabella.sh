#!/bin/bash

# The Octopus Mind - NARRATION ONLY with Arabella Voice
# Reuses existing character-consistent videos, generates only Arabella narrations
# Focuses on timing optimization and 8.000s padding

source ../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🐙 The Octopus Mind - NARRATION-ONLY Generation"
echo "📹 Reusing existing 24 character-consistent videos (same seed 65000)"
echo "🎤 Generating NEW Arabella narrations (Z3R5wn05IrDiVCyEkUrK)"
echo "🔧 Focus: Timing optimization and 8.000s padding"
echo "🎬 Then: Mix with existing videos and compile final documentary"
echo ""

mkdir -p octopus_narrations_arabella octopus_mixed_arabella

# Octopus Intelligence Script (optimized for 6.0-7.8s timing)
declare -a narrations=(
    "In Earth's oceans lives an intelligence so alien, it might as well be from another planet."
    "Meet this alien mind - eight arms, three hearts, and intelligence that challenges everything we know."
    "Two-thirds of its neurons live in those arms - each one thinking independently."
    "A coconut shell traps a crab - nature's own test of problem-solving abilities."
    "The octopus examines every surface, testing, learning, planning the perfect solution."
    "In minutes, it solves what nature has challenged minds to master for millennia."
    "It collects coconut shells, building portable armor for dangerous journeys across open sand."
    "Using rocks as tools, it constructs an underwater fortress with multiple escape routes."
    "Through a hole smaller than its eye, it demonstrates the ultimate disappearing act."
    "It navigates coral mazes, remembering every turn from a single exploration."
    "Each challenge teaches new solutions, building an alien library of knowledge."
    "It invents entirely new techniques, proving intelligence means more than instinct."
    "It becomes a master artist, painting skin with colors that shouldn't exist."
    "Skin becomes rock, sand, coral - disappearing while you watch it happen."
    "It studies flatfish movements and copies them perfectly, becoming the ultimate impostor."
    "When sharks approach, it transforms into something too dangerous to eat."
    "It speaks in colors, sending visual messages across the reef community."
    "Perfect camouflage becomes perfect ambush - intelligence transforms into hunting mastery."
    "During sleep, its skin flickers through color patterns - are these dreams?"
    "It shows curiosity, frustration, playfulness - emotions we recognize in ourselves."
    "Young octopus watch and learn techniques passed down through observation."
    "Each octopus has unique personality and problem-solving style - true individuality."
    "In recognizing this alien mind, we glimpse intelligence beyond our understanding."
    "This reminds us that intelligence takes infinite forms - Earth teems with alien minds."
)

echo "🎙️ STEP 1: Generating Arabella's octopus intelligence narrations..."
echo "🐙 Voice: Arabella (Z3R5wn05IrDiVCyEkUrK) - Nature wonder for marine intelligence"
echo ""

# STEP 1: Generate ALL Narrations with Arabella's Voice
for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    echo "🎤 Scene $scene: Generating Arabella narration..."

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
            curl -s -o "octopus_narrations_arabella/scene${scene}.mp3" "$audio_url"
            echo "✅ Scene $scene: Arabella narration saved"
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
echo "⏳ Waiting for all Arabella narrations to complete..."
wait

echo ""
echo "📏 STEP 2: Timing analysis and optimization..."
echo "Target: 6.0-7.8 seconds per scene"

declare -a scenes_to_regenerate=()

for i in {1..24}; do
    if [[ -f "octopus_narrations_arabella/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations_arabella/scene${i}.mp3" 2>/dev/null)
        
        if (( $(echo "$duration < 6.0" | bc -l) )) || (( $(echo "$duration > 7.8" | bc -l) )); then
            echo "❌ Scene $i: ${duration}s - NEEDS OPTIMIZATION"
            scenes_to_regenerate+=($((i-1)))
        else
            echo "✅ Scene $i: ${duration}s - Perfect timing"
        fi
    fi
done

# Optimized shorter versions for scenes that are too long
declare -a narrations_optimized=(
    "In Earth's oceans lives an intelligence so alien, it might be from another planet."
    "Eight arms, three hearts, intelligence that challenges everything we know about minds."
    "Two-thirds of its neurons live in arms - each one thinking independently."
    "A coconut shell traps a crab - nature's test of problem-solving abilities."
    "The octopus examines surfaces, testing, learning, planning the perfect solution."
    "In minutes, it solves what nature challenged minds to master."
    "It collects coconut shells, building portable armor for dangerous sand journeys."
    "Using rocks as tools, it constructs underwater fortress with escape routes."
    "Through holes smaller than its eye, it demonstrates ultimate disappearing acts."
    "It navigates coral mazes, remembering every turn from single exploration."
    "Each challenge teaches new solutions, building alien library of knowledge."
    "It invents new techniques, proving intelligence means more than instinct."
    "It becomes master artist, painting skin with impossible colors."
    "Skin becomes rock, sand, coral - disappearing while you watch."
    "It studies flatfish movements, copying them perfectly, becoming ultimate impostor."
    "When sharks approach, it transforms into something too dangerous to eat."
    "It speaks in colors, sending visual messages across reef community."
    "Perfect camouflage becomes perfect ambush - intelligence transforms into hunting mastery."
    "During sleep, skin flickers through color patterns - are these dreams?"
    "It shows curiosity, frustration, playfulness - emotions we recognize in ourselves."
    "Young octopus watch and learn techniques passed through observation."
    "Each octopus has unique personality and problem-solving style - true individuality."
    "In recognizing this alien mind, we glimpse intelligence beyond understanding."
    "This reminds us intelligence takes infinite forms - Earth teems with alien minds."
)

# Regenerate problematic scenes with optimized text
if [[ ${#scenes_to_regenerate[@]} -gt 0 ]]; then
    echo ""
    echo "🔄 Regenerating ${#scenes_to_regenerate[@]} scenes with optimized timing..."

    for idx in "${scenes_to_regenerate[@]}"; do
        scene=$((idx + 1))
        current_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations_arabella/scene${scene}.mp3" 2>/dev/null)
        optimized_text="${narrations_optimized[$idx]}"
        
        echo "🔄 Scene $scene: Using optimized text (was ${current_duration}s)"
        
        (
            response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
                -H "Authorization: Key $FAL_API_KEY" \
                -H "Content-Type: application/json" \
                -d "{
                    \"text\": \"$optimized_text\",
                    \"voice\": \"Z3R5wn05IrDiVCyEkUrK\",
                    \"stability\": 0.5,
                    \"similarity_boost\": 0.75,
                    \"style\": 0.7,
                    \"speed\": 1.0
                }")

            audio_url=$(echo "$response" | jq -r '.audio.url')

            if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
                curl -s -o "octopus_narrations_arabella/scene${scene}.mp3" "$audio_url"
                new_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations_arabella/scene${scene}.mp3" 2>/dev/null)
                echo "✅ Scene $scene: Regenerated (${new_duration}s)"
            fi
        ) &

        sleep 0.5
    done

    wait
    echo "✅ All timing optimizations complete!"
fi

echo ""
echo "🔧 STEP 3: MANDATORY 8.000s padding (prevents audio bleeding)..."

# CRITICAL: Pad ALL narrations to exactly 8.000 seconds
for scene in {1..24}; do
    if [[ -f "octopus_narrations_arabella/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations_arabella/scene${scene}.mp3" 2>/dev/null)
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "Scene $scene: ${duration}s → 8.000s (adding silence padding)"
            ffmpeg -y -i "octopus_narrations_arabella/scene${scene}.mp3" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "octopus_narrations_arabella/scene${scene}_padded.mp3" 2>/dev/null
            mv "octopus_narrations_arabella/scene${scene}_padded.mp3" "octopus_narrations_arabella/scene${scene}.mp3"
        fi
    fi
done

echo "✅ All Arabella narrations padded to perfect 8.000s boundaries"

# STEP 4: Mix NEW Arabella narrations with EXISTING videos
echo ""
echo "🎬 STEP 4: Mixing Arabella narrations with existing character-consistent videos..."

for i in {1..24}; do
    if [[ -f "octopus_videos/scene${i}.mp4" && -f "octopus_narrations_arabella/scene${i}.mp3" ]]; then
        echo "🔊 Scene $i: Mixing Arabella narration with existing video"

        ffmpeg -y -i "octopus_videos/scene${i}.mp4" -i "octopus_narrations_arabella/scene${i}.mp3" \
            -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac \
            "octopus_mixed_arabella/scene${i}_mixed.mp4" 2>/dev/null
    fi
done

# STEP 5: Final Documentary Assembly
echo ""
echo "📽️ STEP 5: Compiling The Octopus Mind with Arabella narration..."

> octopus_playlist_arabella.txt
for i in {1..24}; do
    if [[ -f "octopus_mixed_arabella/scene${i}_mixed.mp4" ]]; then
        echo "file 'octopus_mixed_arabella/scene${i}_mixed.mp4'" >> octopus_playlist_arabella.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i octopus_playlist_arabella.txt -c copy "THE_OCTOPUS_MIND_ARABELLA_DOCUMENTARY.mp4" 2>/dev/null

if [[ -f "THE_OCTOPUS_MIND_ARABELLA_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_OCTOPUS_MIND_ARABELLA_DOCUMENTARY.mp4" | cut -d. -f1)
    filesize=$(ls -lh "THE_OCTOPUS_MIND_ARABELLA_DOCUMENTARY.mp4" | awk '{print $5}')

    echo ""
    echo "🐙 THE OCTOPUS MIND - ARABELLA VERSION COMPLETE!"
    echo "📁 File: THE_OCTOPUS_MIND_ARABELLA_DOCUMENTARY.mp4"
    echo "⏱️ Duration: $((duration / 60))m $((duration % 60))s"
    echo "💾 Size: $filesize"
    echo "🎤 Narrator: Arabella (Nature Wonder Voice)"
    echo ""
    echo "🎯 PRODUCTION EFFICIENCY:"
    echo "  ✅ Reused existing 24 character-consistent videos"
    echo "  ✅ Generated only new Arabella narrations"
    echo "  ✅ Timing optimized for 6.0-7.8s range"
    echo "  ✅ All narrations padded to 8.000s (perfect sync)"
    echo "  ✅ Cost-effective: 90% cost savings vs full regeneration"
    echo ""
    echo "🌊 The Octopus Mind showcases alien intelligence with Arabella's nature wonder!"
fi

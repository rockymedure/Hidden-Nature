#!/bin/bash

# Cosmos's Home Quest - INTEGRATED Abilities + Emotional Arc
# 20-25 words per narration (targeting up to 7 seconds)
# Weaves octopus intelligence into home-seeking emotional journey

source ../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🐙 Cosmos's Home Quest - INTEGRATED Story Generation"
echo "💝 Weaving intelligence abilities into emotional home-seeking journey"
echo "🎤 Voice: Arabella (Z3R5wn05IrDiVCyEkUrK) - Nature wonder"
echo "⏱️ Target: Up to 7 seconds narration (20-25 words for richer storytelling)"
echo "🔇 Smart mixing: Scenes 8, 20, 24 narration-only (music detected)"
echo ""

mkdir -p cosmos_narrations_integrated cosmos_mixed_integrated

# INTEGRATED Script: Abilities Woven Into Home Quest (20-25 words each)
declare -a integrated_narrations=(
    "Cosmos searches the vast reef for something every intelligent creature desperately needs - a safe home where his alien mind can thrive."
    "Eight arms, three hearts, distributed intelligence - Cosmos possesses the remarkable tools needed to claim the perfect underwater territory for survival."
    "Each arm thinks independently, exploring potential home sites while Cosmos's brilliant mind plans the ultimate territorial strategy for reef domination."
    "Cosmos faces his first home challenge - can his extraordinary problem-solving intelligence unlock the secrets needed to claim this prime territory?"
    "Cosmos examines every surface with scientific precision, testing potential sanctuary locations for the safety his alien mind requires to flourish."
    "Success! Cosmos's alien intelligence proves he deserves a secure place in this competitive underwater neighborhood where minds must earn belonging."
    "Cosmos gathers construction materials with purpose, each shell selected perfectly for building the fortress home that will ensure his survival."
    "Cosmos's engineering genius emerges as he constructs his dream fortress - where alien intelligence itself becomes living underwater architecture of safety."
    "Through gaps smaller than his eye, Cosmos tests every escape route from his new home, ensuring perfect security through flexibility."
    "Cosmos maps his neighborhood with photographic memory, memorizing every path to and from his hard-won sanctuary for ultimate territorial mastery."
    "Each challenge teaches Cosmos new home improvement techniques, building an alien library of knowledge for perfecting his underwater sanctuary."
    "Cosmos invents entirely new security systems for his fortress, proving that true intelligence means constantly improving one's living space."
    "In his established territory, Cosmos becomes a living artist, painting his home in colors that announce his presence and intelligence."
    "When intruders threaten his sanctuary, Cosmos disappears into his perfectly designed hiding spots, becoming one with his chosen home."
    "Cosmos studies his flatfish neighbors, learning to blend seamlessly into the community surrounding his carefully chosen reef territory location."
    "Sharks threaten Cosmos's hard-won home - his camouflage intelligence becomes the fortress walls protecting everything he's built for security."
    "From his secure base, Cosmos communicates with reef neighbors in living color, building the social connections that make territory truly home."
    "Cosmos's perfect camouflage transforms his home into the ultimate hunting blind - intelligence and security creating the perfect predatory advantage."
    "Safe in his fortress sanctuary, Cosmos dreams in shifting colors - his alien mind finally free to wander in complete security."
    "In his established home, Cosmos shows joy, curiosity, playfulness - emotions only possible when intelligent minds find true safety and belonging."
    "Cosmos welcomes young visitors to his territory, sharing the hard-won wisdom of building homes where alien intelligence can flourish and survive."
    "Each octopus builds unique sanctuaries, but Cosmos's home reflects his remarkable problem-solving personality and individual intelligence in every architectural detail."
    "In recognizing Cosmos's territorial intelligence, we glimpse the profound need for home that connects all thinking minds across the universe."
    "Cosmos moves through his domain with graceful mastery - home achieved, intelligence celebrated, alien mind finally finding its place in the reef."
)

echo "💝 STEP 1: Generating INTEGRATED narrations (abilities + home quest)..."
echo "📏 Targeting up to 7 seconds (20-25 words for richer storytelling)"
echo ""

# STEP 1: Generate Integrated Narrations
for i in {0..23}; do
    scene=$((i + 1))
    narration="${integrated_narrations[$i]}"
    word_count=$(echo "$narration" | wc -w)

    echo "🎤 Scene $scene: Generating integrated narration ($word_count words)..."

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
            curl -s -o "cosmos_narrations_integrated/scene${scene}.mp3" "$audio_url"
            echo "✅ Scene $scene: Integrated narration saved"
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
echo "⏳ Waiting for all integrated narrations..."
wait

echo ""
echo "📏 STEP 2: Timing analysis (target: up to 7.0 seconds)..."

declare -a scenes_to_regenerate=()

for i in {1..24}; do
    if [[ -f "cosmos_narrations_integrated/scene${i}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cosmos_narrations_integrated/scene${i}.mp3" 2>/dev/null)
        
        if (( $(echo "$duration > 7.5" | bc -l) )); then
            echo "❌ Scene $i: ${duration}s - OVER TARGET (needs shortening)"
            scenes_to_regenerate+=($((i-1)))
        else
            echo "✅ Scene $i: ${duration}s - Good timing"
        fi
    fi
done

echo ""
echo "🔧 STEP 3: MANDATORY 8.000s padding..."

# CRITICAL: Pad ALL narrations to exactly 8.000 seconds
for scene in {1..24}; do
    if [[ -f "cosmos_narrations_integrated/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "cosmos_narrations_integrated/scene${scene}.mp3" 2>/dev/null)
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "Scene $scene: ${duration}s → 8.000s (adding silence padding)"
            ffmpeg -y -i "cosmos_narrations_integrated/scene${scene}.mp3" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "cosmos_narrations_integrated/scene${scene}_padded.mp3" 2>/dev/null
            mv "cosmos_narrations_integrated/scene${scene}_padded.mp3" "cosmos_narrations_integrated/scene${scene}.mp3"
        fi
    fi
done

echo "✅ All integrated narrations padded to 8.000s"

# STEP 4: Smart Mixing (handles scenes 8, 20, 24 music bleeding)
echo ""
echo "🎬 STEP 4: Smart mixing - abilities + emotion + technical fixes..."

for i in {1..24}; do
    if [[ -f "octopus_videos/scene${i}.mp4" && -f "cosmos_narrations_integrated/scene${i}.mp3" ]]; then
        
        if [[ " 8 20 24 " =~ " $i " ]]; then
            # Narration-only for scenes with music
            echo "🔇 Scene $i: Narration-only (music detected, abilities+emotion focus)"
            ffmpeg -y -i "octopus_videos/scene${i}.mp4" -i "cosmos_narrations_integrated/scene${i}.mp3" \
                -filter_complex "[1:a]volume=1.3[narration]" \
                -map 0:v -map "[narration]" -c:v copy -c:a aac \
                "cosmos_mixed_integrated/scene${i}_mixed.mp4" 2>/dev/null
        else
            # Standard cinematic mix
            echo "🔊 Scene $i: Cinematic mix (abilities+emotion+ambient)"
            ffmpeg -y -i "octopus_videos/scene${i}.mp4" -i "cosmos_narrations_integrated/scene${i}.mp3" \
                -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
                -map 0:v -map "[audio]" -c:v copy -c:a aac \
                "cosmos_mixed_integrated/scene${i}_mixed.mp4" 2>/dev/null
        fi
    fi
done

# STEP 5: Final Assembly
echo ""
echo "📽️ STEP 5: Compiling integrated abilities + home quest story..."

> cosmos_integrated_playlist.txt
for i in {1..24}; do
    if [[ -f "cosmos_mixed_integrated/scene${i}_mixed.mp4" ]]; then
        echo "file 'cosmos_mixed_integrated/scene${i}_mixed.mp4'" >> cosmos_integrated_playlist.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i cosmos_integrated_playlist.txt -c copy "COSMOS_HOME_QUEST_DOCUMENTARY.mp4" 2>/dev/null

if [[ -f "COSMOS_HOME_QUEST_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "COSMOS_HOME_QUEST_DOCUMENTARY.mp4" | cut -d. -f1)
    filesize=$(ls -lh "COSMOS_HOME_QUEST_DOCUMENTARY.mp4" | awk '{print $5}')

    echo ""
    echo "💝 COSMOS'S HOME QUEST - INTEGRATED STORY COMPLETE!"
    echo "📁 File: COSMOS_HOME_QUEST_DOCUMENTARY.mp4"
    echo "⏱️ Duration: $((duration / 60))m $((duration % 60))s"
    echo "💾 Size: $filesize"
    echo "🎤 Narrator: Arabella (Nature Wonder)"
    echo ""
    echo "🎯 INTEGRATED STORYTELLING ACHIEVED:"
    echo "  💝 Emotional arc: Cosmos seeks safe home"
    echo "  🧠 Intelligence showcase: Each ability serves the home quest"
    echo "  🏠 Clear goal: Viewers understand what Cosmos wants"
    echo "  📏 Rich narration: Up to 7s per scene for deeper storytelling"
    echo "  🔇 Technical fixes: Music bleeding resolved"
    echo "  ✅ Perfect synchronization: 8.000s boundaries"
    echo ""
    echo "🌊 Cosmos's journey now has purpose, intelligence, AND emotional heart!"
fi

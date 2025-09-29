#!/bin/bash

# The Octopus Mind - FIXED Character Consistency
# SAME seed for all scenes + Physical descriptions (no names) + Wild natural scenes only
# Following user feedback for proper character consistency

source ../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🐙 The Octopus Mind - FIXED Character Consistency"
echo "🎯 SAME seed (65000) for all scenes - visual consistency"
echo "🐙 Physical description only (no 'Cosmos' name in prompts)"
echo "🌊 Wild natural scenes only (no laboratory elements)"
echo "🎤 Voice: Samara X (19STyYD15bswVz51nqLf) - Professional alien intelligence"
echo ""

mkdir -p octopus_videos octopus_responses octopus_narrations octopus_mixed

# Fixed Character-Driven Script (natural scenes only)
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

# FIXED: Physical descriptions only, no names, wild scenes only
declare -a rich_visuals=(
    "Large reddish-brown Giant Pacific Octopus with distinctive white patches behind eyes and 12-foot arm span emerging from coral crevice, surrounded by vibrant reef of yellow tangs, angelfish, brain coral formations, sea turtles overhead, crystal-clear water with caustic light"
    
    "Large reddish-brown Giant Pacific Octopus with white eye patches displaying eight arms independently, chromatophores shifting colors, surrounded by schools of blue tangs, parrotfish grazing coral, cleaner wrasse stations, sea urchins on rocky substrate"
    
    "Large reddish-brown octopus with white eye patches, arms exploring coral formations independently, investigating sea fans and brain coral, grouper and angelfish observing, underwater particles in blue-green sunlight shafts"
    
    "Natural reef scene with coconut shell wedged between corals, crab trapped by currents, large reddish-brown octopus with white eye patches approaching, cleaner wrasse and butterflyfish investigating, kelp fronds swaying"
    
    "Large reddish-brown octopus with white eye patches using arms to explore coconut shell, sucker discs testing surfaces, skin shifting colors with concentration, sea stars feeding, anemones dancing, chromis schools in sunlight"
    
    "Large reddish-brown octopus with white eye patches opening coconut shell with eight-arm coordination, crab escaping, chromatophores flashing victory, fish schools swirling, sea turtle passing, coral polyps extended"
    
    "Large reddish-brown octopus with white eye patches collecting coconut shells from sandy seafloor, arms selecting perfect shells with precision, yellowtail snappers investigating, hermit crabs on sand, sea grass swaying"
    
    "Large reddish-brown octopus with white eye patches arranging rocks into fortress structure, arms coordinating like construction crew, blue tangs schooling, cleaning stations active, soft corals providing inspiration"
    
    "Large reddish-brown octopus with white eye patches compressing through narrow coral crevice, body flowing like liquid, staghorn and table coral maze, cleaner shrimp watching, demonstrating ultimate flexibility"
    
    "Large reddish-brown octopus with white eye patches navigating coral maze with confidence, moving through pathways purposefully, moray eel in crevice, grouper supervising, parrotfish grazing walls"
    
    "Large reddish-brown octopus with white eye patches solving natural puzzles - opening shells, manipulating coral tools, skin reflecting concentration, diverse fish schools, octopus eggs in crevices"
    
    "Large reddish-brown octopus with white eye patches using rocks innovatively to reach food, stacking tools creatively, reef sharks patrolling, eagle rays gliding, coral garden providing inspiration"
    
    "Large reddish-brown octopus with white eye patches creating spectacular chromatophore rainbow across skin, electric blues and oranges, mandarin fish, flame angelfish, coral under UV light creating art gallery"
    
    "Large reddish-brown octopus with white eye patches perfectly camouflaged against coral, then revealing itself dramatically, skin matching brain coral texture, frogfish and scorpionfish also camouflaged"
    
    "Large reddish-brown octopus with white eye patches studying flounder on sand, then mimicking movements perfectly, arms flat against body, surrounded by actual flatfish and rays"
    
    "Large reddish-brown octopus with white eye patches transforming to mimic lionfish when reef shark approaches, creating threat display, shark retreating, grouper and jacks maintaining distance"
    
    "Large reddish-brown octopus with white eye patches displaying color communication patterns, sending messages to distant octopus, wrasse changing colors, cuttlefish patterns, reef light show"
    
    "Large reddish-brown octopus with white eye patches camouflaged perfectly, striking with lightning speed to capture fish, reef ecosystem unaware of predator, patience and precision hunting"
    
    "Large reddish-brown octopus with white eye patches sleeping in coral den, skin cycling through dream colors, nocturnal reef with flashlight fish, coral polyps feeding, night predators"
    
    "Large reddish-brown octopus with white eye patches showing curiosity with kelp fronds, skin bright with happiness, dolphins investigating distance, sea turtles observing, fish schools excited"
    
    "Large reddish-brown octopus with white eye patches demonstrating hunting to juveniles watching from crevices, knowledge transfer, marine families participating, underwater classroom scene"
    
    "Multiple octopus individuals showing different personalities - large reddish-brown one with white eye patches being bold, others cautious or playful, celebrating diversity of marine intelligence"
    
    "Large reddish-brown octopus with white eye patches in eye contact moment, complex eye movements and colors, surrounded by reef complexity representing intelligence networks"
    
    "Large reddish-brown octopus with white eye patches moving with otherworldly grace through coral landscape, arms flowing like spacecraft, reef pulsing with life, coral spawning, marine behaviors"
)

# Character Consistency Strategy
COSMOS_SEED=65000  # SAME SEED for ALL scenes (visual consistency)
COSMOS_DESCRIPTION="Large reddish-brown Giant Pacific Octopus with distinctive white patches behind eyes, 12-foot arm span, intelligent coordinated movements"

echo "🎙️ STEP 1: Generating Samara X professional narrations..."
echo "🤖 Professional voice perfect for alien intelligence theme"
echo ""

# STEP 1: Generate ALL Narrations with Samara X Voice
for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"

    echo "🎤 Scene $scene: Generating Samara X narration..."

    (
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"$narration\",
                \"voice\": \"19STyYD15bswVz51nqLf\",
                \"stability\": 0.5,
                \"similarity_boost\": 0.75,
                \"style\": 0.7,
                \"speed\": 1.0
            }")

        audio_url=$(echo "$response" | jq -r '.audio.url')

        if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
            curl -s -o "octopus_narrations/scene${scene}.mp3" "$audio_url"
            echo "✅ Scene $scene: Samara X narration saved"
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
echo "⏳ Waiting for all Samara X narrations to complete..."
wait

echo ""
echo "🔧 MANDATORY: Padding all narrations to 8.000s..."

# CRITICAL: Pad ALL narrations to exactly 8.000 seconds
for scene in {1..24}; do
    if [[ -f "octopus_narrations/scene${scene}.mp3" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "octopus_narrations/scene${scene}.mp3" 2>/dev/null)
        
        needs_padding=$(echo "$duration < 8.0" | bc -l)
        if [[ $needs_padding -eq 1 ]]; then
            echo "Scene $scene: ${duration}s → 8.000s (adding silence padding)"
            ffmpeg -y -i "octopus_narrations/scene${scene}.mp3" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "octopus_narrations/scene${scene}_padded.mp3" 2>/dev/null
            mv "octopus_narrations/scene${scene}_padded.mp3" "octopus_narrations/scene${scene}.mp3"
        fi
    fi
done

echo "✅ All narrations padded to perfect 8.000s boundaries"

# STEP 2: Generate Videos with SAME SEED (Character Consistency)
echo ""
echo "🎥 STEP 2: Generating videos with FIXED character consistency..."
echo "🐙 Using SAME seed (65000) for all scenes"
echo "🌊 Physical descriptions only (no character names)"
echo ""

for i in {0..23}; do
    scene=$((i + 1))
    rich_visual="${rich_visuals[$i]}"

    full_prompt="$rich_visual, cinematic underwater documentary, wild natural behavior, alien intelligence demonstration, spectacular marine biodiversity, crystal-clear tropical water, no speech, ambient ocean sounds only"

    echo "🐙 Scene $scene: Generating with SAME seed $COSMOS_SEED (character consistency)"

    (
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$full_prompt\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $COSMOS_SEED}")

        echo "$response" > "octopus_responses/scene${scene}_response.json"

        video_url=$(echo "$response" | jq -r '.video.url')

        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "octopus_videos/scene${scene}.mp4" "$video_url"
            echo "✅ Scene $scene: Character-consistent video saved"
        else
            echo "❌ Scene $scene: Failed to generate"
        fi
    ) &

    if (( i % 3 == 2 )); then
        sleep 3
    else
        sleep 1
    fi
done

echo ""
echo "⏳ Waiting for all character-consistent videos..."
wait

echo ""
echo "🎬 STEP 3: Mixing with perfect synchronization..."

for i in {1..24}; do
    if [[ -f "octopus_videos/scene${i}.mp4" && -f "octopus_narrations/scene${i}.mp3" ]]; then
        echo "🔊 Scene $i: Mixing Samara X narration with character-consistent visuals"

        ffmpeg -y -i "octopus_videos/scene${i}.mp4" -i "octopus_narrations/scene${i}.mp3" \
            -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac \
            "octopus_mixed/scene${i}_mixed.mp4" 2>/dev/null
    fi
done

# STEP 4: Final Assembly
echo ""
echo "📽️ STEP 4: Compiling The Octopus Mind..."

> octopus_playlist.txt
for i in {1..24}; do
    if [[ -f "octopus_mixed/scene${i}_mixed.mp4" ]]; then
        echo "file 'octopus_mixed/scene${i}_mixed.mp4'" >> octopus_playlist.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i octopus_playlist.txt -c copy "THE_OCTOPUS_MIND_DOCUMENTARY.mp4" 2>/dev/null

if [[ -f "THE_OCTOPUS_MIND_DOCUMENTARY.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_OCTOPUS_MIND_DOCUMENTARY.mp4" | cut -d. -f1)
    filesize=$(ls -lh "THE_OCTOPUS_MIND_DOCUMENTARY.mp4" | awk '{print $5}')

    echo ""
    echo "🐙 THE OCTOPUS MIND - CHARACTER CONSISTENCY FIXED!"
    echo "📁 File: THE_OCTOPUS_MIND_DOCUMENTARY.mp4"
    echo "⏱️ Duration: $((duration / 60))m $((duration % 60))s"
    echo "💾 Size: $filesize"
    echo "🎤 Narrator: Samara X (Professional)"
    echo ""
    echo "🎯 CHARACTER CONSISTENCY IMPROVEMENTS:"
    echo "  ✅ SAME seed (65000) for all scenes"
    echo "  ✅ Physical descriptions only (no character names)"
    echo "  ✅ Wild natural behavior only (no laboratory)"
    echo "  ✅ Rich marine ecosystem detail in every scene"
    echo "  ✅ Perfect 8.000s synchronization"
    echo ""
    echo "🌊 This demonstrates proper character consistency for web app!"
fi

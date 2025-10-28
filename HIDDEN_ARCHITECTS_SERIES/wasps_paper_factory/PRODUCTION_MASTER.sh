#!/bin/bash

# ========================================
# MASTER PRODUCTION ORCHESTRATOR
# The Wasp's Paper Factory - Hidden Architects Series
# PARALLEL EXECUTION: Narrations + Videos (16:9) + Videos (9:16) + Music
# FINAL OUTPUT: YouTube 16:9 + TikTok 9:16 + Highlights (16/24s segments)
# ========================================

set -e
cd "$(dirname "$0")" || exit 1

# Load environment
source .env
if [ -z "$FAL_API_KEY" ]; then
    echo "❌ ERROR: FAL_API_KEY not found in .env"
    exit 1
fi

echo "🎬 STARTING MASTER PRODUCTION ORCHESTRATOR"
echo "═══════════════════════════════════════════"
echo "Project: The Wasp's Paper Factory"
echo "Narrator: Rachel (precision, design focus)"
echo "Duration: 3:12 (24 scenes × 8 seconds)"
echo "Output: YouTube 16:9 + TikTok 9:16 + Highlights"
echo ""

# ========================================
# PHASE 2-4: PARALLEL GENERATION
# ========================================

echo "⚡ PHASE 2-4: PARALLEL GENERATION"
echo "Starting: Narrations, Videos (16:9), Videos (9:16), Music"
echo "═══════════════════════════════════════════"
echo ""

# Create output directories
mkdir -p audio videos videos_9x16 music final final_9x16 responses highlights

# Create individual generation scripts that will run in background
echo "Starting parallel processes..."

# Phase 2: Narration Generation (background)
echo "🎙️  Starting Phase 2: Narration Generation..."
{
    source .env
    NARRATOR="Rachel"
    AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
    
    declare -a narrations=(
        "In gardens and under eaves, a revolution happened silently. Not with tools, not with hands. Just instinct and saliva. This is how wasps invented paper. Four thousand years before humans wrote on it."
        "Wasps don't harvest pre-made paper. They make it from nothing. Wood fiber scraped from tree bark, fence posts, dead branches. Just wood and saliva transformed into something entirely new."
        "Inside the wasp's mouth, magic happens. Wood fiber gets softened, broken down, liquified by enzymes and saliva. A pulping machine smaller than a grain of rice. The same process humans invented for paper mills."
        "The wasp flies home. Tiny mouth packed with material. Carrying its own body weight in processed wood fiber. Every trip a delivery of raw resource to the factory."
        "At the nest entrance, the wasp transfers its cargo. Passing processed fiber to construction workers waiting inside. A coordinated handoff. Assembly line precision."
        "Inside, the master builders wait. These wasps sculpt the fiber into something impossible. Paper. They hold the shape, they create the structure, they build with precision."
        "Not randomly. Not chaotically. Hexagons. Perfect six-sided chambers. The most efficient shape in nature. Stronger than any other geometry. More space, less material. Pure mathematics made real."
        "One nest might contain 300 hexagonal cells. Thousands if the nest gets massive. Each one identical. Each one perfect. Built in darkness by creatures with brains smaller than grains of sand."
        "The finished paper. Lightweight but strong. Breathable. Durable. Resistant to moisture and decay. Properties engineers spend millions developing in labs. This wasp does it instinctively."
        "Each hexagonal cell isn't random. Cells are sized precisely for wasp larvae. Too big: waste space. Too small: crush the pupae. The wasp knows the exact dimensions needed and builds to specification."
        "The hexagons connect seamlessly. No gaps. No overlaps. They share walls, doubling the strength while halving the material. Engineering students study this. It's optimal."
        "A wasp nest uses the absolute minimum material for maximum volume. Scientists measure it mathematically. It's perfect. An architect couldn't improve it. Nature got here first."
        "The nest has air channels. Spaces between hexagon layers allowing airflow. Wasps maintain precise humidity and temperature inside. Passive climate control. Biological air-conditioning."
        "The paper isn't just architecture. It's armor. Multiple layers provide insulation and protection. Rain can't penetrate. Predators struggle to break through. The walls are stronger than they appear."
        "One wasp can build. Many wasps build faster. They coordinate without supervision. No architect directing. No blueprint. Just instinct and collective intelligence creating increasingly complex structures."
        "Hundreds of hexagons. Thousands working in harmony. Built without tools, without plans, without engineers. Just ancient instinct producing architecture that rivals human achievement."
        "Humans saw this and copied it. Hexagonal structures now appear everywhere. Buildings. Textiles. Aircraft design. Honeycomb sandwiches in engineering. We're learning from million-year-old teachers."
        "The paper industry produces billions of tons annually. Modern mills process wood at industrial scale. But the essential process? Fiber plus water plus pressure equals paper. The wasp discovered this equation millions of years ago."
        "If you needed to hire an architect, the wasp would qualify. Design optimization. Material efficiency. Structural integrity. Durability. Climate control. Every specification met perfectly."
        "No wasp is smarter than any other. No leader directs. Thousands of individual wasps following simple rules create complex, optimal structures. Emergence. Organization without hierarchy. We don't fully understand how this works."
        "This design has been perfected over millions of years. Variations tested. Failures eliminated. Natural selection optimized every parameter. The wasp didn't invent this. Evolution did."
        "Every hexagon serves. Protection. Incubation. Food storage. Nursery. The wasp doesn't build for beauty, though it is beautiful. It builds for survival. Function and form in perfect balance."
        "Wasps aren't thinking about engineering. They're not aware they're innovating. It's just instinct. Millions of years of programming creating buildings we admire. Solving problems we take years to study."
        "The wasp built paper long before civilization discovered it. Invented hexagonal optimization before mathematics formalized it. Created architecture before architects existed. The hidden architect. Patient. Precise. Perfect. Practicing its craft in gardens, noticed by few, instructing millions."
    )
    
    for i in {0..23}; do
        scene=$((i + 1))
        narration_text="${narrations[$i]}"
        output_file="audio/scene${scene}.mp3"
        
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"text\": \"$narration_text\", \"voice\": \"$NARRATOR\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0, \"model_id\": \"eleven_turbo_v2_5\"}")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        if [[ -n "$audio_url" ]]; then
            curl -s -o "$output_file" "$audio_url"
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
            if (( $(echo "$duration < 8.0" | bc -l) )); then
                ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "audio/scene${scene}_temp.mp3" 2>/dev/null
                mv "audio/scene${scene}_temp.mp3" "$output_file"
            fi
            echo "✅ Scene $scene: Narration (background)"
        fi
        sleep 0.3
    done
} &
NARRATION_PID=$!

# Phase 3a: 16:9 Video Generation (background)
echo "🎥 Starting Phase 3a: 16:9 Video Generation..."
{
    source .env
    VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
    
    declare -a visuals=(
        "Aerial shot of wasp nest in garden, zooming into papery texture with golden light"
        "Close-up wasp on weathered wood, mandibles scraping fibers, 50x magnification"
        "Macro wasp head with mandibles working, animation showing mouth processing"
        "Wasp in flight with material, returning to nest, multiple workers entering"
        "Extreme macro wasp-to-wasp exchange at nest entrance, fiber transfer visible"
        "Interior nest, wasps positioning fiber, sculpting hexagonal cells"
        "Overhead nest showing hexagonal pattern emerging, geometric perfection"
        "Cross-section nest showing hundreds of hexagons, scale comparison to matchstick"
        "Close-up finished wasp paper texture, light showing thinness, layered structure"
        "Wasp laying egg in empty hexagon, larva showing perfect fit"
        "Overhead cross-section showing seamless hexagon connection, shared walls"
        "Wasp nest vs human structure comparison, mathematical efficiency display"
        "Interior nest showing air channels, cross-section with ventilation spaces"
        "Raindrop hitting nest, water beading, predator attempting to breach"
        "Time-lapse nest construction from small to large, multiple wasps building"
        "Full nest in golden hour, multiple angles showing complete structure"
        "Human hexagonal structures: buildings, aircraft, honeycomb panels"
        "Paper mill processing wood, cut to wasp doing miniature version"
        "Close-up nest detail with labels, professional engineer inspecting"
        "Multiple wasps working independently, zoom showing distributed effort"
        "Fossil evidence of wasp nests through deep time, evolutionary progression"
        "Cross-section showing cell purposes: larvae, food storage, nursery"
        "Individual wasp at work, macro detail, nest in background"
        "Final beauty shot complete wasp nest in golden light, multiple angles"
    )
    
    for i in {0..23}; do
        scene=$((i + 1))
        visual="${visuals[$i]}"
        output_file="videos/scene${scene}.mp4"
        
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$visual, extreme macro, golden hour lighting, nature documentary, no speech, ambient only\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\"}")
        
        video_url=$(echo "$response" | jq -r '.video.url // empty')
        if [[ -n "$video_url" ]]; then
            curl -s -o "$output_file" "$video_url"
            echo "✅ Scene $scene: Video 16:9 (background)"
        fi
        sleep 1
    done
} &
VIDEO_16X9_PID=$!

# Phase 3b: 9:16 Video Generation (background)
echo "🎥 Starting Phase 3b: 9:16 Video Generation (TikTok)..."
{
    source .env
    VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
    
    declare -a visuals=(
        "Aerial shot of wasp nest in garden, zooming into papery texture with golden light"
        "Close-up wasp on weathered wood, mandibles scraping fibers, 50x magnification"
        "Macro wasp head with mandibles working, animation showing mouth processing"
        "Wasp in flight with material, returning to nest, multiple workers entering"
        "Extreme macro wasp-to-wasp exchange at nest entrance, fiber transfer visible"
        "Interior nest, wasps positioning fiber, sculpting hexagonal cells"
        "Overhead nest showing hexagonal pattern emerging, geometric perfection"
        "Cross-section nest showing hundreds of hexagons, scale comparison to matchstick"
        "Close-up finished wasp paper texture, light showing thinness, layered structure"
        "Wasp laying egg in empty hexagon, larva showing perfect fit"
        "Overhead cross-section showing seamless hexagon connection, shared walls"
        "Wasp nest vs human structure comparison, mathematical efficiency display"
        "Interior nest showing air channels, cross-section with ventilation spaces"
        "Raindrop hitting nest, water beading, predator attempting to breach"
        "Time-lapse nest construction from small to large, multiple wasps building"
        "Full nest in golden hour, multiple angles showing complete structure"
        "Human hexagonal structures: buildings, aircraft, honeycomb panels"
        "Paper mill processing wood, cut to wasp doing miniature version"
        "Close-up nest detail with labels, professional engineer inspecting"
        "Multiple wasps working independently, zoom showing distributed effort"
        "Fossil evidence of wasp nests through deep time, evolutionary progression"
        "Cross-section showing cell purposes: larvae, food storage, nursery"
        "Individual wasp at work, macro detail, nest in background"
        "Final beauty shot complete wasp nest in golden light, multiple angles"
    )
    
    for i in {0..23}; do
        scene=$((i + 1))
        visual="${visuals[$i]}"
        output_file="videos_9x16/scene${scene}.mp4"
        
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$visual, extreme macro, golden hour lighting, nature documentary, no speech, ambient only\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\"}")
        
        video_url=$(echo "$response" | jq -r '.video.url // empty')
        if [[ -n "$video_url" ]]; then
            curl -s -o "$output_file" "$video_url"
            echo "✅ Scene $scene: Video 9:16 (background)"
        fi
        sleep 1
    done
} &
VIDEO_9X16_PID=$!

# Phase 4: Music Generation (background)
echo "🎵 Starting Phase 4: Scene Music Generation..."
{
    source .env
    MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
    
    declare -a music_prompts=(
        "Solo cello establishing wonder, layered strings entering, subtle tapping, D Major, 65 BPM, discovery mood"
        "Rhythmic strings, gentle scraping percussion, building momentum, D Major, 70 BPM, work beginning"
        "Rhythmic pulse like machinery, processing sounds, building intensity, D Major, 75 BPM, transformation"
        "Building tempo, strings driving, percussion accelerating, D Major, 80 BPM, journey home"
        "Call-and-response coordination theme, D Major, 80 BPM, handoff coordination"
        "Theme establishing structure, geometric precision in music, D Major, 75 BPM, craftsmanship"
        "Mathematical theme, precise rhythmic patterns, D Major, 75 BPM, geometric perfection"
        "Expanding theme showing scale, building layers of sound, D Major, 80 BPM, scale revelation"
        "Smooth refined strings, gentle but strong, D Major, 70 BPM, finished product"
        "Precision theme returning, delicate but assured, D Major, 75 BPM, dimensioning"
        "Interconnection theme, parts coming together, harmonic unity, D Major, 75 BPM, optimization"
        "Mathematical elegance theme, perfect balance, D Major, 75 BPM, optimization perfection"
        "Flowing melody like air moving, circulation theme, D Major, 75 BPM, climate control"
        "Protective theme, strong foundation, resilience, D Major, 75 BPM, defense mechanism"
        "Building tempo, expanding theme, collective voices, D Major, 85 BPM, scaling production"
        "Full orchestral theme, all elements coming together, D Major, 80 BPM, architectural triumph"
        "Human innovation theme respecting nature, D Major, 75 BPM, learning from nature"
        "Industrial theme with natural harmony, D Major, 80 BPM, industrial discovery"
        "Professional respect theme, acknowledgment of mastery, D Major, 75 BPM, engineer recognition"
        "Multiple voices creating harmony without leadership, distributed theme, D Major, 80 BPM, emergent complexity"
        "Deep time theme, evolution unfolding, refinement across ages, D Major, 70 BPM, evolutionary triumph"
        "Purpose and beauty unified, function supporting form, D Major, 75 BPM, natural purpose"
        "Contemplative theme, wonder at instinct, D Major, 75 BPM, unconscious mastery"
        "Resolving theme returning to opening cello, full orchestration settling into peace, D Major, 75 BPM, legacy complete"
    )
    
    for i in {0..23}; do
        scene=$((i + 1))
        prompt="${music_prompts[$i]}"
        output_file="music/scene${scene}_music.wav"
        
        response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$prompt\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        if [[ -n "$audio_url" ]]; then
            curl -s -o "$output_file" "$audio_url"
            echo "✅ Scene $scene: Music (background)"
        fi
        sleep 0.5
    done
} &
MUSIC_PID=$!

# Wait for all parallel processes to complete
echo ""
echo "⏳ Waiting for parallel generation to complete..."
echo "   (Narrations, Videos 16:9, Videos 9:16, Music)"

wait $NARRATION_PID && echo "✅ Narrations complete" || echo "❌ Narrations failed"
wait $VIDEO_16X9_PID && echo "✅ Videos 16:9 complete" || echo "❌ Videos 16:9 failed"
wait $VIDEO_9X16_PID && echo "✅ Videos 9:16 complete" || echo "❌ Videos 9:16 failed"
wait $MUSIC_PID && echo "✅ Music complete" || echo "❌ Music failed"

echo ""
echo "🎬 PHASE 5: AUDIO MIXING"
echo "═══════════════════════════════════════════"

# Mix all 24 scenes with 3-layer audio
for scene in {1..24}; do
    VIDEO_FILE="videos/scene${scene}.mp4"
    NARRATION_FILE="audio/scene${scene}.mp3"
    MUSIC_FILE="music/scene${scene}_music.wav"
    MIXED_16X9="final/scene${scene}_mixed.mp4"
    
    if [ -f "$VIDEO_FILE" ] && [ -f "$NARRATION_FILE" ] && [ -f "$MUSIC_FILE" ]; then
        ffmpeg -y -i "$VIDEO_FILE" -i "$NARRATION_FILE" -i "$MUSIC_FILE" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac -ac 1 -ar 44100 "$MIXED_16X9" 2>/dev/null
        echo "✅ Scene $scene: Mixed (16:9)"
    fi
done

# Mix all 24 scenes for 9:16 (TikTok)
for scene in {1..24}; do
    VIDEO_FILE="videos_9x16/scene${scene}.mp4"
    NARRATION_FILE="audio/scene${scene}.mp3"
    MUSIC_FILE="music/scene${scene}_music.wav"
    MIXED_9X16="final_9x16/scene${scene}_mixed.mp4"
    
    if [ -f "$VIDEO_FILE" ] && [ -f "$NARRATION_FILE" ] && [ -f "$MUSIC_FILE" ]; then
        ffmpeg -y -i "$VIDEO_FILE" -i "$NARRATION_FILE" -i "$MUSIC_FILE" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac -ac 1 -ar 44100 "$MIXED_9X16" 2>/dev/null
        echo "✅ Scene $scene: Mixed (9:16)"
    fi
done

echo ""
echo "🎬 PHASE 6: COMPILATION"
echo "═══════════════════════════════════════════"

# Compile 16:9 YouTube version
> final/scene_list.txt
for scene in {1..24}; do
    echo "file 'scene${scene}_mixed.mp4'" >> final/scene_list.txt
done

cd final
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4" 2>/dev/null
cd ..
echo "✅ Compiled: THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4"

# Compile 9:16 TikTok version
> final_9x16/scene_list.txt
for scene in {1..24}; do
    echo "file 'scene${scene}_mixed.mp4'" >> final_9x16/scene_list.txt
done

cd final_9x16
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4" 2>/dev/null
cd ..
echo "✅ Compiled: THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4"

echo ""
echo "🎬 PHASE 7: TIKTOK HIGHLIGHT GENERATION"
echo "═══════════════════════════════════════════"
echo "Chopping 9:16 TikTok into 16/24-second highlight segments..."

TIKTOK_FILE="final_9x16/THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4"

# Generate 16-second and 24-second segments
segment_num=1
current_time=0
total_duration=192  # 3:12 in seconds

while [ $current_time -lt $total_duration ]; do
    # Alternate between 16s and 24s segments
    if [ $((segment_num % 2)) -eq 1 ]; then
        duration=16
    else
        duration=24
    fi
    
    if [ $((current_time + duration)) -le $total_duration ]; then
        output_file="highlights/highlight_${segment_num}_${duration}s.mp4"
        ffmpeg -y -i "$TIKTOK_FILE" -ss $current_time -t $duration -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$output_file" 2>/dev/null
        echo "✅ Highlight $segment_num: ${duration}s segment (${current_time}s - $((current_time + duration))s)"
        
        current_time=$((current_time + duration))
        segment_num=$((segment_num + 1))
    else
        break
    fi
done

echo ""
echo "════════════════════════════════════════════"
echo "✨ PRODUCTION COMPLETE!"
echo "════════════════════════════════════════════"
echo ""
echo "📺 FINAL OUTPUTS:"
echo "  ✅ YouTube 16:9 (3:12): final/THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4"
echo "  ✅ TikTok 9:16 (3:12):  final_9x16/THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4"
echo "  ✅ Highlights (16/24s segments): highlights/highlight_*_*.mp4"
echo ""
echo "🎯 All formats ready for distribution!"

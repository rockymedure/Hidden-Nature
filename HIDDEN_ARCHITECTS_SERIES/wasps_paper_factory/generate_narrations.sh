#!/bin/bash

# ========================================
# NARRATION GENERATION - THE WASP'S PAPER FACTORY
# Phase 2: Generate all 24 narrations with 8-second strict enforcement
# ========================================

set -e  # Exit on error

# Load environment variables
source .env
if [ -z "$FAL_API_KEY" ]; then
    echo "❌ ERROR: FAL_API_KEY not found in .env file"
    exit 1
fi

echo "✅ Environment loaded"
echo "📍 Working directory: $(pwd)"

# ========================================
# CONFIGURATION
# ========================================

NARRATOR="Rachel"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
AUDIO_DIR="audio"
RESPONSES_DIR="responses"
TARGET_DURATION="8.0"  # STRICT: All scenes must be exactly 8.0 seconds
MIN_DURATION="6.0"
MAX_DURATION="7.8"

# Create output directories
mkdir -p "$AUDIO_DIR"
mkdir -p "$RESPONSES_DIR"

echo ""
echo "📋 NARRATION GENERATION CONFIGURATION"
echo "════════════════════════════════════"
echo "Narrator: $NARRATOR"
echo "Target Duration: $TARGET_DURATION seconds (after padding)"
echo "Acceptable Range: $MIN_DURATION - $MAX_DURATION seconds (before padding)"
echo "Output Directory: $AUDIO_DIR"
echo ""

# ========================================
# NARRATION TEXTS (Extracted from script)
# ========================================

declare -a narrations=(
    # Scene 1
    "In gardens and under eaves, a revolution happened silently. Not with tools, not with hands. Just instinct and saliva. This is how wasps invented paper. Four thousand years before humans wrote on it."
    # Scene 2
    "Wasps don't harvest pre-made paper. They make it from nothing. Wood fiber scraped from tree bark, fence posts, dead branches. Just wood and saliva transformed into something entirely new."
    # Scene 3
    "Inside the wasp's mouth, magic happens. Wood fiber gets softened, broken down, liquified by enzymes and saliva. A pulping machine smaller than a grain of rice. The same process humans invented for paper mills."
    # Scene 4
    "The wasp flies home. Tiny mouth packed with material. Carrying its own body weight in processed wood fiber. Every trip a delivery of raw resource to the factory."
    # Scene 5
    "At the nest entrance, the wasp transfers its cargo. Passing processed fiber to construction workers waiting inside. A coordinated handoff. Assembly line precision."
    # Scene 6
    "Inside, the master builders wait. These wasps sculpt the fiber into something impossible. Paper. They hold the shape, they create the structure, they build with precision."
    # Scene 7
    "Not randomly. Not chaotically. Hexagons. Perfect six-sided chambers. The most efficient shape in nature. Stronger than any other geometry. More space, less material. Pure mathematics made real."
    # Scene 8
    "One nest might contain 300 hexagonal cells. Thousands if the nest gets massive. Each one identical. Each one perfect. Built in darkness by creatures with brains smaller than grains of sand."
    # Scene 9
    "The finished paper. Lightweight but strong. Breathable. Durable. Resistant to moisture and decay. Properties engineers spend millions developing in labs. This wasp does it instinctively."
    # Scene 10
    "Each hexagonal cell isn't random. Cells are sized precisely for wasp larvae. Too big: waste space. Too small: crush the pupae. The wasp knows the exact dimensions needed and builds to specification."
    # Scene 11
    "The hexagons connect seamlessly. No gaps. No overlaps. They share walls, doubling the strength while halving the material. Engineering students study this. It's optimal."
    # Scene 12
    "A wasp nest uses the absolute minimum material for maximum volume. Scientists measure it mathematically. It's perfect. An architect couldn't improve it. Nature got here first."
    # Scene 13
    "The nest has air channels. Spaces between hexagon layers allowing airflow. Wasps maintain precise humidity and temperature inside. Passive climate control. Biological air-conditioning."
    # Scene 14
    "The paper isn't just architecture. It's armor. Multiple layers provide insulation and protection. Rain can't penetrate. Predators struggle to break through. The walls are stronger than they appear."
    # Scene 15
    "One wasp can build. Many wasps build faster. They coordinate without supervision. No architect directing. No blueprint. Just instinct and collective intelligence creating increasingly complex structures."
    # Scene 16
    "Hundreds of hexagons. Thousands working in harmony. Built without tools, without plans, without engineers. Just ancient instinct producing architecture that rivals human achievement."
    # Scene 17
    "Humans saw this and copied it. Hexagonal structures now appear everywhere. Buildings. Textiles. Aircraft design. Honeycomb sandwiches in engineering. We're learning from million-year-old teachers."
    # Scene 18
    "The paper industry produces billions of tons annually. Modern mills process wood at industrial scale. But the essential process? Fiber plus water plus pressure equals paper. The wasp discovered this equation millions of years ago."
    # Scene 19
    "If you needed to hire an architect, the wasp would qualify. Design optimization. Material efficiency. Structural integrity. Durability. Climate control. Every specification met perfectly."
    # Scene 20
    "No wasp is smarter than any other. No leader directs. Thousands of individual wasps following simple rules create complex, optimal structures. Emergence. Organization without hierarchy. We don't fully understand how this works."
    # Scene 21
    "This design has been perfected over millions of years. Variations tested. Failures eliminated. Natural selection optimized every parameter. The wasp didn't invent this. Evolution did."
    # Scene 22
    "Every hexagon serves. Protection. Incubation. Food storage. Nursery. The wasp doesn't build for beauty, though it is beautiful. It builds for survival. Function and form in perfect balance."
    # Scene 23
    "Wasps aren't thinking about engineering. They're not aware they're innovating. It's just instinct. Millions of years of programming creating buildings we admire. Solving problems we take years to study."
    # Scene 24
    "The wasp built paper long before civilization discovered it. Invented hexagonal optimization before mathematics formalized it. Created architecture before architects existed. The hidden architect. Patient. Precise. Perfect. Practicing its craft in gardens, noticed by few, instructing millions."
)

# ========================================
# NARRATION GENERATION
# ========================================

echo "🎙️  GENERATING ALL 24 NARRATIONS"
echo "════════════════════════════════════"
echo ""

generated_count=0
failed_count=0

for i in {0..23}; do
    scene=$((i + 1))
    narration_text="${narrations[$i]}"
    output_file="$AUDIO_DIR/scene${scene}.mp3"
    response_file="$RESPONSES_DIR/scene${scene}_response.json"
    
    echo "🎙️  Scene $scene: Generating narration..."
    
    # Call FAL.ai API for narration generation
    response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$narration_text\",
            \"voice\": \"$NARRATOR\",
            \"stability\": 0.5,
            \"similarity_boost\": 0.75,
            \"style\": 0.5,
            \"speed\": 1.0,
            \"model_id\": \"eleven_turbo_v2_5\"
        }")
    
    # Save API response for debugging
    echo "$response" > "$response_file"
    
    # Extract audio URL
    audio_url=$(echo "$response" | jq -r '.audio.url // empty')
    
    if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
        # Download audio file
        curl -s -o "$output_file" "$audio_url"
        
        # Check if file exists and has content
        if [ -f "$output_file" ] && [ -s "$output_file" ]; then
            # Get actual duration
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
            
            # Validate duration is within acceptable range
            if (( $(echo "$duration >= $MIN_DURATION && $duration <= $MAX_DURATION" | bc -l) )); then
                printf "   ✅ Generated: %.2fs (✓ within range)\n" "$duration"
                ((generated_count++))
            else
                printf "   ⚠️  Generated: %.2fs (❌ OUT OF RANGE! Expected $MIN_DURATION-$MAX_DURATION)\n" "$duration"
                ((failed_count++))
            fi
        else
            echo "   ❌ Failed: File download failed or empty"
            ((failed_count++))
        fi
    else
        error_msg=$(echo "$response" | jq -r '.error // .message // "Unknown error"')
        echo "   ❌ Failed: API error - $error_msg"
        ((failed_count++))
    fi
    
    # Small delay between requests to avoid rate limits
    sleep 0.5
done

echo ""
echo "📊 GENERATION SUMMARY"
echo "════════════════════════════════════"
echo "✅ Successfully generated: $generated_count/24"
echo "❌ Failed: $failed_count/24"

if [ $failed_count -gt 0 ]; then
    echo ""
    echo "⚠️  WARNING: Some narrations failed or were out of range!"
    echo "Review RESPONSES_DIR for error details"
fi

# ========================================
# NARRATION PADDING (STRICT 8-SECOND ENFORCEMENT)
# ========================================

echo ""
echo "📐 PADDING ALL NARRATIONS TO EXACTLY 8.000 SECONDS"
echo "════════════════════════════════════"
echo ""

padded_count=0
already_padded=0

for scene in {1..24}; do
    input_file="$AUDIO_DIR/scene${scene}.mp3"
    
    if [ ! -f "$input_file" ]; then
        echo "Scene $scene: ⚠️  File not found, skipping"
        continue
    fi
    
    # Get current duration
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file" 2>/dev/null || echo "0")
    
    # Check if padding is needed
    if (( $(echo "$duration < $TARGET_DURATION" | bc -l) )); then
        # Pad with silence to exactly 8.000 seconds
        temp_file="$AUDIO_DIR/scene${scene}_temp.mp3"
        
        ffmpeg -y -i "$input_file" \
            -filter_complex "[0:a]apad=pad_dur=$TARGET_DURATION[padded]" \
            -map "[padded]" \
            -t $TARGET_DURATION \
            -q:a 9 \
            "$temp_file" 2>/dev/null
        
        # Replace original with padded version
        mv "$temp_file" "$input_file"
        
        # Verify padding
        final_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file" 2>/dev/null || echo "0")
        printf "Scene %2d: %.2fs → %.2fs (✅ PADDED)\n" "$scene" "$duration" "$final_duration"
        ((padded_count++))
    else
        printf "Scene %2d: %.2fs (✓ Already correct)\n" "$scene" "$duration"
        ((already_padded++))
    fi
done

echo ""
echo "🎬 PADDING COMPLETE"
echo "════════════════════════════════════"
echo "✅ Newly padded: $padded_count scenes"
echo "✓ Already correct: $already_padded scenes"
echo "📁 All narrations saved to: $AUDIO_DIR/"
echo ""

# ========================================
# FINAL VERIFICATION
# ========================================

echo "🔍 FINAL VERIFICATION - All scenes must be exactly 8.000 seconds"
echo "════════════════════════════════════"

all_valid=true

for scene in {1..24}; do
    file="$AUDIO_DIR/scene${scene}.mp3"
    
    if [ -f "$file" ]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null || echo "0")
        
        if (( $(echo "$duration == 8.0" | bc -l) )); then
            printf "Scene %2d: %.3fs ✅\n" "$scene" "$duration"
        else
            printf "Scene %2d: %.3fs ❌ (MISMATCH!)\n" "$scene" "$duration"
            all_valid=false
        fi
    else
        printf "Scene %2d: ❌ FILE MISSING\n" "$scene"
        all_valid=false
    fi
done

echo ""

if [ "$all_valid" = true ]; then
    echo "✅ SUCCESS! All 24 narrations are exactly 8.000 seconds"
    echo "🎬 Ready for Phase 3: Video Generation"
else
    echo "❌ ERROR: Some narrations do not meet the 8-second requirement!"
    echo "Please review and regenerate failed scenes"
    exit 1
fi

echo ""
echo "✨ Phase 2: Narration Generation COMPLETE"
echo "Next: Run ./generate_videos.sh for Phase 3"

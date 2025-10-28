#!/bin/bash

# ========================================
# REGENERATE SHORTENED NARRATIONS
# Drastically reduce text to fit 8 seconds
# ========================================

set -e
source .env

NARRATOR="Rachel"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🎙️  REGENERATING SHORTENED NARRATIONS"
echo "════════════════════════════════════"
echo ""

# DRAMATICALLY shortened narrations - targeting 5-7 seconds natural delivery
declare -a shortened_narrations=(
    # Scene 1 - was 16.67s
    "Wasps invented paper. Thousands of years before humans."
    
    # Scene 2 - was 13.64s
    "They scrape wood fiber. Transform it with saliva. Something entirely new."
    
    # Scene 3 - was 15.57s
    "Inside the wasp's mouth: magic happens. A pulping machine smaller than a grain of rice."
    
    # Scene 4 - was 12.43s
    "The wasp flies home. Carrying its own body weight in processed fiber."
    
    # Scene 5 - was 11.81s
    "At the nest entrance: a coordinated handoff. Assembly line precision."
    
    # Scene 6 - was 13.24s
    "Inside, master builders sculpt fiber into something impossible. Paper."
    
    # Scene 7 - was 16.67s
    "Hexagons. Perfect six-sided chambers. The most efficient shape in nature."
    
    # Scene 8 - was 15.39s
    "One nest: 300 hexagonal cells. Each one perfect. Built in darkness."
    
    # Scene 9 - was 14.21s
    "Lightweight but strong. Breathable. Durable. Properties engineers spend millions developing."
    
    # Scene 10 - was 17.01s
    "Each hexagon sized precisely for wasp larvae. No wasted space. Optimal protection."
    
    # Scene 11 - was 11.96s
    "Hexagons connect seamlessly. They share walls. Double strength. Half the material."
    
    # Scene 12 - was 14.45s
    "Minimum material for maximum volume. Perfect. An architect couldn't improve it."
    
    # Scene 13 - was 14.37s
    "Air channels between layers. Wasps maintain precise humidity and temperature inside."
    
    # Scene 14 - was 13.71s
    "Multiple layers provide insulation and protection. Rain can't penetrate. Walls are armor."
    
    # Scene 15 - was 14.29s
    "One wasp builds. Many wasps build faster. No supervision. Just instinct and intelligence."
    
    # Scene 16 - was 15.80s
    "Hundreds of hexagons. Thousands working in harmony. Architecture that rivals humans."
    
    # Scene 17 - was 14.45s
    "Humans saw this and copied it. Hexagons everywhere. We're learning from ancient teachers."
    
    # Scene 18 - was 18.44s
    "Fiber plus water plus pressure equals paper. The wasp discovered this millions of years ago."
    
    # Scene 19 - was 15.23s
    "Design optimization. Material efficiency. Structural integrity. Every specification perfect."
    
    # Scene 20 - was 17.71s
    "No wasp is smarter. No leader directs. Simple rules create complex optimal structures. Emergence."
    
    # Scene 21 - was 17.16s
    "Millions of years perfecting this design. Variations tested. Failures eliminated. Evolution did this."
    
    # Scene 22 - was 15.57s
    "Every hexagon serves a purpose. Protection. Incubation. Food storage. Function and form perfect."
    
    # Scene 23 - was 13.56s
    "Wasps aren't thinking about engineering. It's instinct. Millions of years of programming."
    
    # Scene 24 - was 25.08s
    "The hidden architect. Patient. Precise. Perfect. Practicing its craft in gardens."
)

for i in {0..23}; do
    scene=$((i + 1))
    narration_text="${shortened_narrations[$i]}"
    output_file="audio/scene${scene}.mp3"
    
    echo "🎙️  Scene $scene: Regenerating shortened narration..."
    
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
    
    audio_url=$(echo "$response" | jq -r '.audio.url // empty')
    if [[ -n "$audio_url" ]]; then
        curl -s -o "$output_file" "$audio_url"
        
        # Check duration
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
        
        # If still too long, add subtle speedup
        if (( $(echo "$duration > 7.8" | bc -l) )); then
            speed=$(echo "scale=2; 7.8 / $duration" | bc)
            temp_file="audio/scene${scene}_temp.mp3"
            ffmpeg -y -i "$output_file" -filter:a "atempo=$speed" "$temp_file" 2>/dev/null
            mv "$temp_file" "$output_file"
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
        fi
        
        # Pad to exactly 8.0 seconds
        if (( $(echo "$duration < 8.0" | bc -l) )); then
            temp_file="audio/scene${scene}_temp.mp3"
            ffmpeg -y -i "$output_file" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 -q:a 9 "$temp_file" 2>/dev/null
            mv "$temp_file" "$output_file"
        fi
        
        final_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output_file" 2>/dev/null || echo "0")
        printf "   ✅ Scene $scene: %.2fs → 8.00s (shortened + padded)\n" "$duration"
    else
        error_msg=$(echo "$response" | jq -r '.error // .message // "Unknown error"')
        echo "   ❌ Failed: $error_msg"
    fi
    
    sleep 0.3
done

echo ""
echo "✅ All narrations regenerated and shortened!"
echo ""
echo "Next step: Run remix script to re-mix all scenes with new narrations"

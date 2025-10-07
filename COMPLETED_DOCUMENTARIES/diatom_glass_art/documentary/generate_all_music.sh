#!/bin/bash

source ../../../.env

MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"

echo "🎵 DIATOM: Generating ALL 24 Music Clips in Parallel"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Using proper musical specifications"
echo ""

# All 24 music prompts with full specifications
declare -a MUSIC_PROMPTS=(
    "C Major, 72 BPM Andante, glass harmonica, celesta, soft synth pads, subtle harp arpeggios, ethereal wonder, crystalline shimmer, microscopic discovery, hidden beauty reveal, awe-inspiring"
    
    "G Major, 80 BPM Moderato, xylophone, marimba, shimmering synth bells, light string harmonics, scientific wonder, alchemy transformation, glass formation, spectrum refraction magic"
    
    "D Major, 85 BPM Moderato, kalimba, music box, pizzicato strings, crystalline chimes, mathematical beauty, geometric showcase, art gallery exhibition, pattern celebration"
    
    "A Minor, 75 BPM Andante, woodblocks, tuned percussion, mechanical clicks, soft marimba, engineering marvel, precision assembly, puzzle pieces fitting, biological architecture"
    
    "E Major, 90 BPM Moderato, building crescendo with layered marimbas, soft timpani rolls, ascending harp glissandos, architectural wonder, construction process, creative building, cathedral-like grandeur"
    
    "C Major, 85 BPM Allegretto, warm celesta, gentle orchestral strings, triumphant bells, soft brass accents, newborn beauty, perfect completion, triumphant reveal, artistic achievement"
    
    "F Major, 68 BPM Adagio, soft piano, ambient synth pad, gentle woodwinds, subtle percussion loop, quiet productivity, living factory, photosynthesis rhythm, essential unseen labor"
    
    "Bb Major, 95 BPM Allegro, expanding orchestral strings, building brass section, epic percussion, choir pad, planetary scale revelation, ecological importance, invisible army, epic scope"
    
    "E Minor, 78 BPM Andante, pizzicato cello, soft ticking clock, gentle synth pulses, building tension, biological precision, cell division, life splitting, reproductive tension building"
    
    "G Major, 82 BPM Moderato, dual synchronized marimbas, perfect harmony bells, precise digital pulses, genetic precision, dual construction, DNA blueprint, mathematical perfection"
    
    "D Minor, 70 BPM Andante, descending piano motif, concerned strings, shrinking synth tones, gentle concern, shrinking progression, biological constraint, evolutionary problem"
    
    "A Major, 88 BPM Allegretto, rising orchestral swell, triumphant brass fanfare, celebratory strings, dramatic solution, evolutionary genius, renewal rebirth, problem solved celebration"
    
    "A Minor, 60 BPM Largo, solo cello, soft piano, descending harp, ambient water sounds, melancholic beauty, gentle requiem, death's dignity, somber sinking drift"
    
    "C Minor, 55 BPM Grave, deep bass tones, low strings, distant echoing percussion, ambient drone, vast accumulation, geological time, countless billions, eternal resting place"
    
    "F Minor, 50 BPM Grave, slow building orchestral layers, compression sfx, low brass, timpani, geological transformation, deep time compression, weight of ages, stone formation"
    
    "C Major, 100 BPM Allegro, epic orchestral tutti, soaring brass, massive timpani, choir swell, microscopic to mountain scale, epic revelation, ultimate legacy, cliff majesty"
    
    "G Major, 85 BPM Moderato, modern electronic meets acoustic strings, industrial percussion, xylophone, ancient meeting modern, practical utility, time connection, applied science"
    
    "E Major, 65 BPM Adagio, sustained string harmonics, crystalline bells, eternal synth pad, music box, eternal preservation, mathematics frozen in time, timeless beauty, perfect endurance"
    
    "D Major, 92 BPM Allegretto, bright acoustic guitar, bubbling marimba, vibrant strings, ocean ambience, life renewed, vibrant return, ongoing creation, ocean alive with possibility"
    
    "A Major, 80 BPM Andante, warm piano, layered cellos, unbroken melodic line, generational harmony, unbroken continuity, genetic fidelity, pattern persistence, living tradition"
    
    "F Major, 70 BPM Andante, reflective piano, warm strings, human-scale acoustic guitar to microscopic bells, philosophical reflection, invisible labor, human connection, grateful acknowledgment"
    
    "Bb Major, 88 BPM Moderato, playful woodwinds, inventive marimba patterns, curious pizzicato, evolving melody, evolutionary innovation, novelty emergence, endless creativity, gallery expanding"
    
    "E Major, 95 BPM Allegro, multiplying layers of bells, infinite echo strings, massive orchestral build, infinite abundance, mathematical perfection multiplied, overwhelming numbers, planetary scale"
    
    "C Major, 75 BPM Andante maestoso, full orchestra finale, soaring strings, triumphant brass, crystalline bells, celesta, final celebration, artistic tribute, geometric perfection homage, grateful wonder crescendo"
)

# Generate all music in parallel (10 at a time to manage load)
for i in {0..23}; do
    scene=$((i + 1))
    scene_num=$(printf "%02d" $scene)
    prompt="${MUSIC_PROMPTS[$i]}"
    
    (
        echo "🎵 Scene $scene_num: Generating music..."
        
        response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"prompt\": \"$prompt\",
                \"seconds_total\": 8,
                \"num_inference_steps\": 8,
                \"guidance_scale\": 7
            }")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        
        if [[ -n "$audio_url" ]]; then
            curl -s -o "music/scene${scene_num}.mp3" "$audio_url"
            if [[ -f "music/scene${scene_num}.mp3" ]]; then
                duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "music/scene${scene_num}.mp3" 2>/dev/null)
                printf "   ✅ Scene %s: Music generated (%.2fs)\n" "$scene_num" "$duration"
            fi
        else
            echo "   ❌ Scene $scene_num: Failed"
            echo "$response" > "responses/scene${scene_num}_music_error.json"
        fi
    ) &
    
    # Limit concurrent jobs to 10
    if (( (scene % 10) == 0 )); then
        wait
    fi
done

wait  # Wait for all remaining jobs

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Music generation complete!"
echo ""
echo "📊 Final Status:"
for i in {01..24}; do
    if [[ -f "music/scene${i}.mp3" ]]; then
        dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "music/scene${i}.mp3" 2>/dev/null)
        size=$(ls -lh "music/scene${i}.mp3" | awk '{print $5}')
        printf "   ✅ Scene %s: %.2fs (%s)\n" "$i" "$dur" "$size"
    else
        echo "   ❌ Scene $i: Missing"
    fi
done


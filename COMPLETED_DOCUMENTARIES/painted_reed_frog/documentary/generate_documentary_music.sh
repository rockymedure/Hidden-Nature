#!/bin/bash
source ../../../.env

MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
mkdir -p music

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎵 REGENERATING DOCUMENTARY-QUALITY MUSIC"
echo "   Brian Eno meets David Attenborough"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Rich, atmospheric, documentary-quality music prompts
declare -a prompts=(
# Scene 1: Dawn awakening - mysterious, ethereal
"Ambient dawn atmosphere with layered synthesizer pads, distant woodwind flutes, gentle marimba, subtle field recordings of morning wetland, evolving textures, mysterious and ethereal, minimal melody, Brian Eno style ambient meets nature documentary score, awakening, hidden secrets emerging, 72 BPM"

# Scene 2: Camouflage/survival - tense, organic
"Sparse orchestral strings with long sustained notes, wooden percussion, subtle bass drone, organic textures, documentary tension, survival instinct, naturalistic, atmospheric, 70 BPM, minimalist approach, freeze response musical equivalent"

# Scene 3: Isolation - melancholic, yearning
"Solo cello with reverb, distant ambient synth pad, lonely clarinet melody, sparse piano notes, melancholic and yearning, emotional documentary scoring, waiting in stillness, BBC nature documentary style, 65 BPM, space between notes matters"

# Scene 4: Danger (snake) - suspense, release
"Tension building with low frequency drone, pizzicato strings, subtle heartbeat percussion, ambient textures, documentary suspense, danger passing, survival success, relief washing over, naturalistic orchestration, 80 BPM"

# Scene 5: Midday stillness - minimal, patient
"Minimal ambient soundscape, slow evolving synth textures, occasional wooden percussion, heat haze musical equivalent, patient endurance, documentary minimalism, barely-there instrumentation, Brian Eno ambient style, 55 BPM, space and stillness"

# Scene 6: Cost of hiding - emotional, observational
"Gentle acoustic guitar arpeggio, soft strings, melancholic woodwinds, ambient nature sounds integrated, emotional cost of survival, documentary introspection, watching life pass by, bittersweet, intimate orchestration, 62 BPM"

# Scene 7: Anticipation begins - building, hopeful
"Warm synth pads emerging, gentle string swells, ascending piano motif, hope building, golden hour musicality, transformation approaching, documentary emotional build, Brian Eno warmth with orchestral elements, 68 BPM"

# Scene 8: Ready for change - expectant, gathering
"Building orchestral layers, warm brass entering softly, ascending strings, synthesizer textures underneath, expectation and readiness, documentary pre-transformation, musical anticipation, rich instrumentation, 72 BPM, energy gathering"

# Scene 9: First color - magical, wonder
"Shimmering celesta, glockenspiel, harp glissando, warm string harmonics, magical realism documentary score, first reveal of wonder, Color emerging musically, ethereal synthesis with organic instruments, transformation beginning, 75 BPM"

# Scene 10: Cellular transformation - scientific wonder
"Rhythmic pulsing synth arpeggios, marimba patterns, strings with col legno technique, scientific documentary style, biological process unfolding, active cellular energy, Planet Earth transformation scene music, 82 BPM, precise and organic"

# Scene 11: Colors blooming - revelation building
"Full string section ascending, brass swells, shimmering synthesizer layers, rhythmic momentum building, cinematic documentary crescendo, colors exploding into life, transformation accelerating, rich orchestration, 88 BPM, dramatic reveal approaching"

# Scene 12: Complete transformation - triumph, beauty
"Triumphant full orchestra with French horns, soaring strings, celesta shimmer, rich synth pads, complete reveal moment, documentary climax, breathtaking beauty unveiled, BBC Earth grand moment, majestic and emotional, 90 BPM"

# Scene 13: Freedom expressed - joyous, liberated
"Playful woodwinds, dancing strings, bright marimba, warm brass accents, freedom and joy, documentary celebration of life, true self revealed, energetic but organic, natural world exuberance, 85 BPM, lightness and movement"

# Scene 14: Night ecosystem - rich, layered community
"Multiple melodic layers, full orchestra working together, rich ambient textures, various instruments representing different creatures, documentary ecosystem theme, community awakening, BBC nature documentary complexity, 92 BPM, alive and interconnected"

# Scene 15: Finding voice - ascending, personal
"Ascending flute melody over warm string bed, vocal-like synthesis, personal expression theme, documentary moment of self-discovery, voice emerging from silence, intimate yet expansive, 78 BPM, melodic focus"

# Scene 16: Bold movement - confident, flowing
"Flowing strings with momentum, woodwinds dancing freely, ambient textures supporting, confident movement, documentary freedom sequence, living fully, natural grace, unbounded energy, 95 BPM, graceful and assured"

# Scene 17: Mating display competition - energetic, vibrant
"Multiple competing melodic lines, various orchestral sections in conversation, rhythmic vitality, documentary mating ritual music, natural competition, vibrant ecosystem energy, Blue Planet courtship scene style, 100 BPM"

# Scene 18: Mate selection - thoughtful, instinctual
"Contemplative piano theme, supporting strings, gentle decision-making motif, documentary choice moment, biological imperative meeting personal selection, intimate and purposeful, 75 BPM, quiet certainty"

# Scene 19: Courtship dance - elegant, romantic
"Elegant waltz-like strings, romantic woodwinds, synchronized rhythmic elements, intimate documentary romance, partnership forming, organic beauty, dance of nature, BBC Earth intimate moment, 82 BPM, graceful duet"

# Scene 20: Predator passes safely - brief tension resolving
"Quick tension and immediate resolution, bat wingbeat percussion, ambient night textures, ecological understanding theme, documentary revelation moment, safety in darkness, natural wisdom, 98 BPM, flutter and calm"

# Scene 21: Hidden world revealed - grand, documentary awe
"Wide cinematic orchestration, ambient synth foundation, majestic strings, warm brass, documentary revelation theme, hidden world unveiled, Brian Eno grandeur meets BBC Earth wonder, ecosystem majesty, 72 BPM, epic and intimate"

# Scene 22: Pre-dawn bittersweet - fading, melancholic
"Gentle strings becoming softer, melancholic piano, ambient textures fading, bittersweet documentary transition, time passing musically, beauty beginning to fade, emotional documentary moment, 65 BPM, tender and sad"

# Scene 23: Colors fading - reverse transformation, loss
"Descending orchestral lines, colors fading musically, ambient synth slowly diminishing, documentary loss theme, transformation in reverse, necessary sacrifice, beautiful sadness, Blue Planet ending sequence style, 58 BPM"

# Scene 24: Cycle complete - hope remains, resilience
"Minor key transitioning to major, gentle resolution, ambient hope underneath, cyclical theme returning, documentary completion with promise, resilience and acceptance, she will bloom again, Brian Eno optimism, 68 BPM, gentle closure"
)

# Generate all music in parallel (10 at a time)
for i in {0..23}; do
    scene=$((i + 1))
    prompt="${prompts[$i]}"
    
    (
        echo "🎵 Scene $(printf "%02d" $scene): Generating documentary score..."
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
            curl -s -o "music/scene$(printf "%02d" $scene).mp3" "$audio_url"
            echo "   ✅ Scene $(printf "%02d" $scene): Documentary music saved"
        else
            echo "   ❌ Scene $(printf "%02d" $scene): Failed"
            echo "$response" | jq '.'
        fi
    ) &
    
    # Limit concurrent jobs
    if (( (i + 1) % 10 == 0 )); then
        wait
    fi
done

wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ DOCUMENTARY MUSIC COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Style: Cinematic nature documentary with ambient textures"
echo "Inspiration: Brian Eno ambient + David Attenborough/BBC Earth"
echo "Total files:" $(ls music/*.mp3 2>/dev/null | wc -l)


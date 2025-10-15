#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
NARRATOR_VOICE_ID="XB0fDUnXU5powFXDhCwa" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎬 GENERATING 5 CONCEPTS AS 16s SHORTS (2 scenes each)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Arrays: [concept_name, display_name, seed, narration1, narration3, visual1, visual3, music1, music3]

generate_concept() {
    local concept=$1
    local name=$2
    local seed=$3
    local narr1=$4
    local narr3=$5
    local vis1=$6
    local vis3=$7
    local mus1=$8
    local mus3=$9
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    cd "$concept" || return
    
    # Scene 1
    echo ""
    echo "🎥 Scene 1/2: Setup"
    
    echo "   🎙️  Narration..."
    curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"text\": \"$narr1\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene1.mp3
    echo "      ✅ $(ls -lh audio/scene1.mp3 | awk '{print $5}')"
    
    echo "   📹 Video..."
    curl -s -X POST "$VIDEO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$vis1\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": $seed, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene1.mp4
    echo "      ✅ $(ls -lh videos/scene1.mp4 | awk '{print $5}')"
    
    echo "   🎵 Music..."
    curl -s -X POST "$MUSIC_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$mus1\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene1.mp3
    echo "      ✅ $(ls -lh music/scene1.mp3 | awk '{print $5}')"
    
    # Scene 3 (payoff)
    echo ""
    echo "🎥 Scene 2/2: Payoff"
    
    echo "   🎙️  Narration..."
    curl -s -X POST "$AUDIO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"text\": \"$narr3\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene3.mp3
    echo "      ✅ $(ls -lh audio/scene3.mp3 | awk '{print $5}')"
    
    echo "   📹 Video..."
    curl -s -X POST "$VIDEO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$vis3\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": $seed, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene3.mp4
    echo "      ✅ $(ls -lh videos/scene3.mp4 | awk '{print $5}')"
    
    echo "   🎵 Music..."
    curl -s -X POST "$MUSIC_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$mus3\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene3.mp3
    echo "      ✅ $(ls -lh music/scene3.mp3 | awk '{print $5}')"
    
    # Check and adjust narration timing
    echo ""
    echo "⏱️  Checking narration timing..."
    dur1=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 audio/scene1.mp3)
    dur3=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 audio/scene3.mp3)
    
    # Speed up if over 7.8s
    if (( $(echo "$dur1 > 7.8" | bc -l) )); then
        speed=$(echo "$dur1 / 7.5" | bc -l)
        ffmpeg -y -i audio/scene1.mp3 -filter:a "atempo=$speed" audio/scene1_fixed.mp3 2>/dev/null
        mv audio/scene1_fixed.mp3 audio/scene1.mp3
        echo "   ✅ Scene 1 narration sped up to 7.5s"
    fi
    
    if (( $(echo "$dur3 > 7.8" | bc -l) )); then
        speed=$(echo "$dur3 / 7.5" | bc -l)
        ffmpeg -y -i audio/scene3.mp3 -filter:a "atempo=$speed" audio/scene3_fixed.mp3 2>/dev/null
        mv audio/scene3_fixed.mp3 audio/scene3.mp3
        echo "   ✅ Scene 3 narration sped up to 7.5s"
    fi
    
    # Mix scenes
    echo ""
    echo "🔊 Mixing..."
    mkdir -p final
    for i in 1 3; do
        ffmpeg -y -i videos/scene${i}.mp4 -i audio/scene${i}.mp3 -i music/scene${i}.mp3 \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" -c:v copy -c:a aac -ac 1 -ar 44100 \
            final/scene${i}_mixed.mp4 2>/dev/null
    done
    echo "   ✅ Scenes mixed"
    
    # Compile final short
    echo ""
    echo "🎬 Compiling final short..."
    echo "file 'scene1_mixed.mp4'" > final/concat_list.txt
    echo "file 'scene3_mixed.mp4'" >> final/concat_list.txt
    
    ffmpeg -y -f concat -safe 0 -i final/concat_list.txt -c copy "../${name}_16s.mp4" 2>/dev/null
    
    if [[ -f "../${name}_16s.mp4" ]]; then
        size=$(ls -lh "../${name}_16s.mp4" | awk '{print $5}')
        dur=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "../${name}_16s.mp4" | awk '{printf "%.1fs", $1}')
        echo "   ✨ ${name}_16s.mp4 ($size, $dur)"
    fi
    
    cd ..
    echo ""
}

# Generate all 5 concepts
generate_concept "cuttlefish" "Cuttlefish" 22222 \
    "Danger. A predator overhead. But she has a superpower. She can become invisible. And it happens in milliseconds." \
    "Perfect match. She's completely invisible. The predator swims past. And she's colorblind. She did all that without seeing color." \
    "Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, floating above sandy ocean floor, currently displaying mottled brown/tan pattern matching sand, predatory shark silhouette visible in background, underwater scene with natural light filtering down, cuttlefish beginning to sense threat, no speech, ambient underwater sounds" \
    "Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, now perfectly camouflaged against rocky coral background, almost completely invisible, only subtle outline visible, predator (shark) passing overhead in frame, cuttlefish remains motionless and camouflaged, incredible demonstration of camouflage, underwater lighting, no speech, ambient underwater sounds" \
    "Ominous low strings with ocean-like synth pad, underwater tension, Key: E minor, Tempo: 70 BPM" \
    "Quiet resolution with sparse ambient tones, wonder and mystery, ocean atmosphere, Key: E Major, Tempo: 60 BPM"

generate_concept "tardigrade" "Tardigrade" 33333 \
    "Meet the tardigrade. Less than a millimeter long. Eight legs. Looks like a microscopic bear. And he's nearly indestructible." \
    "He can survive years like this. Frozen. Boiled. Even the vacuum of space. Then add water. And he just wakes up." \
    "Tardigrade (water bear) with plump segmented body, eight stubby legs with claws, cute bear-like face with simple mouth, translucent body showing internal organs, crawling on moss under microscope, adorable lumbering gait, extreme macro/microscopy view, brightfield illumination, scientific but charming, scaled to show full body, no speech, silent microscopy" \
    "Tardigrade (water bear) in hardened tun state, barrel-shaped and dormant, then water being added (visible droplet entering frame), tun beginning to expand, legs emerging, returning to active form, full reanimation, crawling again as if nothing happened, incredible biological resurrection, microscopy view, brightfield illumination, miracle of survival, no speech, silent microscopy" \
    "Curious and whimsical, playful celesta and pizzicato strings, tiny explorer theme, Key: C Major, Tempo: 78 BPM" \
    "Triumphant resolution with building orchestral swell, survival victory, life finds a way theme, Key: C Major, Tempo: 80 BPM"

generate_concept "venus_flytrap" "Venus_Flytrap" 44444 \
    "She sits. She waits. Jaws open. Six trigger hairs inside. Waiting for prey to make one critical mistake." \
    "Sealed. She releases enzymes. Over ten days, she'll digest him completely. Then the trap opens again. Ready for the next meal." \
    "Venus flytrap (Dionaea muscipula) with bright red-pink interior trap, white-green exterior, prominent trigger hairs visible inside trap, trap fully open in waiting position, menacing appearance despite being a plant, macro close-up showing trap detail, natural outdoor lighting, fly visible nearby approaching, carnivorous plant, no speech, ambient nature sounds" \
    "Venus flytrap (Dionaea muscipula) with bright red-pink interior trap now sealed shut, teeth/cilia interlocked forming tight seal, slight bulge where fly is trapped inside, time-lapse showing trap gradually reddening as digestion occurs, plant stomach at work, macro view of sealed trap, natural lighting, patient botanical predator, no speech, ambient nature sounds" \
    "Patient suspense with sustained string notes, predatory waiting theme, botanical thriller, Key: F minor, Tempo: 55 BPM" \
    "Slow, ominous resolution with low sustained notes, digestive process theme, nature's patience, Key: F Major, Tempo: 50 BPM"

generate_concept "chameleon" "Chameleon" 55555 \
    "He's calm. Relaxed. Bright green. His color is his mood. Every emotion has its own shade. And he's about to get angry." \
    "Message sent. Message received. The rival backs down. His colors fade. Back to calm green. That's how chameleons talk." \
    "Chameleon (Furcifer pardalis) with turret-like independently rotating eyes, prehensile tail wrapped around branch, textured scaly skin, zygodactylous feet gripping branch, currently bright relaxed green coloration, sitting peacefully on tree branch, one eye rotating forward to spot intruder, tropical setting, macro detail showing scales and skin texture, no speech, ambient rainforest sounds" \
    "Chameleon (Furcifer pardalis) with turret-like independently rotating eyes, prehensile tail wrapped around branch, textured scaly skin, zygodactylous feet gripping branch, colors transitioning back to calm green, aggressive patterns fading, eyes rotating independently again (one forward, one back), relaxed posture returning, territorial display successful, winner on his branch, tropical setting, no speech, ambient rainforest sounds" \
    "Calm ambient tropical tones with soft marimba, peaceful rainforest atmosphere, Key: G Major, Tempo: 65 BPM" \
    "Triumphant but calm resolution, returning to peaceful marimba, conversation complete, Key: G Major, Tempo: 68 BPM"

generate_concept "monarch" "Monarch_Butterfly" 66666 \
    "She just emerged. Wings still drying. But deep inside, something ancient is calling. South. Three thousand miles south. And she's never been there." \
    "She made it. A forest in Mexico. Covered in millions of monarchs. She's never been here. But her great-great-grandparents were. And somehow, she found home." \
    "Monarch butterfly (Danaus plexippus) with distinctive orange wings with black veins and white spots along edges, perched on milkweed plant, wings fully spread but still wet from emergence, sun backlighting translucent wings, beautiful but fragile, preparing for impossible journey, macro close-up showing wing detail and scales, natural outdoor lighting, no speech, ambient meadow sounds" \
    "Monarch butterfly (Danaus plexippus) with distinctive orange wings with black veins and white spots along edges, landing on oyamel fir tree branch, thousands of other monarchs clustered on trees in background, trees literally covered in orange butterflies, sacred forest sanctuary, miracle of navigation complete, stunning congregation scene, warm golden light filtering through trees, no speech, ambient sounds of butterfly wings" \
    "Ethereal and mysterious, calling theme with distant woodwinds, journey beckons, Key: A minor, Tempo: 70 BPM" \
    "Majestic triumphant resolution with full orchestra, ancestral home theme, genetic memory fulfilled, Key: A Major, Tempo: 75 BPM"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ ALL 5 CONCEPTS COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
ls -lh *_16s.mp4 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'


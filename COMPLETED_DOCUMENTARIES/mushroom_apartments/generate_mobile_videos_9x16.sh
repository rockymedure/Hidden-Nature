#!/bin/bash
source ../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
mkdir -p mobile

echo "🎬 GENERATING MOBILE VIDEOS (9:16) - SCENES 2-26"
echo "⏭️  Skipping Scene 1 (Anju intro) for mobile version"
echo ""

# Visual descriptions for scenes 2-26 (Scene 1 skipped for mobile)
declare -a mobile_prompts=(
    # Scene 2
    "Dramatic time-lapse of single white mushroom growing from dark forest soil, starting as tiny pin emerging from moss, expanding rapidly into full dome shape, spores visible as faint mist in background, macro photography, shallow depth of field, rich browns and whites, morning dew catching light, 4K nature documentary quality, no speech, ambient only"
    
    # Scene 3
    "Extreme macro close-up of fresh pristine white mushroom cap, perfect unblemished surface with water droplets, soft texture visible, gentle morning light illuminating the mushroom from behind creating ethereal glow, forest floor blurred in background, professional macro photography, incredibly detailed, 9:16 portrait cinematic composition, no speech, ambient only"
    
    # Scene 4
    "Ultra macro shot of delicate fungus gnat landing on white mushroom cap, gnat's translucent wings catching light, long legs making contact with mushroom surface, iridescent compound eyes visible, shallow depth of field emphasizing the insect, naturalistic lighting, BBC Earth quality macro cinematography, 9:16 portrait format, no speech, ambient only"
    
    # Scene 5
    "Cross-section view inside mushroom showing tiny translucent white gnat larvae tunneling through pale mushroom tissue, creating visible pathways, soft internal lighting showing texture and structure, scientific illustration meets nature photography, detailed macro view showing both larvae and mushroom architecture, educational documentary style, 9:16 portrait, no speech, ambient only"
    
    # Scene 6
    "Glossy black forked fungus beetle with orange markings emerging from dark soil at base of mushroom, beetle climbing up white mushroom stem, high contrast between beetle's dark shell and pale mushroom, morning dew on both surfaces, extreme macro photography, shallow focus on beetle, dramatic side lighting, nature documentary quality, 9:16 portrait, no speech, ambient only"
    
    # Scene 7
    "Split-screen composition: left side shows intact mushroom exterior in soft focus, right side shows detailed cross-section revealing internal structure with multiple tunnels, chambers, and tiny residents visible inside, annotated like architectural blueprint but photorealistic, dramatic reveal, educational documentary visualization, 9:16 portrait cinematic, no speech, ambient only"
    
    # Scene 8
    "Large banana slug bright yellow with black spots approaching mushroom cluster, leaving glistening slime trail on dark moss, slug's tentacles extended exploring mushroom surface, morning light making slime trail sparkle, shallow depth of field with forest floor bokeh, intimate macro nature photography, rich colors and textures, Planet Earth cinematography style, 9:16 portrait, no speech, ambient only"
    
    # Scene 9
    "Extreme macro close-up of banana slug's mouth parts radula feeding on white mushroom gill surface, incredible detail showing texture of both slug and mushroom, visible bite marks and feeding action, scientific macro photography with dramatic lighting emphasizing the alien beauty of the interaction, National Geographic microscopic quality, 9:16 portrait, no speech, ambient only"
    
    # Scene 10
    "Ultra macro shot of tiny white springtails collembola moving across mushroom gill surface, their segmented bodies and antennae clearly visible, multiple individuals creating busy scene, shallow depth of field showing mushroom texture, scientific macro photography with soft natural lighting, documentary educational style showing behavior, 9:16 portrait format, no speech, ambient only"
    
    # Scene 11
    "Long red-brown centipede navigating through mushroom tunnels and over mushroom surface, many legs in coordinated motion, antennae probing, glossy segmented body catching light, dramatic macro cinematography from low angle making centipede appear formidable, dark background emphasizing movement, nature thriller documentary style, 4K quality, 9:16 portrait, no speech, ambient only"
    
    # Scene 12
    "Extreme macro of tiny pseudoscorpion hidden in mushroom gill chamber, pincers extended, waiting in ambush position, incredible detail showing its segmented body and claws, dramatic side lighting creating shadows and mystery, dark moody atmosphere, macro nature horror documentary aesthetic, incredibly detailed, 9:16 portrait cinematic, no speech, ambient only"
    
    # Scene 13
    "Adorable wood mouse with large dark eyes holding mushroom in tiny paws, sitting among underground mushroom larder cache, multiple mushrooms stored in small cavity, soft fur texture visible, warm underground lighting, intimate wildlife photography capturing charming behavior, shallow depth of field focusing on mouse, National Geographic quality, 9:16 portrait, no speech, ambient only"
    
    # Scene 14
    "Red squirrel hanging mushrooms on tree branches to dry, multiple mushrooms wedged in bark crevices and draped over branches, squirrel actively placing another mushroom, forest background softly blurred, golden afternoon light, wildlife behavior photography showing clever adaptation, charming and informative, BBC Earth style, 9:16 portrait format, no speech, ambient only"
    
    # Scene 15
    "Majestic deer in misty forest morning grazing on mushrooms growing on forest floor, soft ethereal lighting, deer's gentle face visible as it carefully selects mushrooms, fog creating dreamy atmosphere, shot showing deer in ancient forest context, professional wildlife cinematography, peaceful and beautiful, Planet Earth quality, 9:16 portrait cinematic, no speech, ambient only"
    
    # Scene 16 - SKIP (Anju on camera - would need image-to-video)
    "Large detailed mushroom cross-section showing internal complexity with visible tunnels and chambers, multiple species residents visible inside, scientific educational visualization, dramatic lighting emphasizing architectural nature of fungal structure, macro nature documentary photography, educational clarity, 9:16 portrait format, no speech, ambient only"
    
    # Scene 17
    "Underground visualization showing oyster mushroom mycelium with multiple ring-shaped snare structures catching nematode worms, educational scientific illustration style but photorealistic, glowing mycelial threads in dark soil, dramatic lighting emphasizing the predatory structures, nature documentary meets scientific visualization, 9:16 portrait cinematic, no speech, ambient only"
    
    # Scene 18
    "Extreme macro microscopic view of nematode worm caught in fungal noose ring, visible struggle, fungal structures constricting around worm's body, scientific macro photography with dramatic lighting, alien and beautiful, showing nature's precision and efficiency, educational documentary microscopy style, incredibly detailed, 9:16 portrait format, no speech, ambient only"
    
    # Scene 19
    "Haunting image of carpenter ant gripping branch with death grip, Ophiocordyceps fungus erupting from head and joints like alien growths, detailed macro showing both ant and fungal fruiting body, dark moody forest background, dramatic lighting emphasizing the grotesque beauty, nature horror documentary aesthetic, National Geographic quality, 9:16 portrait cinematic, no speech, ambient only"
    
    # Scene 20
    "Time-lapse showing infected ant's final journey: climbing upward on plant stem, reaching specific height, gripping, then death, with fungus beginning to emerge, scientific documentary visualization showing behavioral manipulation, eerie and fascinating, dramatic lighting showing progression, educational nature documentary style, 9:16 portrait format, no speech, ambient only"
    
    # Scene 21
    "Extreme macro of mature Cordyceps fungus releasing cloud of spores into air, spores visible as fine mist in shaft of forest sunlight, fruiting body in sharp focus with spore cloud creating ethereal effect, simultaneously beautiful and ominous, dramatic nature photography, high-speed capture of spore release, 4K documentary quality, 9:16 portrait, no speech, ambient only"
    
    # Scene 22
    "Dead fly stuck to top of grass blade or leaf tip, Entomophthora muscae fungus covering fly's body with white fungal growth, dramatic low angle shot making fly appear monumental, soft focus background, morning dew adding ethereal quality, macro nature documentary showing precise fungal behavior, eerie beauty, 9:16 portrait cinematic, no speech, ambient only"
    
    # Scene 23
    "Aging brown mushroom beginning to collapse, multiple insects beetles flies mites actively fleeing from deteriorating mushroom, time-lapse showing exodus, mushroom structure softening and darkening, macro photography capturing the bustling evacuation, dramatic change from fresh to decaying, nature documentary showing life cycle, 9:16 portrait format, no speech, ambient only"
    
    # Scene 24
    "Time-lapse of mushroom dissolving into black spore ink liquid, gills liquefying and dripping, spores visible as dark cloud dispersing, artistic and slightly abstract while remaining naturalistic, dramatic lighting emphasizing the transformation, beauty in decay, poetic nature cinematography, Planet Earth style, 9:16 portrait cinematic composition, no speech, ambient only"
    
    # Scene 25
    "Time-lapse showing new baby mushrooms sprouting from exact spot where old mushroom decomposed, life from death, multiple tiny mushroom pins emerging and growing, hopeful and beautiful, circular composition emphasizing renewal, warm lighting suggesting continuity of life, inspirational nature documentary cinematography, 9:16 portrait format, no speech, ambient only"
    
    # Scene 26 - SKIP (Anju on camera - would need image-to-video)
    "Close-up of field journal with mushroom sketches and notes, hand writing observations, mushroom specimens arranged beside journal on forest floor, natural afternoon forest light, authentic documentary moment of field research, professional but warm atmosphere, genuine scientific observation, educational documentary style, 9:16 portrait format, no speech, ambient only"
)

# Generate scenes 2-26 in parallel (skipping scenes with Anju on camera: 1, 16, 26)
for i in {1..24}; do
    scene=$((i + 1))  # Scene numbers 2-26
    prompt_idx=$((i - 1))  # Array is 0-indexed
    visual="${mobile_prompts[$prompt_idx]}"
    
    (
        echo "📱 Scene $scene: Generating mobile video (9:16)..."
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"prompt\": \"$visual\",
                \"aspect_ratio\": \"9:16\",
                \"duration\": 8,
                \"generate_audio\": false,
                \"resolution\": \"1080p\"
            }")
        
        video_url=$(echo "$response" | jq -r '.video.url // empty')
        if [[ -n "$video_url" ]]; then
            curl -s -o "mobile/scene${scene}.mp4" "$video_url"
            size=$(ls -lh "mobile/scene${scene}.mp4" | awk '{print $5}')
            echo "   ✅ Scene $scene: Mobile video saved ($size)"
        else
            echo "   ❌ Scene $scene: Failed to generate"
            echo "$response" | jq '.'
        fi
    ) &
    
    # Stagger API calls to avoid rate limits
    sleep 2
    
    # Process in batches of 10
    if (( i % 10 == 0 )); then
        wait
        echo ""
        echo "⏸️  Batch of 10 complete, continuing..."
        echo ""
    fi
done

wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ MOBILE VIDEO GENERATION COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Generated: 25 scenes (2-26) in native 9:16 format"
echo "⏭️  Skipped: Scene 1 (Anju intro)"
echo ""
echo "Next steps:"
echo "1. Run mix_mobile_scenes.sh to add narration + music"
echo "2. Run compile_mobile_documentary.sh for final 9:16 video"

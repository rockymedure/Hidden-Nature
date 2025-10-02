#!/bin/bash
# Generate complete 9:16 mobile version of The Mushroom Apartments
# Regenerates all 26 videos in portrait format optimized for mobile

set -e

cd /Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments

# Source environment
if [ -f .env ]; then
    source .env
elif [ -f ../../.env ]; then
    source ../../.env
else
    echo "❌ Error: .env file not found"
    exit 1
fi

echo "📱 GENERATING 9:16 MOBILE VERSION - THE MUSHROOM APARTMENTS"
echo "============================================================"
echo ""
echo "This will regenerate all 26 videos in 9:16 portrait format"
echo "Using the same narrations and music from the 16:9 version"
echo ""

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
IMAGE_TO_VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast/image-to-video"

# Create mobile directories
mkdir -p mushroom_videos_mobile
mkdir -p mushroom_responses_mobile
mkdir -p mushroom_mixed_mobile

# Scene 1 requires image-to-video (Anju)
echo "🎬 SCENE 1 (ANJU - IMAGE-TO-VIDEO)"
echo "==================================="

ANJU_IMAGE="cWEb-pSKb6a5uFaGFskFU.jpeg"
ANJU_DATA_URI=$(base64 "$ANJU_IMAGE" | awk '{printf "data:image/jpeg;base64,%s", $0}')

response=$(curl -s -X POST "$IMAGE_TO_VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
        \"prompt\": \"Young South Asian female scientist ANJU crouching on misty forest floor at dawn, surrounded by various mushrooms, holding magnifying glass, warm smile, curious expression, golden hour lighting filtering through ancient trees, camera at eye level showing both Anju and mushroom forest behind her, documentary photography style, National Geographic quality, vertical portrait 9:16 format, no speech, natural forest ambience\",
        \"image_url\": \"$ANJU_DATA_URI\",
        \"aspect_ratio\": \"9:16\",
        \"duration\": \"8s\",
        \"generate_audio\": true,
        \"resolution\": \"1080p\"
    }")

echo "$response" > "mushroom_responses_mobile/scene1_video.json"
video_url=$(echo "$response" | jq -r '.video.url')

if [[ -n "$video_url" && "$video_url" != "null" ]]; then
    curl -s -o "mushroom_videos_mobile/scene1.mp4" "$video_url"
    echo "✅ Scene 1: $(du -h mushroom_videos_mobile/scene1.mp4 | awk '{print $1}')"
else
    echo "❌ Scene 1 FAILED"
    exit 1
fi

echo ""
echo "🎬 GENERATING SCENES 2-26 (TEXT-TO-VIDEO)"
echo "=========================================="
echo ""

# All video prompts for scenes 2-26
declare -a prompts=(
    "" # Scene 1 already done
    "Dramatic time-lapse of single white mushroom growing from dark forest soil, starting as tiny pin emerging from moss, expanding rapidly into full dome shape, spores visible as faint mist in background, macro photography, shallow depth of field, rich browns and whites, morning dew catching light, vertical portrait 9:16 format, 4K nature documentary quality, no speech"
    "Extreme macro close-up of fresh pristine white mushroom cap, perfect unblemished surface with water droplets, soft texture visible, gentle morning light illuminating the mushroom from behind creating ethereal glow, forest floor blurred in background, professional macro photography, incredibly detailed, vertical portrait 9:16 cinematic composition, no speech"
    "Ultra macro shot of delicate fungus gnat landing on white mushroom cap, gnat's translucent wings catching light, long legs making contact with mushroom surface, iridescent compound eyes visible, shallow depth of field emphasizing the insect, naturalistic lighting, BBC Earth quality macro cinematography, vertical 9:16 format, no speech"
    "Cross-section view inside mushroom showing tiny translucent white gnat larvae tunneling through pale mushroom tissue, creating visible pathways, soft internal lighting showing texture and structure, scientific illustration meets nature photography, detailed macro view showing both larvae and mushroom architecture, educational documentary style, vertical 9:16, no speech"
    "Glossy black forked fungus beetle with orange markings emerging from dark soil at base of mushroom, beetle climbing up white mushroom stem, high contrast between beetle's dark shell and pale mushroom, morning dew on both surfaces, extreme macro photography, shallow focus on beetle, dramatic side lighting, nature documentary quality, vertical portrait 9:16, no speech"
    "Split-screen composition: top shows intact mushroom exterior in soft focus, bottom shows detailed cross-section revealing internal structure with multiple tunnels, chambers, and tiny residents (beetles, larvae, mites) visible inside, annotated like architectural blueprint but photorealistic, dramatic reveal, educational documentary visualization, vertical 9:16 cinematic, no speech"
    "Large banana slug (bright yellow with black spots) approaching mushroom cluster, leaving glistening slime trail on dark moss, slug's tentacles extended exploring mushroom surface, morning light making slime trail sparkle, shallow depth of field with forest floor bokeh, intimate macro nature photography, rich colors and textures, Planet Earth cinematography style, vertical portrait 9:16, no speech"
    "Extreme macro close-up of banana slug's mouth parts (radula) feeding on white mushroom gill surface, incredible detail showing texture of both slug and mushroom, visible bite marks and feeding action, scientific macro photography with dramatic lighting emphasizing the alien beauty of the interaction, National Geographic microscopic quality, vertical 9:16, no speech"
    "Ultra macro shot of tiny white springtails (collembola) moving across mushroom gill surface, their segmented bodies and antennae clearly visible, multiple individuals creating busy scene, shallow depth of field showing mushroom texture, scientific macro photography with soft natural lighting, documentary educational style showing behavior, vertical portrait 9:16 format, no speech"
    "Long red-brown centipede navigating through mushroom tunnels and over mushroom surface, many legs in coordinated motion, antennae probing, glossy segmented body catching light, dramatic macro cinematography from low angle making centipede appear formidable, dark background emphasizing movement, nature thriller documentary style, 4K quality, vertical 9:16, no speech"
    "Extreme macro of tiny pseudoscorpion hidden in mushroom gill chamber, pincers extended, waiting in ambush position, incredible detail showing its segmented body and claws, dramatic side lighting creating shadows and mystery, dark moody atmosphere, macro nature horror documentary aesthetic, incredibly detailed, vertical portrait 9:16 cinematic, no speech"
    "Adorable wood mouse with large dark eyes holding mushroom in tiny paws, sitting among underground mushroom larder/cache, multiple mushrooms stored in small cavity, soft fur texture visible, warm underground lighting, intimate wildlife photography capturing charming behavior, shallow depth of field focusing on mouse, National Geographic quality, vertical 9:16, no speech"
    "Red squirrel hanging mushrooms on tree branches to dry, multiple mushrooms wedged in bark crevices and draped over branches, squirrel actively placing another mushroom, forest background softly blurred, golden afternoon light, wildlife behavior photography showing clever adaptation, charming and informative, BBC Earth style, vertical portrait 9:16 format, no speech"
    "Majestic deer in misty forest morning grazing on mushrooms growing on forest floor, soft ethereal lighting, deer's gentle face visible as it carefully selects mushrooms, fog creating dreamy atmosphere, shot showing deer in ancient forest context, professional wildlife cinematography, peaceful and beautiful, Planet Earth quality, vertical portrait 9:16 cinematic, no speech"
    "Anju kneels by a tree, examining large mushroom cross-section, her face showing wonder and concentration, cross-section visible showing internal complexity, soft forest lighting, documentary moment capturing scientific curiosity, shot showing both Anju and specimen, educational documentary photography style, natural and authentic, vertical 9:16 format, no speech, ambient forest sounds only"
    "Underground visualization showing oyster mushroom mycelium with multiple ring-shaped snare structures catching nematode worms, educational scientific illustration style but photorealistic, glowing mycelial threads in dark soil, dramatic lighting emphasizing the predatory structures, nature documentary meets scientific visualization, vertical portrait 9:16 cinematic, no speech"
    "Extreme macro microscopic view of nematode worm caught in fungal noose/ring, visible struggle, fungal structures constricting around worm's body, scientific macro photography with dramatic lighting, alien and beautiful, showing nature's precision and efficiency, educational documentary microscopy style, incredibly detailed, vertical 9:16 format, no speech"
    "Haunting image of carpenter ant gripping branch with death grip, Ophiocordyceps fungus erupting from head and joints like alien growths, detailed macro showing both ant and fungal fruiting body, dark moody forest background, dramatic lighting emphasizing the grotesque beauty, nature horror documentary aesthetic, National Geographic quality, vertical portrait 9:16 cinematic, no speech"
    "Time-lapse showing infected ant's final journey: climbing upward on plant stem, reaching specific height, gripping, then death, with fungus beginning to emerge, scientific documentary visualization showing behavioral manipulation, eerie and fascinating, dramatic lighting showing progression, educational nature documentary style, vertical 9:16 format, no speech"
    "Extreme macro of mature Cordyceps fungus releasing cloud of spores into air, spores visible as fine mist in shaft of forest sunlight, fruiting body in sharp focus with spore cloud creating ethereal effect, simultaneously beautiful and ominous, dramatic nature photography, high-speed capture of spore release, 4K documentary quality, vertical portrait 9:16, no speech"
    "Dead fly stuck to top of grass blade or leaf tip, Entomophthora muscae fungus covering fly's body with white fungal growth, dramatic low angle shot making fly appear monumental, soft focus background, morning dew adding ethereal quality, macro nature documentary showing precise fungal behavior, eerie beauty, vertical 9:16 cinematic, no speech"
    "Aging brown mushroom beginning to collapse, multiple insects (beetles, flies, mites) actively fleeing from deteriorating mushroom, time-lapse showing exodus, mushroom structure softening and darkening, macro photography capturing the bustling evacuation, dramatic change from fresh to decaying, nature documentary showing life cycle, vertical 9:16 format, no speech"
    "Time-lapse of mushroom dissolving into black spore ink/liquid, gills liquefying and dripping, spores visible as dark cloud dispersing, artistic and slightly abstract while remaining naturalistic, dramatic lighting emphasizing the transformation, beauty in decay, poetic nature cinematography, Planet Earth style, vertical portrait 9:16 cinematic composition, no speech"
    "Time-lapse showing new baby mushrooms sprouting from exact spot where old mushroom decomposed, life from death, multiple tiny mushroom pins emerging and growing, hopeful and beautiful, circular composition emphasizing renewal, warm lighting suggesting continuity of life, inspirational nature documentary cinematography, vertical 9:16 format, no speech"
    "Anju crouched beside mushroom cluster taking field notes in journal, natural afternoon forest light filtering through canopy, authentic documentary moment capturing real field research, she writes and occasionally looks at specimens, professional but warm atmosphere, genuine scientific observation, shot showing Anju and surrounding forest floor ecosystem, vertical 9:16 format emphasizing authentic documentary style, no speech, ambient forest sounds only"
)

# Generate all scenes 2-26 in parallel
for i in {2..26}; do
    (
        prompt="${prompts[$i]}"
        echo "  🎬 Scene $i: Generating..."
        
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{
                \"prompt\": \"$prompt\",
                \"aspect_ratio\": \"9:16\",
                \"duration\": \"8s\",
                \"generate_audio\": true,
                \"resolution\": \"1080p\"
            }")
        
        echo "$response" > "mushroom_responses_mobile/scene${i}_video.json"
        video_url=$(echo "$response" | jq -r '.video.url')
        
        if [[ -n "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "mushroom_videos_mobile/scene${i}.mp4" "$video_url"
            echo "  ✅ Scene $i: $(du -h mushroom_videos_mobile/scene${i}.mp4 | awk '{print $1}')"
        else
            echo "  ❌ Scene $i FAILED"
        fi
    ) &
    
    # Limit to 5 concurrent generations
    if (( i % 5 == 0 )); then
        wait
    fi
done

wait

echo ""
echo "✅ ALL 26 MOBILE VIDEOS GENERATED!"
echo ""
echo "🔊 MIXING ALL SCENES (VIDEO + NARRATION + MUSIC)"
echo "================================================="
echo ""

# Mix all 26 scenes with audio and music
for scene in {1..26}; do
    VIDEO_FILE="mushroom_videos_mobile/scene${scene}.mp4"
    NARRATION_FILE="mushroom_audio/scene${scene}.mp3"
    MUSIC_FILE="mushroom_music/scene${scene}_music.wav"
    MIXED_OUTPUT="mushroom_mixed_mobile/scene${scene}_mixed.mp4"
    
    echo "🔊 Scene $scene: Mixing..."
    
    ffmpeg -y -i "$VIDEO_FILE" \
              -i "$NARRATION_FILE" \
              -i "$MUSIC_FILE" \
        -filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.15[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
        -map 0:v -map "[audio]" \
        -c:v copy -c:a aac -ac 1 -ar 44100 \
        "$MIXED_OUTPUT" 2>/dev/null
    
    echo "  ✅ Scene $scene mixed"
done

echo ""
echo "✅ All scenes mixed!"
echo ""
echo "🎬 COMPILING FINAL 9:16 MOBILE VIDEO"
echo "====================================="
echo ""

# Create playlist
MOBILE_PLAYLIST="mushroom_mobile_playlist.txt"
> "$MOBILE_PLAYLIST"
for scene in {1..26}; do
    echo "file 'mushroom_mixed_mobile/scene${scene}_mixed.mp4'" >> "$MOBILE_PLAYLIST"
done

# Compile final mobile video
FINAL_MOBILE="THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4"
ffmpeg -y -f concat -safe 0 -i "$MOBILE_PLAYLIST" -c copy "$FINAL_MOBILE" 2>/dev/null

echo ""
echo "📱 ========================================== 📱"
echo "   MOBILE VERSION COMPLETE!"
echo "📱 ========================================== 📱"
echo ""

if [[ -f "$FINAL_MOBILE" ]]; then
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FINAL_MOBILE" 2>/dev/null | cut -d. -f1)
    filesize=$(ls -lh "$FINAL_MOBILE" | awk '{print $5}')
    
    echo "📊 Mobile Documentary:"
    echo "   File: $FINAL_MOBILE"
    echo "   Duration: $((duration / 60))m $((duration % 60))s"
    echo "   Size: $filesize"
    echo "   Format: 9:16 (1080x1920)"
    echo "   Scenes: 26"
    echo ""
    echo "📱 Optimized for:"
    echo "   • Instagram Reels"
    echo "   • TikTok"
    echo "   • YouTube Shorts"
    echo ""
    echo "✨ Ready for mobile upload!"
else
    echo "❌ Mobile compilation failed"
fi

echo ""


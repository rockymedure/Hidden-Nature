#!/bin/bash

# Generate missing 16:9 videos (Scenes 9-24)

set -e
cd "$(dirname "$0")" || exit 1

source ../../.env
if [ -z "$FAL_API_KEY" ]; then
    echo "❌ ERROR: FAL_API_KEY not found in .env"
    exit 1
fi

echo "🎥 GENERATING MISSING 16:9 VIDEOS (Scenes 9-24)"
echo "══════════════════════════════════════════════"
echo ""

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

declare -a visuals=(
    ""  # placeholder for index 0
    ""  # Scene 1 (already done)
    ""  # Scene 2 (already done)
    ""  # Scene 3 (already done)
    ""  # Scene 4 (already done)
    ""  # Scene 5 (already done)
    ""  # Scene 6 (already done)
    ""  # Scene 7 (already done)
    ""  # Scene 8 (already done)
    "Extreme macro close-up of blue poison dart frog (Dendrobates azureus) sitting on bright green leaf in rainforest. Frog's skin is electric blue with bold black spots, colors so vivid they appear almost iridescent. Skin glistens with moisture droplets that catch light. Camera slowly pushes in on the spotted pattern, then tilts up to show frog's large dark eye with perfect reflection of leaf in it. Shallow depth of field keeps frog in sharp focus while background fades to soft green and brown bokeh. Humid rainforest atmosphere, water droplets visible in air, professional macro photography, colors saturated but natural, warning colors clearly displayed."
    "Red ladybug with seven black spots crawling up bright green plant stem in garden setting. Macro shot shows incredible detail of ladybug's shiny red shell. Small bird (sparrow or warbler) enters frame from right side, head moving closer to examine the ladybug as potential food. Bird's beak gets within inches of ladybug, then bird suddenly jerks head back and retreats out of frame, recognizing the warning pattern. Ladybug continues crawling unbothered up the stem. Natural outdoor lighting, green foliage background softly blurred, sharp focus on ladybug and bird interaction, behavioral documentary style showing learned predator avoidance."
    "Adorable cheetah cub (2-3 months old) walking through golden savanna grass in late afternoon. Cub has distinctive silver-gray mantle of long fur along its back and head, with dark spots visible on the mantle creating striped appearance similar to honey badger. Camera tracks alongside cub at low angle showing mantle detail as cub walks with uncertain kitten-like steps. Mantle fur catches golden sunlight making silver coloring glow. Adult female cheetah visible but slightly out of focus in background. Tall dry grass sways in gentle breeze, warm golden hour lighting, professional wildlife cinematography, cute but also showing protective adaptation, African savanna environment."
    "Artistic montage transition sequence flowing from warning-colored animals to social spotted animals. Begins with close-up of blue poison dart frog's spots, then seamlessly morphs/dissolves into red ladybug's spots, then to cheetah cub's mantle spots, finally transitioning into the distinctive reticulated pattern of giraffe skin. Each transition uses spot patterns as visual bridge - spots stay in similar screen positions while animal identity changes around them. Final shot widens to show three giraffes standing together, introducing the social/identity theme. Smooth artistic transitions, natural documentary footage blended with motion graphics, warm color palette, professional editing."
    "Three reticulated giraffes standing close together in African savanna at watering hole, shot from elevated angle showing their backs and spot patterns clearly. Camera slowly pans across all three, emphasizing the dramatically different spot patterns. First giraffe has large irregular brown patches separated by cream lines, second has smaller more rounded spots in tighter pattern, third has angular geometric patches. Sun is at angle creating contrast that makes spot patterns highly visible. Giraffes are calm, occasionally moving necks to interact with each other. Acacia trees in background, blue sky, professional wildlife documentary cinematography showing uniqueness of each individual."
    "Spotted hyena clan of four adults at dusk in African savanna, warm orange-pink twilight sky. Each hyena has distinct spot pattern - some with large dark spots, others with smaller scattered spots. Hyenas approach each other in social greeting ritual, sniffing and nuzzling. Camera captures medium shot showing multiple animals interacting, then cuts to close-up of two hyenas face-to-face. Spots clearly visible on their sandy-brown coats despite low light. Social bonds evident in body language. Dust particles visible in air catching last sunlight, atmospheric and intimate, professional wildlife documentary style capturing social behavior."
    "African wild dog pack of five running together through golden savanna grassland in coordinated movement. Each dog has unique tri-color coat pattern of black, brown, and white patches creating spotted appearance. Camera tracks laterally alongside pack at medium distance showing full body movement. Dogs run in loose formation, constantly adjusting positions while keeping pack cohesion. Their distinctive colorful coats make each individual instantly recognizable even in motion blur. Grass bends in their wake, dust kicks up slightly from paws. Shot at 60fps for smooth motion, natural afternoon lighting, dynamic energy, professional wildlife action cinematography, shows coordination and teamwork."
    "Split-screen or picture-in-picture artistic composition showing transformation of spots over time. Left/top half shows white-tailed deer fawn with prominent white spots on reddish coat in summer forest. Right/bottom half shows same species as juvenile with fading spots barely visible, then adult deer with solid brown coat and no spots. Both animals in similar forest setting for comparison. Could also show peacock flounder changing patterns, or jaguar cub to adult progression. Smooth transition between life stages, educational graphics subtle but clear, natural footage, professional documentary editing showing biological change over time."
    "Side-by-side comparison sequence of white-tailed deer at three life stages, all in temperate forest environment. Begins with 2-month-old fawn with bright white spots prominent on reddish-brown summer coat, lying in grass. Transitions to 8-month juvenile standing, spots significantly faded and barely visible on now brown coat. Final shot shows adult doe with solid brown coat and no spots whatsoever. Each stage shows same species in same type of forest setting for clear comparison. Smooth dissolve transitions between ages, educational yet artistic, natural lighting, professional wildlife documentary style showing biological development from camouflage-dependent youth to self-sufficient adult."
    "Peacock flounder on ocean floor actively demonstrating spot-changing ability. Starts positioned on fine sandy bottom with small scattered brown spots matching sand grain pattern, body slightly buried. Flounder suddenly swims in undulating motion across seafloor toward rocky coral area. As it swims, skin begins rippling with color changes. Settles onto coral rubble area with mixed purple, orange, and brown rocks. Within seconds, spots transform - growing larger and darker, spacing increases, colors shift to match new rocky background. Time slightly compressed to show dramatic transformation clearly. Crystal clear underwater visibility, natural light from above, close-up angle showing detail of spots morphing, professional underwater cinematography capturing remarkable adaptation."
    "Two-part sequence showing jaguar spot evolution from cub to adult. First half shows jaguar cub (3-4 months old) with soft blurry rosette patterns, spots merge together creating less distinct pattern, cub playing or walking through jungle undergrowth. Smooth transition to adult jaguar with crisp sharply-defined rosette spots - each rosette is clear ring with black outline and tan center, spots perfectly distinct against golden coat. Adult jaguar walks with powerful confident movement through same jungle setting, muscles rippling under spotted coat. Spots catch dappled sunlight filtering through rainforest canopy. Both shots in lush green tropical forest, natural lighting, professional big cat cinematography showing maturation of predator adaptation."
    "Mysterious artistic sequence showing unusual spot patterns that don't immediately make sense. Extreme close-up of spots that slowly pulls back - camera starts on pattern that looks like random spots or dots, low key dramatic lighting creating shadows and mystery. As camera pulls back, spots begin to take on unexpected form - perhaps reveals they are butterfly wing eyespots, or spots on an inflated pufferfish, or other deceptive spot usage. Shallow depth of field keeps some elements blurred, creating visual intrigue. Lighting is dramatic with single light source creating strong shadows. Artistic nature cinematography building suspense and curiosity for the deception theme, documentary style with artistic flair."
    "Owl butterfly (Caligo species) resting on tree bark with wings closed, showing brown camouflage coloring. Camera close-up on butterfly. Suddenly butterfly opens wings in defensive display, revealing enormous eyespots on lower wings that look exactly like owl's eyes. Camera pushes in to extreme macro on one eyespot showing incredible detail - black pupil in center, lighter iris ring, curved highlight making it look three-dimensional and reflective like real eye. Eyespot has texture and shading that creates realistic depth. Humid tropical forest background softly blurred, natural diffused light, professional macro cinematography, dramatic reveal showing defensive mimicry adaptation."
    "Spotted porcupine pufferfish swimming normally in coral reef environment, showing distinctive spotted pattern of black spots on tan-yellow body. Fish has curious expression with large eyes. Small predator fish (grouper or snapper) approaches from background investigating. As predator gets close, pufferfish suddenly inflates into round spiky ball, expanding to several times original size. Spots stretch and spread across expanded skin, creating disorienting visual pattern. Predator fish backs away confused and deterred. Pufferfish slowly deflates back to normal size. Crystal clear underwater visibility, vibrant reef background, natural underwater lighting, professional marine life cinematography showing defensive behavior and spot pattern distortion."
    "Beautiful flowing montage of all featured spotted animals from the documentary compiled into artistic celebration sequence. Quick cuts (0.3-0.5 sec each) or smooth dissolve transitions showing: fawn in forest, snow leopard on cliff, octopus changing colors, spotted ray on sand, blue poison dart frog, red ladybug, cheetah cub, giraffe herd, spotted hyenas, wild dog pack, peacock flounder, jaguar, owl butterfly eyespots, pufferfish. Each animal shown in their signature moment from earlier scenes. Camera movements match between cuts creating flow. All natural lighting appropriate to each environment. Final compilation could overlay spots to show pattern diversity. Uplifting and celebratory tone, professional documentary editing, showcasing biodiversity."
    "Majestic hero shot of single snow leopard standing on high mountain cliff edge at sunset, thick tail curled around body. Gray rosette spots clearly visible on luxurious fur. Golden-orange sunset light from behind creates glowing rim light around the cat's silhouette while still illuminating spots. Camera starts close on leopard's face showing piercing light-colored eyes, then slowly pulls back and cranes up, revealing more of the leopard, then the massive cliff face, then the vast Himalayan mountain range in background with snow-covered peaks glowing in sunset colors. Misty valleys below. Epic scale showing nature's grandeur. Leopard occasionally glances around, calm and majestic. Cinematic documentary finale, David Attenborough-level production value, inspiring and beautiful."
)

# Generate scenes 9-24
for i in {9..24}; do
    scene=$i
    visual="${visuals[$i]}"
    output_file="videos/scene${scene}.mp4"

    echo "🎥 Generating Scene $scene (16:9)..."

    response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
        -H "Authorization: Key $FAL_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"prompt\": \"$visual\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\"}")

    video_url=$(echo "$response" | jq -r '.video.url // empty')
    if [[ -n "$video_url" ]]; then
        curl -s -o "$output_file" "$video_url"
        echo "✅ Scene $scene: Video generated"
    else
        echo "❌ Scene $scene: Failed to generate"
    fi

    sleep 1
done

echo ""
echo "✨ 16:9 VIDEO GENERATION COMPLETE!"
echo ""
echo "Now run audio mixing for these scenes..."

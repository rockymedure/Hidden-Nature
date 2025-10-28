#!/bin/bash

# ========================================
# MASTER PRODUCTION ORCHESTRATOR
# Nature's Polka Dots - Hidden Beauty Series
# PARALLEL EXECUTION: Narrations + Videos (16:9) + Videos (9:16) + Music
# FINAL OUTPUT: YouTube 16:9 + TikTok 9:16 + Highlights (16/24s segments)
# ========================================

set -e
cd "$(dirname "$0")" || exit 1

# Load environment
source ../../.env
if [ -z "$FAL_API_KEY" ]; then
    echo "❌ ERROR: FAL_API_KEY not found in .env"
    exit 1
fi

echo "🎬 STARTING MASTER PRODUCTION ORCHESTRATOR"
echo "═══════════════════════════════════════════"
echo "Project: Nature's Polka Dots"
echo "Narrator: Rachel (warm, wonder-filled)"
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
    source ../../.env
    NARRATOR="Rachel"
    AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

    declare -a narrations=(
        "From the forest floor to the ocean deep, nature has painted the world with one of its favorite patterns: spots."
        "But these polka dots aren't just decoration. Each spot is a tool, engineered by evolution for survival."
        "From microscopic markings on a ladybug's back to the towering patches on a giraffe, spots come in every size and serve countless purposes."
        "In dappled sunlight, a fawn's spots perform their first job: breaking up its outline to fool predators searching for a meal."
        "High in the Himalayas, the snow leopard's gray rosettes mirror the rocky cliffs, making the world's most elusive cat nearly invisible."
        "The octopus takes spot camouflage to another level, creating and erasing spots in seconds to match any background."
        "The spotted eagle ray settles into the sand, burying everything but its spots, which predators mistake for harmless pebbles."
        "But not all spots are meant to hide. Some spots scream the exact opposite message: notice me, and stay away."
        "The poison dart frog's electric blue spots deliver a chemical warning: these bright markings mean deadly toxins lie beneath."
        "A ladybug's red spots work the same way. Predators who've tasted one never forget, and those spots become a universal stop sign."
        "Cheetah cubs wear a silver mantle of spots on their backs, mimicking the dangerous honey badger to keep predators at bay."
        "But spots don't just warn or hide. They can also tell stories, carrying messages meant only for their own kind."
        "Every giraffe's spot pattern is unique, like a fingerprint. No two giraffes have ever worn the same design."
        "Spotted hyenas use their markings to recognize clan members in the dark, each pattern a personal calling card in their society."
        "African wild dogs rely on their painted coats to track pack members during the chaos of a hunt."
        "And some of nature's most fascinating spots are temporary, appearing when needed and vanishing when their job is done."
        "A fawn's spots fade as it grows. Once strong enough to outrun danger, it no longer needs to hide."
        "The peacock flounder rewrites its spots daily, adjusting size, color, and spacing to match whatever surface it settles on."
        "A jaguar's rosettes blur together as a cub, but sharpen into distinct circles as it masters the art of ambush hunting."
        "But evolution's most creative use of spots isn't for identity or camouflage. It's for trickery and deception."
        "The owl butterfly's wing spots aren't decoration, they're fake eyes designed to startle predators into thinking they're facing something much larger."
        "A pufferfish's spots scramble predators' depth perception, making it impossible to judge size or distance before it inflates into a spiky ball."
        "From camouflage to warning, identity to illusion, spots are evolution's Swiss Army knife, solving hundreds of problems with one simple pattern."
        "So the next time you see spots in nature, remember: you're looking at millions of years of innovation, painted in polka dots."
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
    source ../../.env
    VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

    declare -a visuals=(
        "Extreme close-up macro photography montage of spotted patterns in nature. Camera slowly pans across butterfly wing with vibrant orange and black spots, then smooth transition to giraffe skin texture showing brown patches on cream background, then to blue poison dart frog's spotted back, finally to leopard's golden rosette pattern. Golden hour lighting makes each spot glow with warm backlighting. Ultra-detailed texture, shallow depth of field creating artistic blur, colors vivid and saturated. Cinematic nature documentary style, smooth camera movement, each pattern fills frame completely showing intricate detail."
        "Camera starts on abstract spotted pattern filling frame, soft focus on individual spots with blurred background. Slowly camera pulls back while simultaneously bringing animal into focus, revealing the spots belong to a leopard lying in dappled forest sunlight. As camera reaches full body view, leopard makes subtle movement - ear twitch or head turn - suddenly making the camouflage obvious. Dappled light through jungle canopy creates natural spot pattern on ground matching leopard's coat. Slow motion at 60fps, natural forest lighting with sun rays streaming through leaves, green foliage background."
        "Dynamic scale comparison sequence starting with extreme macro shot of tiny red ladybug with seven black spots on green leaf, camera dramatically zooms out revealing the leaf is part of a flowering plant, continues pulling back to show a monarch butterfly with orange and black spotted wings resting nearby, keeps zooming to reveal a white-tailed deer fawn with white spots lying in grass, finally pulls back to full wide shot showing massive giraffe walking past with towering spotted pattern. All animals in same natural savanna-woodland environment. Smooth continuous zoom out, natural daylight, clear blue sky background, professional nature documentary cinematography."
        "White-tailed deer fawn lying perfectly still in forest undergrowth surrounded by ferns and fallen leaves. Dappled sunlight filters through oak tree canopy creating moving patches of light and shadow across the scene. Fawn's white spots on reddish-brown coat match the light patterns exactly. Camera starts wide showing just foliage, then slowly pushes in and pans right, suddenly revealing the camouflaged fawn that was hidden in plain sight. Fawn remains motionless except for gentle breathing, large dark eyes alert. Natural forest sounds, soft focus background, sharp focus on fawn, documentary realism."
        "Snow leopard with thick gray fur and black rosette spots walking gracefully across steep rocky mountain cliff face in the Himalayas. Rocky terrain is gray granite with patches of white snow, perfectly matching the leopard's coat pattern. Camera tracks the leopard from side angle as it moves from left to right across frame. Leopard pauses mid-stride against rocks, becoming nearly invisible - spots and gray fur blending with stone texture and snow patches. Then takes another step and outline becomes visible again. Misty mountain background, overcast lighting creating soft shadows, professional wildlife cinematography, majestic and mysterious mood."
        "Caribbean reef octopus on colorful coral reef ocean floor actively changing its skin pattern in real-time. Octopus starts on sandy bottom with small brown spots matching sand grains, then moves tentacles-first across seafloor toward coral structure. As it moves, skin ripples with waves of color change - spots appear and disappear, size and density shifting to match new background. Lands on purple and orange coral, skin immediately transforms to blotchy pattern with colors matching coral. Captured at 60fps slow motion showing mesmerizing color morphing ability. Crystal clear underwater visibility, natural underwater lighting with sun rays penetrating from surface, vibrant reef colors, documentary quality."
        "Spotted eagle ray with distinctive white spots on dark blue-black back gracefully gliding through crystal clear tropical ocean water. Long whip-like tail trails behind. Ray descends toward sandy seafloor in gentle gliding motion, wings undulating smoothly. As it reaches bottom, flutters wing edges creating small sand clouds, partially burying itself in sand. Final position shows only the spotted back visible above sand surface, looking exactly like a collection of small white pebbles scattered on tan sand. Sunlight streams from above creating rippling light patterns on sand. Peaceful underwater scene, natural movement, professional underwater documentary cinematography."
        "Artistic transition sequence from muted camouflage to vibrant warning colors. Starts with close-up of spotted eagle ray's white spots on dark background slowly fading to black. From the darkness, electric blue begins to glow, growing brighter. Camera pulls back revealing brilliant blue and black pattern belongs to a poison dart frog. Dramatic reveal as frog's full body comes into focus sitting on vibrant green rainforest leaf, colors incredibly vivid and saturated. Lighting shifts from cool underwater blue-green to warm humid rainforest green. Smooth dissolve transition, artistic and dramatic, building anticipation for the warning colors theme."
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

    for i in {0..23}; do
        scene=$((i + 1))
        visual="${visuals[$i]}"
        output_file="videos/scene${scene}.mp4"

        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$visual\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\"}")

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
    source ../../.env
    VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

    declare -a visuals=(
        "Extreme close-up macro photography montage of spotted patterns in nature. Camera slowly pans across butterfly wing with vibrant orange and black spots, then smooth transition to giraffe skin texture showing brown patches on cream background, then to blue poison dart frog's spotted back, finally to leopard's golden rosette pattern. Golden hour lighting makes each spot glow with warm backlighting. Ultra-detailed texture, shallow depth of field creating artistic blur, colors vivid and saturated. Cinematic nature documentary style, smooth camera movement, each pattern fills frame completely showing intricate detail."
        "Camera starts on abstract spotted pattern filling frame, soft focus on individual spots with blurred background. Slowly camera pulls back while simultaneously bringing animal into focus, revealing the spots belong to a leopard lying in dappled forest sunlight. As camera reaches full body view, leopard makes subtle movement - ear twitch or head turn - suddenly making the camouflage obvious. Dappled light through jungle canopy creates natural spot pattern on ground matching leopard's coat. Slow motion at 60fps, natural forest lighting with sun rays streaming through leaves, green foliage background."
        "Dynamic scale comparison sequence starting with extreme macro shot of tiny red ladybug with seven black spots on green leaf, camera dramatically zooms out revealing the leaf is part of a flowering plant, continues pulling back to show a monarch butterfly with orange and black spotted wings resting nearby, keeps zooming to reveal a white-tailed deer fawn with white spots lying in grass, finally pulls back to full wide shot showing massive giraffe walking past with towering spotted pattern. All animals in same natural savanna-woodland environment. Smooth continuous zoom out, natural daylight, clear blue sky background, professional nature documentary cinematography."
        "White-tailed deer fawn lying perfectly still in forest undergrowth surrounded by ferns and fallen leaves. Dappled sunlight filters through oak tree canopy creating moving patches of light and shadow across the scene. Fawn's white spots on reddish-brown coat match the light patterns exactly. Camera starts wide showing just foliage, then slowly pushes in and pans right, suddenly revealing the camouflaged fawn that was hidden in plain sight. Fawn remains motionless except for gentle breathing, large dark eyes alert. Natural forest sounds, soft focus background, sharp focus on fawn, documentary realism."
        "Snow leopard with thick gray fur and black rosette spots walking gracefully across steep rocky mountain cliff face in the Himalayas. Rocky terrain is gray granite with patches of white snow, perfectly matching the leopard's coat pattern. Camera tracks the leopard from side angle as it moves from left to right across frame. Leopard pauses mid-stride against rocks, becoming nearly invisible - spots and gray fur blending with stone texture and snow patches. Then takes another step and outline becomes visible again. Misty mountain background, overcast lighting creating soft shadows, professional wildlife cinematography, majestic and mysterious mood."
        "Caribbean reef octopus on colorful coral reef ocean floor actively changing its skin pattern in real-time. Octopus starts on sandy bottom with small brown spots matching sand grains, then moves tentacles-first across seafloor toward coral structure. As it moves, skin ripples with waves of color change - spots appear and disappear, size and density shifting to match new background. Lands on purple and orange coral, skin immediately transforms to blotchy pattern with colors matching coral. Captured at 60fps slow motion showing mesmerizing color morphing ability. Crystal clear underwater visibility, natural underwater lighting with sun rays penetrating from surface, vibrant reef colors, documentary quality."
        "Spotted eagle ray with distinctive white spots on dark blue-black back gracefully gliding through crystal clear tropical ocean water. Long whip-like tail trails behind. Ray descends toward sandy seafloor in gentle gliding motion, wings undulating smoothly. As it reaches bottom, flutters wing edges creating small sand clouds, partially burying itself in sand. Final position shows only the spotted back visible above sand surface, looking exactly like a collection of small white pebbles scattered on tan sand. Sunlight streams from above creating rippling light patterns on sand. Peaceful underwater scene, natural movement, professional underwater documentary cinematography."
        "Artistic transition sequence from muted camouflage to vibrant warning colors. Starts with close-up of spotted eagle ray's white spots on dark background slowly fading to black. From the darkness, electric blue begins to glow, growing brighter. Camera pulls back revealing brilliant blue and black pattern belongs to a poison dart frog. Dramatic reveal as frog's full body comes into focus sitting on vibrant green rainforest leaf, colors incredibly vivid and saturated. Lighting shifts from cool underwater blue-green to warm humid rainforest green. Smooth dissolve transition, artistic and dramatic, building anticipation for the warning colors theme."
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

    for i in {0..23}; do
        scene=$((i + 1))
        visual="${visuals[$i]}"
        output_file="videos_9x16/scene${scene}.mp4"

        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$visual\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\"}")

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
    source ../../.env
    MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"

    declare -a music_prompts=(
        "Gentle strings with wonder, opening theme establishing curiosity, C Major, 65 BPM, discovery mood"
        "Building strings with purpose, evolution theme emerging, C Major, 70 BPM, revelation"
        "Expanding orchestration showing scale and diversity, C Major, 75 BPM, wonder growing"
        "Soft strings with subtle percussion, forest atmosphere, C Major, 70 BPM, hiding theme"
        "Mountain mood, ethereal strings, mysterious, C Major, 65 BPM, elusive beauty"
        "Fluid underwater theme, morphing harmonies, C Major, 70 BPM, transformation"
        "Gentle ocean theme, peaceful settling, C Major, 65 BPM, calm concealment"
        "Transition building tension, shift from soft to bold, C Major, 75 BPM, plot twist"
        "Bold vibrant theme, warning colors in music, C Major, 80 BPM, danger beauty"
        "Playful but assertive, nature's stop sign, C Major, 75 BPM, learned lesson"
        "Protective theme with youth innocence, C Major, 70 BPM, mimicry adaptation"
        "Transitional theme, mystery revealing, C Major, 70 BPM, stories emerging"
        "Individual identity theme, each voice unique, C Major, 75 BPM, fingerprint music"
        "Social bonds theme, community harmony, C Major, 75 BPM, recognition"
        "Dynamic pack coordination, multiple voices together, C Major, 80 BPM, teamwork energy"
        "Time passage theme, gentle transformation, C Major, 70 BPM, temporal change"
        "Growing up theme, maturation melody, C Major, 70 BPM, independence"
        "Morphing theme, fluid adaptation, C Major, 75 BPM, master disguise"
        "Predator theme sharpening, focus emerging, C Major, 75 BPM, hunter maturation"
        "Mystery theme building intrigue, C Major, 75 BPM, deception preview"
        "Dramatic reveal theme, surprise element, C Major, 80 BPM, false eyes"
        "Confusion theme, disorienting harmonies, C Major, 75 BPM, visual trickery"
        "Celebration theme, all voices together, triumphant unity, C Major, 85 BPM, diversity joy"
        "Resolving theme, wonder returning, full orchestration peaceful conclusion, C Major, 65 BPM, final wisdom"
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
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4" 2>/dev/null
cd ..
echo "✅ Compiled: NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4"

# Compile 9:16 TikTok version
> final_9x16/scene_list.txt
for scene in {1..24}; do
    echo "file 'scene${scene}_mixed.mp4'" >> final_9x16/scene_list.txt
done

cd final_9x16
ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "NATURES_POLKA_DOTS_TIKTOK_9x16.mp4" 2>/dev/null
cd ..
echo "✅ Compiled: NATURES_POLKA_DOTS_TIKTOK_9x16.mp4"

echo ""
echo "🎬 PHASE 7: TIKTOK HIGHLIGHT GENERATION"
echo "═══════════════════════════════════════════"
echo "Chopping 9:16 TikTok into 16/24-second highlight segments..."

TIKTOK_FILE="final_9x16/NATURES_POLKA_DOTS_TIKTOK_9x16.mp4"

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
echo "  ✅ YouTube 16:9 (3:12): final/NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4"
echo "  ✅ TikTok 9:16 (3:12):  final_9x16/NATURES_POLKA_DOTS_TIKTOK_9x16.mp4"
echo "  ✅ Highlights (16/24s segments): highlights/highlight_*_*.mp4"
echo ""
echo "🎯 All formats ready for distribution!"

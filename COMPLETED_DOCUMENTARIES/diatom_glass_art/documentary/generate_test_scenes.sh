#!/bin/bash

source ../../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
SEED=88888

echo "🔬 DIATOM: LIVING GLASS ART - Test Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Testing 3 key scenes to validate microscopic aesthetic..."
echo ""

# SCENE 1: THE INVISIBLE ARTIST
echo "🎬 Scene 1: The Invisible Artist (Establishing)"
PROMPT_1="Microscopic documentary cinematography, David Attenborough BBC style, crystalline beauty, scientific wonder aesthetic, macro photography perfection. Extreme macro establishing shot, microscope objective 40x magnification, slow zoom in from water droplet to reveal diatom. Single circular diatom (Coscinodiscus species) with intricate radial geometric pattern, golden-amber translucent glass shell, visible green chloroplasts inside, perfectly symmetrical, suspended in crystal clear water, gently rotating from frame 1. Microscopic view of seawater droplet, bright laboratory/sunlit water, crystal clear water with suspended particles, soft light diffusion. Revealing the hidden microscopic world, diatom slowly rotating to show geometric pattern, water molecules (barely visible), light rays, scattered micro-particles. Shallow depth of field (diatom sharp, water background soft blur), bright field microscopy with transmitted light from below, creating golden glow through glass shell, tone: awe-inspiring, artistic wonder, hidden beauty revelation. Color palette: golden-amber translucent glass shell, emerald-green chloroplasts, crystal clear water, soft white light. Action: 0s wide view of water droplet with light refraction, 2s zoom reveals tiny diatom suspended in water, 4s diatom comes into focus geometric pattern visible, 6s slow rotation begins showing radial symmetry, 8s perfect geometric beauty fully revealed. 16:9 cinematic, no speech, ambient only."

response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$PROMPT_1" '{prompt: $prompt, duration: 8, aspect_ratio: "16:9", resolution: "1080p", seed: 88888}')")

echo "$response" > "responses/scene01_test_response.json"
video_url=$(echo "$response" | jq -r '.video.url // empty')

if [[ -n "$video_url" ]]; then
    echo "   ✅ Video URL received, downloading..."
    curl -s -o "videos/scene01_test.mp4" "$video_url"
    if [[ -f "videos/scene01_test.mp4" ]]; then
        echo "   ✅ Downloaded successfully"
    fi
else
    echo "   ⏳ Queued - check response file"
fi
echo ""

# SCENE 3: GEOMETRIC PERFECTION (Most challenging - transitions)
echo "🎬 Scene 3: Geometric Perfection (Diversity - CHALLENGING)"
PROMPT_3="Kaleidoscopic microscopic montage, geometric pattern showcase, scientific art gallery aesthetic. Grid montage transitioning between different diatom species, microscope various magnifications, smooth transitions between different diatom patterns. Sequence of different diatom species: circular radial (Coscinodiscus), triangular (Triceratium), elongated pennate (Navicula), star-shaped, each showing unique geometric patterns, all golden-amber glass with green chloroplasts, each diatom rotating to show pattern, smooth transitions between species from frame 1. Microscopic view, artistic presentation, bright even illumination, clean clinical background, each diatom displayed like art pieces. Kaleidoscopic presentation of diverse diatom geometries, patterns morphing and transitioning, multiple diatom species, geometric pattern emphasis, light refractions. Sharp focus on each diatom pattern, bright field microscopy with artistic presentation lighting, tone: gallery exhibition, nature as supreme artist, mathematical beauty. Color palette: golden-amber glass shells in various geometries, emerald green chloroplasts, rainbow refractions, white background. Action: 0s-1s circular radial pattern, 2s transition to triangular three-pointed star pattern, 3s-4s elongated pennate boat-shaped with bilateral symmetry, 5s intricate six-pointed star pattern, 6s-7s multiple species shown together diversity emphasis, 8s return to circular radial main character. 16:9 cinematic, no speech, ambient only."

response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$PROMPT_3" '{prompt: $prompt, duration: 8, aspect_ratio: "16:9", resolution: "1080p", seed: 88888}')")

echo "$response" > "responses/scene03_test_response.json"
video_url=$(echo "$response" | jq -r '.video.url // empty')

if [[ -n "$video_url" ]]; then
    echo "   ✅ Video URL received, downloading..."
    curl -s -o "videos/scene03_test.mp4" "$video_url"
    if [[ -f "videos/scene03_test.mp4" ]]; then
        echo "   ✅ Downloaded successfully"
    fi
else
    echo "   ⏳ Queued - check response file"
fi
echo ""

# SCENE 6: BORN AS ART
echo "🎬 Scene 6: Born as Art (Emotional Payoff)"
PROMPT_6="Triumphant reveal, newborn beauty, artistic presentation, celebratory microscopic cinematography. Medium shot of complete new diatom, microscope 40x magnification, slow dolly-in celebrating the finished creation. Newly completed circular diatom with pristine golden-amber glass shell, perfectly symmetrical radial pattern, intricate geometric perforations, vibrant emerald-green chloroplasts, shell gleaming with fresh transparency, gently rotating in water from frame 1, showing off completed perfection. Open water microscopic environment, golden hour lighting (artistic), crystal clear water, gentle current, suspended particles catching light, celebratory atmosphere. Newborn diatom floating freely, rotating gracefully to show geometric perfection, light particles, water molecules, subtle rainbow refractions through shell. Shallow depth of field (diatom razor sharp, background dreamy soft), golden transmitted light with artistic rim lighting, creating halo effect, tone: triumphant, celebratory, newborn beauty, artistic achievement. Color palette: gleaming golden-amber glass shell with perfect clarity, vibrant emerald chloroplasts, golden light, soft blue water, rainbow highlights. Action: 0s-2s newborn diatom revealed in beautiful lighting, 3s-4s slow rotation showing perfect radial symmetry, 5s-6s light refracts creating rainbow through pristine glass, 7s chloroplasts visible glowing green through transparency, 8s perfect art piece floating freely life begins. 16:9 cinematic, no speech, ambient only."

response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$PROMPT_6" '{prompt: $prompt, duration: 8, aspect_ratio: "16:9", resolution: "1080p", seed: 88888}')")

echo "$response" > "responses/scene06_test_response.json"
video_url=$(echo "$response" | jq -r '.video.url // empty')

if [[ -n "$video_url" ]]; then
    echo "   ✅ Video URL received, downloading..."
    curl -s -o "videos/scene06_test.mp4" "$video_url"
    if [[ -f "videos/scene06_test.mp4" ]]; then
        echo "   ✅ Downloaded successfully"
    fi
else
    echo "   ⏳ Queued - check response file"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Test generation complete!"
echo ""
echo "📊 REVIEW CHECKLIST:"
echo "   ✓ Scene 1: Does the microscopic reveal work?"
echo "   ✓ Scene 3: Can AI transition between diatom species?"
echo "   ✓ Scene 6: Does the golden-amber glass aesthetic succeed?"
echo "   ✓ Overall: Is geometric perfection achievable?"
echo "   ✓ Overall: Are chloroplasts visible through glass?"
echo ""
echo "📁 Videos saved to: videos/"
echo "📄 Responses saved to: responses/"


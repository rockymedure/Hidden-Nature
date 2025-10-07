#!/bin/bash

source ../../../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
SEED=88888

echo "🔬 Regenerating Scene 6: Born as Art (More Scientific)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "CHANGES FROM ORIGINAL:"
echo "  ❌ Removed: 'golden hour lighting', 'celebratory atmosphere', 'halo effect'"
echo "  ✅ Added: Clinical microscopy lighting, scientific realism"
echo "  ✅ Kept: Geometric perfection, chloroplasts visible, glass transparency"
echo ""

# NEW PROMPT - More scientific, less artistic
PROMPT="Microscopic documentary cinematography, scientific beauty, authentic laboratory microscopy aesthetic, BBC nature documentary realism. Medium shot of complete diatom, microscope 40x magnification, slow steady zoom-in on newly formed organism.

Newly completed circular diatom with pristine golden-amber translucent glass shell, perfectly symmetrical radial geometric pattern, intricate perforations in regular arrangement, vibrant emerald-green chloroplasts clearly visible inside, shell showing fresh transparency, gently rotating in water from frame 1 showing completed structure.

Microscopic aquatic environment, bright transmitted light from below (standard microscopy lighting), crystal clear water with natural suspended particles, clinical scientific illumination, authentic laboratory microscopy appearance.

Newborn diatom floating freely, rotating slowly to reveal geometric perfection from all angles, natural light particles in water, subtle light refraction through glass shell structure showing transparency.

Shallow depth of field (diatom ultra-sharp focus, water background soft natural blur), bright field transmitted microscopy lighting from below, natural light refraction through glass, tone: scientific wonder, authentic microscopic beauty, nature documentary realism.

Color palette: golden-amber translucent glass shell with natural clarity, vibrant emerald-green chloroplasts, crystal clear water, white transmitted light from below.

Action: 0s-2s newly formed diatom revealed under microscope with natural lighting, 3s-4s slow rotation showing perfect radial symmetry and geometric pattern, 5s-6s light naturally refracts through transparent glass structure, 7s emerald chloroplasts clearly visible through shell walls, 8s complete rotation reveals flawless geometric architecture.

16:9 cinematic, no speech, ambient only."

echo "🎬 Generating with scientific aesthetic..."
response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n --arg prompt "$PROMPT" '{prompt: $prompt, duration: 8, aspect_ratio: "16:9", resolution: "1080p", seed: 88888}')")

echo "$response" > "responses/scene06_v2_response.json"
video_url=$(echo "$response" | jq -r '.video.url // empty')

if [[ -n "$video_url" ]]; then
    echo "   ✅ Video URL received, downloading..."
    curl -s -o "videos/scene06_v2.mp4" "$video_url"
    if [[ -f "videos/scene06_v2.mp4" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "videos/scene06_v2.mp4")
        size=$(ls -lh "videos/scene06_v2.mp4" | awk '{print $5}')
        echo "   ✅ Downloaded successfully"
        printf "      Duration: %.2fs | Size: %s\n" "$duration" "$size"
    fi
else
    echo "   ⏳ Queued - check response file"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Regeneration complete!"
echo ""
echo "📊 COMPARISON:"
echo "   Original: videos/scene06_test.mp4 (artistic, stylized)"
echo "   New v2:   videos/scene06_v2.mp4 (scientific, realistic)"
echo ""
echo "🔬 Review v2 for:"
echo "   ✓ More authentic microscopy look"
echo "   ✓ Less 'fake' artistic effects"
echo "   ✓ Scientific realism maintained"
echo "   ✓ Chloroplasts still visible"
echo "   ✓ Geometric perfection preserved"


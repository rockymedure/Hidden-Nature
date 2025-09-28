#!/bin/bash

# Generate conceptually-paired video clips based on CONCEPTUAL_BREAKDOWN.md

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🎬 Generating conceptually-paired clips for documentary storytelling..."

mkdir -p conceptual_clips

echo "🚀 Launching all sub-scene clips in parallel..."

# Scene 1: Opening Wonder (22s) - 3 sub-scenes
curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Deep space panorama with cosmic web, galaxies in vast emptiness, cinematic documentary style, no speech, ambient only", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene1A_cosmic_mystery.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Dramatic black hole formation, spacetime ripping effect, reality tearing, cinematic space documentary, no dialogue, atmospheric audio", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene1B_reality_tears.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Spacecraft launching toward cosmic destination, journey beginning, exploration mission, documentary style, no speech, ambient only", "duration": 6, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene1C_journey_begins.mp4" {} &

# Scene 2: Cosmic Context (23s) - 3 sub-scenes
curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Zoom out from Earth through cosmic scales, showing galaxy abundance, universe overview, documentary cinematography, no dialogue, atmospheric", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene2A_galaxy_abundance.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Zoom into galactic centers, revealing dark mysterious regions, galactic cores, space documentary, no speech, ambient audio", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene2B_galactic_hearts.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Historical physics timeline, ancient to modern understanding, scientific evolution, educational documentary, no dialogue, ambient", "duration": 7, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene2C_physics_evolution.mp4" {} &

# Scene 3: Einstein Revolution (32s) - 4 sub-scenes
curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Einstein working, historical footage, his revolutionary moment, scientific breakthrough, documentary style, no speech, ambient only", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene3A_einstein_revelation.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Newton apple falling vs Einstein curved spacetime concept, physics comparison, educational visualization, no dialogue, atmospheric", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene3B_newton_vs_einstein.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Classic rubber sheet demonstration, ball creating depression, gravity visualization, physics education, no speech, ambient audio", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene3C_rubber_sheet_demo.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Transition from rubber sheet to actual cosmic spacetime curvature, universal scale, documentary cinematography, no dialogue, atmospheric", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "conceptual_clips/scene3D_cosmic_curvature.mp4" {} &

echo "⚡ 10 conceptual clips launching simultaneously..."
echo "⏳ Each clip tightly paired to specific narration beats..."

# Wait for all downloads
wait

echo ""
echo "🔗 Assembling conceptually-coherent scenes..."

# Assemble Scene 1 (1A + 1B + 1C = 22s)
echo "file 'conceptual_clips/scene1A_cosmic_mystery.mp4'
file 'conceptual_clips/scene1B_reality_tears.mp4'
file 'conceptual_clips/scene1C_journey_begins.mp4'" > scene1_conceptual.txt

ffmpeg -y -f concat -safe 0 -i scene1_conceptual.txt -c copy "assembled_scenes/scene1_22s.mp4" > /dev/null 2>&1

# Assemble Scene 2 (2A + 2B + 2C = 23s)
echo "file 'conceptual_clips/scene2A_galaxy_abundance.mp4'
file 'conceptual_clips/scene2B_galactic_hearts.mp4'
file 'conceptual_clips/scene2C_physics_evolution.mp4'" > scene2_conceptual.txt

ffmpeg -y -f concat -safe 0 -i scene2_conceptual.txt -c copy "assembled_scenes/scene2_23s.mp4" > /dev/null 2>&1

# Assemble Scene 3 (3A + 3B + 3C + 3D = 32s)
echo "file 'conceptual_clips/scene3A_einstein_revelation.mp4'
file 'conceptual_clips/scene3B_newton_vs_einstein.mp4'
file 'conceptual_clips/scene3C_rubber_sheet_demo.mp4'
file 'conceptual_clips/scene3D_cosmic_curvature.mp4'" > scene3_conceptual.txt

ffmpeg -y -f concat -safe 0 -i scene3_conceptual.txt -c copy "assembled_scenes/scene3_32s.mp4" > /dev/null 2>&1

echo ""
echo "✅ First 3 scenes assembled with tight conceptual pairing!"

echo "📊 Results:"
for scene in 1 2 3; do
    if [[ -f "assembled_scenes/scene${scene}_*s.mp4" ]]; then
        file=$(ls assembled_scenes/scene${scene}_*s.mp4)
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file")
        echo "Scene $scene: ${duration%.*}s assembled with conceptual flow"
    fi
done
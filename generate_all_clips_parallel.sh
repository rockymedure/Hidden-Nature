#!/bin/bash

cd black_holes_attenborough_science

echo "🚀 Generating ALL clips in parallel for maximum speed..."

source ../.env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

mkdir -p clips_parallel

# Launch ALL clip generations simultaneously
echo "🎬 Launching parallel clip generation..."

# Scene 1: 8s + 4s clips
curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Deep space background with galaxies and nebulae, cosmic vista, cinematic documentary style, no speech, ambient only", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene1_clip1_8s.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Majestic cosmic title sequence emerging, stellar formations, space documentary opening, no dialogue, atmospheric audio only", "duration": 4, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene1_clip2_4s.mp4" {} &

# Scene 2: 6s + 4s clips
curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Dramatic black hole with swirling accretion disk, matter spiraling inward, cosmic phenomenon, no speech, ambient only", "duration": 6, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene2_clip1_6s.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Spectacular black hole close-up, luminous matter streams, space cinematography, no dialogue, atmospheric audio", "duration": 4, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene2_clip2_4s.mp4" {} &

# Scene 3: 8s + 6s + 4s clips
curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Einstein working on equations, mathematical formulas, historical documentary style, no speech, ambient only", "duration": 8, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene3_clip1_8s.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Spacetime visualization, curved geometry demonstration, physics education, no dialogue, atmospheric audio", "duration": 6, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene3_clip2_6s.mp4" {} &

curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" -d '{"prompt": "Scientific equations and relativity concepts, academic documentation, no narration, ambient background", "duration": 4, "aspect_ratio": "16:9"}' | jq -r '.video.url' | xargs -I {} curl -s -o "clips_parallel/scene3_clip3_4s.mp4" {} &

echo "⚡ 7 clips launching in parallel..."
echo "⏳ Waiting for all downloads to complete..."

# Wait for all background jobs
wait

echo ""
echo "🔗 Combining clips into scenes..."

# Combine Scene 1 (8s + 4s = 12s)
echo "file 'clips_parallel/scene1_clip1_8s.mp4'
file 'clips_parallel/scene1_clip2_4s.mp4'" > scene1_concat.txt

ffmpeg -y -f concat -safe 0 -i scene1_concat.txt -c copy "matched_videos/scene1_10s.mp4" > /dev/null 2>&1

# Combine Scene 2 (6s + 4s = 10s)
echo "file 'clips_parallel/scene2_clip1_6s.mp4'
file 'clips_parallel/scene2_clip2_4s.mp4'" > scene2_concat.txt

ffmpeg -y -f concat -safe 0 -i scene2_concat.txt -c copy "matched_videos/scene2_10s.mp4" > /dev/null 2>&1

# Combine Scene 3 (8s + 6s + 4s = 18s)
echo "file 'clips_parallel/scene3_clip1_8s.mp4'
file 'clips_parallel/scene3_clip2_6s.mp4'
file 'clips_parallel/scene3_clip3_4s.mp4'" > scene3_concat.txt

ffmpeg -y -f concat -safe 0 -i scene3_concat.txt -c copy "matched_videos/scene3_18s.mp4" > /dev/null 2>&1

echo ""
echo "🎵 Mixing with Attenborough narration..."

# Mix each scene with its narration
for scene in 1 2 3; do
    video_file="matched_videos/scene${scene}_*s.mp4"
    video_exists=$(ls $video_file 2>/dev/null | head -1)
    narration_file="narration_first/scene${scene}_natural.mp3"

    if [[ ! -z "$video_exists" && -f "$narration_file" ]]; then
        output_file="final_mixed/scene${scene}_attenborough.mp4"

        ffmpeg -y -i "$video_exists" -i "$narration_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Attenborough-quality achieved"
        fi
    fi
done

echo ""
echo "📊 Progress summary:"
for scene in 1 2 3; do
    if [[ -f "final_mixed/scene${scene}_attenborough.mp4" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "final_mixed/scene${scene}_attenborough.mp4")
        echo "Scene $scene: ${duration%.*}s with natural narration"
    fi
done

echo ""
echo "🎬 First 3 scenes of Attenborough documentary complete!"
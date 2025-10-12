#!/bin/bash
source ../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
NARRATOR_VOICE_ID="pN2Hqj1221g5xYQh0221" # Charlotte

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎬 GENERATING ALL 6 CONCEPT TESTS (24s each)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create folder structure
for concept in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    mkdir -p "$concept"/{audio,videos,music,final}
done

# ============================================================================
# JUMPING SPIDER (Seed: 11111)
# ============================================================================
echo "🕷️  CONCEPT 1: Jumping Spider's Hunt"
(
    cd jumping_spider
    
    # Narrations
    curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"text\": \"She sees you before you see her. Eight eyes. Each one tracking. Calculating. Waiting for the perfect moment.\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene1.mp3 &
    
    curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"text\": \"No web needed. She's a hunter. One explosive jump. Thirty times her body length. No room for error.\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene2.mp3 &
    
    curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"text\": \"Gotcha. She didn't need venom or a web. Just perfect vision, patient timing, and incredible precision. Smartest spider alive.\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene3.mp3 &
    
    # Videos
    curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Jumping spider (Phidippus regius) with prominent large front eyes, compact fuzzy body, striped legs, on textured bark surface, extreme close-up of face showing massive forward-facing eyes with reflective quality, other six eyes visible on sides, patient stalking posture with legs coiled, prey (fly) visible blurred in background, macro nature photography, shallow depth of field, natural lighting, no speech, ambient forest sounds\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": 11111, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene1.mp4 &
    
    curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Jumping spider (Phidippus regius) with prominent large front eyes, compact fuzzy body, striped legs, mid-leap through air toward prey, legs extended, dragline silk visible trailing behind, freeze-frame quality capturing suspended moment, prey in sharp focus ahead, incredible athletic display, macro nature photography, fast shutter speed effect, dramatic lighting, no speech, ambient only\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": 11111, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene2.mp4 &
    
    curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Jumping spider (Phidippus regius) with prominent large front eyes, compact fuzzy body, striped legs, holding captured fly with front legs, looking directly at camera with those huge eyes, victorious moment, sitting on leaf, satisfied posture, macro close-up showing detail of eyes and fuzzy body, natural daylight, no speech, ambient forest sounds\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": 11111, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene3.mp4 &
    
    # Music
    curl -s -X POST "$MUSIC_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Tense, suspenseful strings with subtle percussive ticking, building anticipation, Key: D minor, Tempo: 85 BPM\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene1.mp3 &
    
    curl -s -X POST "$MUSIC_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Explosive orchestral hit with rapid ascending strings, adrenaline rush, Key: D minor to D Major, Tempo: 120 BPM\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene2.mp3 &
    
    curl -s -X POST "$MUSIC_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Triumphant but playful resolution, pizzicato strings with light woodwinds, clever and satisfied, Key: D Major, Tempo: 90 BPM\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene3.mp3 &
    
    wait
    echo "   ✅ Jumping Spider: All assets generated"
) &

# ============================================================================
# CUTTLEFISH (Seed: 22222)
# ============================================================================
echo "🦑 CONCEPT 2: Cuttlefish's Instant Disguise"
(
    cd cuttlefish
    
    # Narrations
    curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"text\": \"Danger. A predator overhead. But she has a superpower. She can become invisible. And it happens in milliseconds.\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene1.mp3 &
    
    curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"text\": \"Watch. Her skin erupts with patterns. Waves of color. Shifting textures. All controlled by millions of cells beneath her skin.\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene2.mp3 &
    
    curl -s -X POST "$AUDIO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"text\": \"Perfect match. She's completely invisible. The predator swims past. And she's colorblind. She did all that without seeing color.\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.7, \"speed\": 1.0}" \
        | jq -r '.audio.url' | xargs curl -s -o audio/scene3.mp3 &
    
    # Videos
    curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, floating above sandy ocean floor, currently displaying mottled brown/tan pattern matching sand, predatory shark silhouette visible in background, underwater scene with natural light filtering down, cuttlefish beginning to sense threat, no speech, ambient underwater sounds\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": 22222, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene1.mp4 &
    
    curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, skin actively transforming in real-time, rapid succession of patterns (stripes, spots, waves) flowing across body, chromatophores visibly expanding and contracting, mesmerizing display of biological technology, extreme close-up showing skin texture changing, iridescent colors appearing, no speech, ambient underwater sounds\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": 22222, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene2.mp4 &
    
    curl -s -X POST "$VIDEO_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, now perfectly camouflaged against rocky coral background, almost completely invisible, only subtle outline visible, predator (shark) passing overhead in frame, cuttlefish remains motionless and camouflaged, incredible demonstration of camouflage, underwater lighting, no speech, ambient underwater sounds\", \"duration\": 8, \"aspect_ratio\": \"9:16\", \"resolution\": \"1080p\", \"seed\": 22222, \"generate_audio\": true}" \
        | jq -r '.video.url' | xargs curl -s -o videos/scene3.mp4 &
    
    # Music
    curl -s -X POST "$MUSIC_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Ominous low strings with ocean-like synth pad, underwater tension, Key: E minor, Tempo: 70 BPM\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene1.mp3 &
    
    curl -s -X POST "$MUSIC_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Hypnotic arpeggiated synths with fluid string movements, transformation theme, psychedelic documentary style, Key: E minor to E Major, Tempo: 85 BPM\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene2.mp3 &
    
    curl -s -X POST "$MUSIC_ENDPOINT" -H "Authorization: Key $FAL_API_KEY" -H "Content-Type: application/json" \
        -d "{\"prompt\": \"Quiet resolution with sparse ambient tones, wonder and mystery, ocean atmosphere, Key: E Major, Tempo: 60 BPM\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}" \
        | jq -r '.audio.url' | xargs curl -s -o music/scene3.mp3 &
    
    wait
    echo "   ✅ Cuttlefish: All assets generated"
) &

# Continue with other concepts in background...
wait

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⏳ Phase 1 complete - Now generating remaining 4 concepts..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"



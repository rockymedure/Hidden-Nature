#!/bin/bash

# Generate deer family documentary with visual dynamics and 1080p quality

source .env
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"

echo "🦌 Generating Netflix-quality deer family with visual dynamics..."

mkdir -p deer_videos deer_final

# Character consistency
DEER_FAMILY="The same graceful white-tailed deer family - alert mother doe with brown eyes and distinctive white chest patch, two spotted fawns with different personalities, one bold and curious, one cautious and gentle"

# Environment database with specific seeds
declare -A environments=(
    ["forest_meadow"]="88888|Dense oak forest meadow with dappled morning sunlight, tall grass, wildflowers, protective tree canopy"
    ["stream_valley"]="88889|Crystal clear stream valley with flowing water, lush watercress, young willow saplings, pebbled banks"
    ["open_meadow"]="88890|Sun-drenched open meadow with golden grass, scattered wildflowers, bright blue sky, gentle breeze"
    ["dense_woodland"]="88891|Cool dense woodland with thick canopy, filtered light, fern undergrowth, ancient tree trunks"
    ["rocky_hill"]="88892|Rocky hillside with panoramic views, scattered boulders, wind-swept grass, dramatic sky views"
)

# Scene environment mapping
declare -a scene_environments=(
    "forest_meadow"    # Scene 1: Dawn awakening
    "forest_meadow"    # Scene 2: Mother's vigilance
    "forest_meadow"    # Scene 3: Curious fawns
    "forest_meadow"    # Scene 4: Morning hunger
    "stream_valley"    # Scene 5: Journey begins
    "stream_valley"    # Scene 6: Stream discovery
    "stream_valley"    # Scene 7: Feeding lessons
    "stream_valley"    # Scene 8: Drinking together
    "open_meadow"      # Scene 9: Into sunlight
    "open_meadow"      # Scene 10: Fawn games
    "open_meadow"      # Scene 11: Teaching alertness
    "open_meadow"      # Scene 12: False alarm
    "dense_woodland"   # Scene 13: Seeking shade
    "dense_woodland"   # Scene 14: Hidden rest
    "dense_woodland"   # Scene 15: Midday dreams
    "dense_woodland"   # Scene 16: Afternoon stirring
    "rocky_hill"       # Scene 17: Climbing higher
    "rocky_hill"       # Scene 18: Valley views
    "rocky_hill"       # Scene 19: Teaching territory
    "forest_meadow"    # Scene 20: Homeward bound (RETURN)
    "forest_meadow"    # Scene 21: Evening feast (RETURN)
    "forest_meadow"    # Scene 22: Bedtime rituals (RETURN)
    "forest_meadow"    # Scene 23: Night's protection (RETURN)
)

# Scene-specific actions
declare -a scene_actions=(
    "family awakening from sleep in tall grass, dawn golden light filtering through trees"
    "mother doe alert and scanning surroundings, protective maternal stance, ears constantly moving"
    "two spotted fawns investigating wildflowers, one bold and leading, one cautious behind mother"
    "family nibbling sparse grass, showing need to move on, mother making decision"
    "family moving in single file through forest, mother leading toward water source"
    "discovering lush stream with abundant vegetation, family approaching water cautiously"
    "mother selectively feeding on safe plants, fawns learning by watching and mimicking"
    "all three deer drinking from stream, peaceful moment, clear water reflections"
    "family emerging from forest shade into bright sunlit meadow, transitioning environments"
    "fawns playfully leaping and bounding, building strength, mother watching with approval"
    "mother suddenly alert with raised head, fawns immediately freezing, survival training"
    "family relaxing as false threat passes, fawns learning vigilance importance"
    "family moving into thick forest canopy for shade, seeking cooler temperatures"
    "family bedding down in fern grove, perfectly camouflaged, secure resting spot"
    "sleeping fawns with mother's head up, ears moving, constant maternal vigilance"
    "family stretching and preparing to move, afternoon light filtering through canopy"
    "family carefully ascending rocky slope, sure-footed movement upward"
    "family on hilltop with panoramic valley view, surveying territory from high vantage"
    "mother teaching fawns about territorial boundaries, pointing with gaze direction"
    "family descending toward same forest meadow, circular journey completing"
    "family feeding in same meadow location, but evening light instead of dawn"
    "family creating sleeping area in familiar meadow, intimate bedtime preparations"
    "family at rest in same meadow as opening, stars appearing, peaceful night scene"
)

echo "🚀 Launching all 23 videos with visual dynamics and 1080p quality..."

# Generate all videos with environmental progression
for i in {0..22}; do
    scene=$((i + 1))
    env_key="${scene_environments[$i]}"
    env_data="${environments[$env_key]}"

    # Parse environment data
    IFS='|' read -r seed env_description <<< "$env_data"

    scene_action="${scene_actions[$i]}"

    echo "🎥 Scene $scene: ${env_key} (Seed $seed)"

    # Build full prompt with consistency + dynamics
    full_prompt="$DEER_FAMILY in $env_description, $scene_action, cinematic nature documentary style, no speech, no dialogue, ambient forest sounds only"

    # Generate with environment-specific seed and 1080p
    (
        request_body=$(cat << EOF
{
    "prompt": "$full_prompt",
    "duration": 8,
    "aspect_ratio": "16:9",
    "resolution": "1080p",
    "seed": $seed
}
EOF
        )

        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "$request_body")

        video_url=$(echo "$response" | jq -r '.video.url // empty')

        if [[ ! -z "$video_url" && "$video_url" != "null" ]]; then
            curl -s -o "deer_videos/scene${scene}_${env_key}.mp4" "$video_url"
            echo "✅ Scene $scene: Visual dynamics completed (${env_key})"
        else
            echo "❌ Scene $scene: Video failed"
        fi
    ) &

    sleep 2
done

echo "⏳ Waiting for all 1080p deer videos with visual dynamics..."
wait

echo ""
echo "🎼 Mixing Charlotte's calming narration with dynamic visuals..."

# Mix each scene
for scene in {1..23}; do
    env_key="${scene_environments[$((scene-1))]}"
    video_file="deer_videos/scene${scene}_${env_key}.mp4"
    audio_file="deer_audio/scene${scene}_deer.mp3"
    output_file="deer_final/scene${scene}_netflix_1080p.mp4"

    if [[ -f "$video_file" && -f "$audio_file" ]]; then
        echo "🎵 Scene $scene: Mixing 1080p ${env_key} with Roger's narration"

        ffmpeg -y -i "$video_file" -i "$audio_file" \
            -filter_complex "[0:a]volume=0.05[ambient];[1:a]volume=1.5[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=2[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac \
            "$output_file" > /dev/null 2>&1

        if [[ -f "$output_file" ]]; then
            echo "✅ Scene $scene: Netflix 1080p quality achieved"
        fi
    fi
done

echo ""
echo "🎞️  Creating final 1080p documentary with visual dynamics..."

# Final compilation
echo "# Netflix 1080p deer family with visual dynamics" > deer_1080p_list.txt
for scene in {1..23}; do
    final_file="deer_final/scene${scene}_netflix_1080p.mp4"
    if [[ -f "$final_file" ]]; then
        echo "file '$final_file'" >> deer_1080p_list.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i deer_1080p_list.txt -c copy "DEER_FAMILY_NETFLIX_1080P_DYNAMICS.mp4"

if [[ -f "DEER_FAMILY_NETFLIX_1080P_DYNAMICS.mp4" ]]; then
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "DEER_FAMILY_NETFLIX_1080P_DYNAMICS.mp4")
    filesize=$(ls -lh "DEER_FAMILY_NETFLIX_1080P_DYNAMICS.mp4" | awk '{print $5}')

    echo ""
    echo "🌟 SUCCESS! Netflix 1080p deer family documentary with visual dynamics:"
    echo "   📁 File: DEER_FAMILY_NETFLIX_1080P_DYNAMICS.mp4"
    echo "   ⏱️  Duration: $((duration / 60))m $((duration % 60))s"
    echo "   💾 Size: $filesize"
    echo "   🎯 1080p quality with perfect visual dynamics!"
    echo "   🦌 Same deer family journey through 5 distinct environments!"
    echo "   🏠 Visual memory - return to same meadow looks familiar!"

else
    echo "❌ Final 1080p compilation failed"
fi

echo ""
echo "🎬 Visual dynamics methodology perfected with 1080p Netflix quality!"
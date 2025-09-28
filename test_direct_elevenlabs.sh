#!/bin/bash

# Direct ElevenLabs API Test Implementation
# Enhanced documentary narration generation with full ElevenLabs features

# Voice ID mappings from ElevenLabs API
declare -A VOICE_IDS=(
    ["Rachel"]="EXAVITQu4vr4xnSDxMaL"     # Sarah - Science/cosmic wonder
    ["Roger"]="CwhRBWXzGAHq8TQ4Fs17"      # Roger - Nature/dramatic  
    ["Charlotte"]="pFZP5JQG7iQjIQuC4Bku"  # Lily - Calming nature
    ["Marcus"]="JBFqnCBsd6RMkjVDRZzb"     # George - Historical authority
    ["Matilda"]="XrExE9yKIg1WjnnlVkGX"    # Matilda - Educational
    ["Viraj"]="1U02n4nD6AdIZ9CjF053"      # Viraj - Smooth narrator
    ["Feynman"]="iUqvz0lkQxPhaAG37J5I"    # Richard Feynman™ - Science genius
)

# Configuration
ELEVENLABS_ENDPOINT="https://api.elevenlabs.io/v1/text-to-speech"
ELEVENLABS_API_KEY="sk_96e80934fdd2890766b5c91ff0503912a02cee47d7d968a2"
NARRATOR="Oracle"  # Using Oracle X (professional voice)
VOICE_ID="1hlpeD1ydbI2ow0Tt3EW"  # Direct voice ID provided

# Enhanced narration generation function
generate_narration_direct() {
    local scene_num=$1
    local narration_text=$2
    local previous_text=$3  # For continuity
    local audio_seed=$4     # For consistency
    
    echo "🎤 Generating Scene $scene_num with direct ElevenLabs API"
    
    # Build request payload with proper JSON formatting
    if [[ -n "$previous_text" ]]; then
        local payload='{
            "text": "'"$narration_text"'",
            "model_id": "eleven_multilingual_v2",
            "voice_settings": {
                "stability": 0.5,
                "similarity_boost": 0.75,
                "style": 0.7,
                "use_speaker_boost": true
            },
            "seed": '$audio_seed',
            "optimize_streaming_latency": 1,
            "output_format": "mp3_44100_128",
            "apply_text_normalization": "auto",
            "previous_text": "'"$previous_text"'"
        }'
    else
        local payload='{
            "text": "'"$narration_text"'",
            "model_id": "eleven_multilingual_v2",
            "voice_settings": {
                "stability": 0.5,
                "similarity_boost": 0.75,
                "style": 0.7,
                "use_speaker_boost": true
            },
            "seed": '$audio_seed',
            "optimize_streaming_latency": 1,
            "output_format": "mp3_44100_128",
            "apply_text_normalization": "auto"
        }'
    fi
    
    # Make API call with direct file output (prevents binary data corruption)
    if curl -s -X POST "$ELEVENLABS_ENDPOINT/$VOICE_ID" \
        -H "xi-api-key: $ELEVENLABS_API_KEY" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        --output "audio/scene${scene_num}.mp3"; then
        
        echo "✅ Scene $scene_num: Direct ElevenLabs narration saved"
        return 0
    else
        echo "❌ Scene $scene_num: Failed to generate narration"
        return 1
    fi
}

# Example usage with continuity
echo "🌱 Testing Direct ElevenLabs API Integration"
echo ""

# Test narrations with continuity
declare -a test_narrations=(
    "Seeds crack concrete, survive centuries, travel oceans. Nature's survival capsules, engineered over 400 million years."
    "Maple seeds generate tornados above their wings. This vortex doubles lift - the same trick hummingbirds use."
    "Spinning seeds shed raindrops in milliseconds - shattering, flinging, even cutting drops in half to maintain flight."
)

# Create audio directory
mkdir -p audio

# Generate test scenes with continuity
previous_text=""
for i in {0..2}; do
    scene_num=$((i + 1))
    current_text="${test_narrations[$i]}"
    audio_seed=$((80000 + i))  # Consistent seeding
    
    generate_narration_direct $scene_num "$current_text" "$previous_text" $audio_seed
    
    # Set previous text for next iteration
    previous_text="$current_text"
    
    sleep 1  # Rate limiting
done

echo ""
echo "✅ Direct ElevenLabs API test complete!"
echo "Check audio/ directory for generated files"

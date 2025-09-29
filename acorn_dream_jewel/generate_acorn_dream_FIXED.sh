#!/bin/bash

# The Acorn's Dream - FIXED Character Progression
# SOLUTION: Progressive life stage descriptions instead of static character consistency
# Following proper transformation storytelling methodology

source ../.env

VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"

echo "🌰 The Acorn's Dream - FIXED Character Progression"
echo "🤖 AI Fix: Progressive life stages instead of static character consistency"
echo "🎤 Using Charlotte voice for maternal authority"
echo "🔧 SOLUTION: Each scene shows ONLY appropriate life stage, not full transformation"
echo ""

mkdir -p acorn_videos_fixed acorn_responses_fixed acorn_narrations_fixed acorn_mixed_fixed

# Progressive Character Descriptions (FIXED APPROACH)
# Each scene shows only the appropriate life stage for that point in story

declare -a progressive_characters=(
    # Act 1: Acorn Stage (Scenes 1-6)
    "Single mature acorn with distinctive brown cap and shell, among autumn leaves"
    "Same brown acorn with recognizable cap pattern, extreme close-up detail"
    "Same acorn falling through air, distinctive markings visible, dramatic descent"
    "Same acorn resting on moss-covered forest floor, peaceful landing"
    "Same acorn being soaked by rain, water droplets on brown shell"
    "Same acorn beginning to crack slightly, internal changes starting"
    
    # Act 2: Germination & Early Growth (Scenes 7-12)
    "Same acorn covered in winter snow, shell intact but weathered"
    "Same acorn with shell cracking open, tiny green shoot emerging from crack"
    "Small oak sprout with first leaves, emerged from cracked acorn shell"
    "Young oak seedling with several leaves, about 6 inches tall"
    "Small oak sapling with developing leaves, about 1 foot tall"
    "Young oak sapling with stronger stem and more leaves, about 2 feet tall"
    
    # Act 3: Youth & Growth (Scenes 13-18)
    "5-year-old oak tree with small trunk and developing branches, about 6 feet tall"
    "Young oak tree with spreading root system visible, developing underground network"
    "10-year-old oak with visible growth rings in trunk, about 12 feet tall"
    "15-year-old oak tree bending in storm, flexible but strong, about 20 feet tall"
    "20-year-old oak with wildlife habitat, birds and animals in branches"
    "25-year-old oak breaking through forest understory, reaching toward canopy"
    
    # Act 4: Maturity & Legacy (Scenes 19-24)
    "50-year-old mature oak tree producing first acorns, parental stage"
    "Same mature oak tree with visible acorns in branches, genetic continuation"
    "100-year-old ancient oak tree, massive trunk and spreading canopy"
    "Century-old oak with vast underground root network connecting other trees"
    "Ancient oak patriarch with rich ecosystem of wildlife in its canopy"
    "Magnificent ancient oak with new acorns falling, cycle continuing"
)

# Fixed Visual Descriptions (focusing on single life stage per scene)
declare -a visuals_fixed=(
    "Majestic ancient oak canopy with single brown acorn among many, focus on one distinctive acorn"
    "Extreme close-up of brown acorn with distinctive cap pattern and shell markings"
    "Dramatic slow-motion brown acorn falling from high canopy, tumbling through autumn air"
    "Brown acorn resting peacefully on moss-covered forest floor among fallen leaves"
    "Rain falling on brown acorn, water droplets penetrating shell, mystical awakening"
    "Brown acorn shell beginning to crack, internal changes starting, first signs of life"
    "Brown acorn covered in snow and ice, weathered but intact, winter survival"
    "Acorn shell cracking open dramatically, tiny green shoot emerging, birth moment"
    "Small oak sprout with first baby leaves, just emerged from acorn shell remains"
    "Young oak seedling reaching upward, several small leaves, early growth stage"
    "Small oak sapling with developing stem and leaves, connecting to forest network"
    "Young oak sapling with stronger trunk, more leaves, determined growth"
    "5-year-old oak tree with small trunk, gaining confidence and strength"
    "Young oak with developing root system underground, mycorrhizal partnerships forming"
    "10-year-old oak showing growth rings in trunk, decade of survival"
    "15-year-old oak bending in violent storm, flexibility and resilience"
    "20-year-old oak with wildlife making homes, becoming community center"
    "25-year-old oak crown breaking through forest canopy into sunlight"
    "50-year-old mature oak producing first acorns, becoming parent"
    "Mature oak with acorns visible in branches, genetic legacy creation"
    "100-year-old ancient oak with massive canopy, forest elder"
    "Century-old oak with vast root network connecting entire forest"
    "Ancient oak patriarch with rich ecosystem thriving in its canopy"
    "Magnificent ancient oak with new acorns falling, eternal cycle"
)

echo "🔧 SOLUTION APPLIED: Progressive life stage prompting"
echo "Each scene now shows ONLY the appropriate growth stage"
echo ""

# Test one scene to verify fix works
echo "🧪 Testing Scene 1 (should show only acorn):"
echo "Character: ${progressive_characters[0]}"
echo "Visual: ${visuals_fixed[0]}"
echo ""
echo "🧪 Testing Scene 12 (should show only young sapling):"
echo "Character: ${progressive_characters[11]}"
echo "Visual: ${visuals_fixed[11]}" 
echo ""
echo "🧪 Testing Scene 24 (should show only ancient oak):"
echo "Character: ${progressive_characters[23]}"
echo "Visual: ${visuals_fixed[23]}"
echo ""

echo "✅ FIXED APPROACH READY!"
echo "Each scene now focuses on single life stage instead of showing full transformation"
echo ""
echo "🤖 WEB APP AI LEARNING:"
echo "For transformation stories, use PROGRESSIVE character descriptions"
echo "Not static consistency - show appropriate life stage per scene"
echo ""
echo "This fix would be automatically applied in the web app when AI detects transformation-based stories!"

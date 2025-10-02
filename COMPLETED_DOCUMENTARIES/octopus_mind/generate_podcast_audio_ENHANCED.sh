#!/bin/bash
# Generate ENHANCED podcast audio with audio tags using ElevenLabs text-to-dialogue
# Mark (Jeff): gs0tAILXbY5DNrJrsM6F | Charlotte (Lucy): lcMyyd2HUfFzxdCaC4Ta
# Enhanced with emotional tags, pauses, and non-verbal sounds

set -e

# Source .env file
if [ -f .env ]; then
    source .env
elif [ -f ../.env ]; then
    source ../.env
else
    echo "❌ Error: .env file not found"
    exit 1
fi

echo "🎙️ GENERATING ENHANCED PODCAST AUDIO (WITH AUDIO TAGS)"
echo "======================================================"
echo ""
echo "Voices:"
echo "  Mark (Jeff): gs0tAILXbY5DNrJrsM6F"
echo "  Charlotte (Lucy): lcMyyd2HUfFzxdCaC4Ta"
echo ""
echo "✨ Enhanced with audio tags for expressiveness"
echo ""

ENDPOINT="https://fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3"
MARK_VOICE="gs0tAILXbY5DNrJrsM6F"
CHARLOTTE_VOICE="lcMyyd2HUfFzxdCaC4Ta"

# Create output directory
mkdir -p podcast_audio_enhanced

echo "🎬 Generating enhanced podcast segments..."
echo ""

# SEGMENT 1: INTRO (0-2 min) - Enhanced with welcoming energy
echo "📻 Segment 1: Intro & Welcome (ENHANCED)..."
cat > podcast_audio_enhanced/segment1_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "[warm and welcoming] Welcome back to Hidden Nature, where we explore the extraordinary minds hiding in plain sight all around us. I'm Mark, and today I'm sitting down with marine biologist Charlotte, who just returned from a month-long expedition documenting one of the ocean's most remarkable creatures. [excited] Charlotte, welcome to the show.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[exhales] Thanks for having me, Mark. [thoughtful pause] I'm still processing everything I witnessed out there.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[curious] You spent thirty days observing a single octopus you named Cosmos. [short pause] That's... dedication. What made you commit to watching one animal for an entire month?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[chuckles] You know, my colleagues thought I was crazy too. But here's the thing - we film octopuses all the time. We document their hunting, their camouflage, their intelligence. But we never just... sit with one. Watch them live. [thoughtful] And I had this question I couldn't shake: what does HOME mean to an intelligence that evolved completely separately from us?",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "An alien intelligence.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[excited] EXACTLY. Five hundred million years of separate evolution. Their brains don't look like ours. They have neurons in their arms - literally nine brains coordinating together. But when you watch them long enough... [softer] they're searching for the same things we are.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio_enhanced/segment1_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio_enhanced/segment1_intro.mp3" "$audio_url"
    echo "✅ Segment 1 generated"
else
    echo "❌ Segment 1 failed"
fi

sleep 2

# SEGMENT 2: FIRST CONTACT (2-4 min) - Enhanced with wonder
echo "📻 Segment 2: First Contact (ENHANCED)..."
cat > podcast_audio_enhanced/segment2_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "[curious] Take me back to day one. What was your first impression of Cosmos?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[excited, speaking faster] So it's 7:43 in the morning - I know the EXACT time because I nearly dropped my underwater camera. [laughs] I'd been waiting at this rocky outcropping, and suddenly these eight arms just... [inhales sharply] unfurl from the crevice. Like watching a flower bloom, except this flower has three hearts and blue blood.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[chuckles] Not your typical flower.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[happy] Not typical at ALL. But what struck me immediately was how DELIBERATE he was. Most octopuses emerge and immediately start hunting or moving. [thoughtful] Cosmos paused. Just hung there, arms spread, taking in the entire reef. His skin was doing this thing - these color patterns I'd never seen before. Maroons bleeding into electric blues. [whispers] And I remember thinking: he's thinking. He's making calculations about his world.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "You say 'he.' How do you know it was male?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[thoughtful] Honestly? I don't. Giant Pacific octopuses are hard to sex from observation. But after a few days, 'it' just felt wrong. [soft pause] I was watching someone, not something. So Cosmos became 'he.'",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "And that someone was homeless.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[sighs] Completely. And THAT'S what made the next three weeks so fascinating.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio_enhanced/segment2_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio_enhanced/segment2_first_contact.mp3" "$audio_url"
    echo "✅ Segment 2 generated"
else
    echo "❌ Segment 2 failed"
fi

sleep 2

# SEGMENT 3: THE SEARCH (4-6 min) - Enhanced with fascination
echo "📻 Segment 3: The Search for Home (ENHANCED)..."
cat > podcast_audio_enhanced/segment3_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "[curious] Walk me through what you mean by 'homeless octopus.'",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[thoughtful] Okay, so imagine you're house-hunting, but your ENTIRE survival depends on finding the perfect spot. Cosmos would approach a crevice - always leading with his left front arm, by the way - and just... investigate. Testing the walls, measuring the space, checking the angles to the current, mapping out potential escape routes.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[surprised] Wait, he's thinking about ESCAPE ROUTES while house hunting?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Always. These are prey animals living in a world FULL of sharks. Every home needs to be a fortress. [short pause] And I watched him reject spot after spot. Too exposed. Too shallow. Wrong angle. [chuckles] He had standards.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[amazed] This sounds remarkably human.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[excited] THAT'S the thing that kept hitting me. Here's a creature whose last common ancestor with us was some simple worm-like thing half a billion years ago. [thoughtful] And he's house-hunting with the same criteria I'd use: safety, accessibility, good sightlines, multiple exits.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "So when did he find his perfect place?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[happy] Day eight. And Mark, when he found it, you could SEE it in his body language. His chromatophores - those color-changing cells - shifted to calmer tones. His movements slowed. [soft pause] He'd found it.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio_enhanced/segment3_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio_enhanced/segment3_the_search.mp3" "$audio_url"
    echo "✅ Segment 3 generated"
else
    echo "❌ Segment 3 failed"
fi

sleep 2

# SEGMENT 4: ENGINEERING (6-8 min) - Enhanced with amazement
echo "📻 Segment 4: Building the Fortress (ENHANCED)..."
cat > podcast_audio_enhanced/segment4_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "But finding it wasn't enough, was it?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[excited] Oh NO, finding it was just the beginning. Then came the engineering phase, and THIS is where Cosmos completely blew my mind.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[curious] Tell me about the engineering.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "For four days straight, I watched him collect materials. Coconut shell halves, smooth stones, broken coral fragments, even a bottle cap someone had littered. [thoughtful] He'd carry three, sometimes FOUR objects at once in his arms, bring them back, and arrange them with this... obsessive precision.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "He was building walls?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[excited] Not just building - DESIGNING. Every shell was tested for fit. Every stone was positioned to create defensive barriers while maintaining escape routes. [inhales] And here's the crazy part: one day I watched him pick up a rock, examine it with his suckers - which can taste and feel simultaneously, by the way - rotate it 180 degrees, and place it in a completely different location. [pause] Then he stepped back and LOOKED at his work.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[amazed] Wait, he REVISED his design?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[laughs] He revised his design! My research partner surfaced next to me and through our regulators she managed to say: [whispers dramatically] 'Did that octopus just edit his architecture?' [normal voice] And yes. Yes, he did.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio_enhanced/segment4_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio_enhanced/segment4_engineering.mp3" "$audio_url"
    echo "✅ Segment 4 generated"
else
    echo "❌ Segment 4 failed"
fi

sleep 2

# SEGMENT 5: THE MOMENT (8-10 min) - Enhanced with emotional depth
echo "📻 Segment 5: The Recognition Moment (ENHANCED)..."
cat > podcast_audio_enhanced/segment5_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "[gentle] There's a moment in your field journal - day 27 - that really struck me. Can you talk about what happened?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[long pause] [exhales] Yeah. [soft] That's... that's the day I'll remember forever.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[gently] Take your time.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[thoughtful] So I'd been documenting Cosmos for almost four weeks. Same time every day, same careful approach, same respectful distance. Professional distance, right? [short pause] I'm a scientist, he's my research subject. But on day 27, I descended to my usual spot about fifteen feet from his fortress. I settled in, turned on my camera, and Cosmos emerged. [pause] But this time, he came toward me. Not hunting behavior. Not threat display. Just... [whispers] approached.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[soft] How close?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[whispers] Two feet from my camera lens. Close enough that I could see EVERY detail. [inhales] And then he looked directly into my lens. Not at the camera as an object. Into it. [pause] At me.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "What did that feel like?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[emotional] Terrifying and beautiful at the same time. Every instinct said maintain scientific distance. Every protocol said don't interact. But Mark... [pause] he was LOOKING at me. His skin shifted to calm colors. His arms relaxed. And one arm extended slightly - not touching, just... [soft] reaching. Like he was saying hello.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[thoughtful] Or saying thank you?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[emotional] Maybe. Maybe saying: I see you. You've been watching me build my home. You've been here for this journey. [pause] And then after about thirty seconds, he withdrew to his fortress, and I surfaced. [voice breaking slightly] And I cried into my mask the whole way up.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio_enhanced/segment5_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio_enhanced/segment5_the_moment.mp3" "$audio_url"
    echo "✅ Segment 5 generated"
else
    echo "❌ Segment 5 failed"
fi

sleep 2

# SEGMENT 6: CLOSING - Enhanced with reflection
echo "📻 Segment 6: What Home Means & Closing (ENHANCED)..."
cat > podcast_audio_enhanced/segment6_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "[thoughtful] So you went out to answer the question: what does home mean to an alien intelligence? [pause] What did you learn?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[long pause] [exhales] [thoughtful] I learned that home isn't a place. It's not just shelter or safety or territory, though it's all of those things. [soft] Home is what happens when intelligence meets environment and says: this is where I belong. [pause] For Cosmos, home was a fortress he engineered himself, a community he learned to navigate, skills he mastered through trial and error, and neighbors he learned to communicate with in the language of color.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[warm] Charlotte, thank you for sharing Cosmos's story with us. And for reminding us that intelligence and consciousness exist in forms we're only beginning to understand.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[grateful] Thank you for having me, Mark. And for everyone listening - [passionate] the ocean is FULL of minds like Cosmos. Some have eight arms, some have three hearts, but all of them have something to teach us. [soft] All of them deserve to be seen.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[warm and closing] That was marine biologist Charlotte, sharing the story of Cosmos - an octopus searching for home. I'm Mark, and this is Hidden Nature - finding the extraordinary minds hiding in plain sight. [soft] Until next time, stay curious.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio_enhanced/segment6_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio_enhanced/segment6_closing.mp3" "$audio_url"
    echo "✅ Segment 6 generated"
else
    echo "❌ Segment 6 failed"
fi

echo ""
echo "✨ ===================================== ✨"
echo "   ENHANCED PODCAST AUDIO COMPLETE!"
echo "✨ ===================================== ✨"
echo ""
echo "📁 Generated enhanced segments:"
ls -lh podcast_audio_enhanced/*.mp3 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
echo ""
echo "🎭 Audio tags used:"
echo "   • [warm], [welcoming], [excited], [curious]"
echo "   • [chuckles], [laughs], [sighs], [exhales]"
echo "   • [whispers], [thoughtful], [emotional]"
echo "   • [pause], [short pause], [long pause]"
echo "   • [inhales], [inhales sharply]"
echo ""
echo "🎙️ Next: Compare with non-enhanced version"
echo ""


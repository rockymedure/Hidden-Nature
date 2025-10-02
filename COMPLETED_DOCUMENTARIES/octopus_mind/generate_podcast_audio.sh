#!/bin/bash
# Generate podcast audio using ElevenLabs text-to-dialogue
# Mark: 1SM7GgM6IMuvQlz2BwM3 | Lucy (Charlotte): lcMyyd2HUfFzxdCaC4Ta

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

echo "🎙️ GENERATING PODCAST AUDIO"
echo "==========================="
echo ""
echo "Voices:"
echo "  Mark (Jeff): gs0tAILXbY5DNrJrsM6F"
echo "  Charlotte (Lucy): lcMyyd2HUfFzxdCaC4Ta"
echo ""

ENDPOINT="https://fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3"
MARK_VOICE="gs0tAILXbY5DNrJrsM6F"
CHARLOTTE_VOICE="lcMyyd2HUfFzxdCaC4Ta"

# Create output directory
mkdir -p podcast_audio

echo "🎬 Generating podcast segments..."
echo ""

# SEGMENT 1: INTRO (0-2 min)
echo "📻 Segment 1: Intro & Welcome..."
cat > podcast_audio/segment1_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "Welcome back to Hidden Nature, where we explore the extraordinary minds hiding in plain sight all around us. I'm Mark, and today I'm sitting down with marine biologist Charlotte, who just returned from a month-long expedition documenting one of the ocean's most remarkable creatures. Charlotte, welcome to the show.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Thanks for having me, Mark. I'm still processing everything I witnessed out there.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "You spent thirty days observing a single octopus you named Cosmos. That's... dedication. What made you commit to watching one animal for an entire month?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[laughs] You know, my colleagues thought I was crazy too. But here's the thing - we film octopuses all the time. We document their hunting, their camouflage, their intelligence. But we never just... sit with one. Watch them live. And I had this question I couldn't shake: what does home mean to an intelligence that evolved completely separately from us?",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "An alien intelligence.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Exactly. Five hundred million years of separate evolution. Their brains don't look like ours. They have neurons in their arms - literally nine brains coordinating together. But when you watch them long enough... they're searching for the same things we are.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio/segment1_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio/segment1_intro.mp3" "$audio_url"
    echo "✅ Segment 1 generated"
else
    echo "❌ Segment 1 failed"
fi

sleep 2

# SEGMENT 2: FIRST CONTACT (2-4 min)
echo "📻 Segment 2: First Contact..."
cat > podcast_audio/segment2_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "Take me back to day one. What was your first impression of Cosmos?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "So it's 7:43 in the morning - I know the exact time because I nearly dropped my underwater camera. I'd been waiting at this rocky outcropping, and suddenly these eight arms just... unfurl from the crevice. Like watching a flower bloom, except this flower has three hearts and blue blood.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "[laughs] Not your typical flower.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Not typical at all. But what struck me immediately was how deliberate he was. Most octopuses emerge and immediately start hunting or moving. Cosmos paused. Just hung there, arms spread, taking in the entire reef. His skin was doing this thing - these color patterns I'd never seen before. Maroons bleeding into electric blues. And I remember thinking: he's thinking. He's making calculations about his world.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "You say he. How do you know it was male?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Honestly? I don't. Giant Pacific octopuses are hard to sex from observation. But after a few days, it just felt wrong. I was watching someone, not something. So Cosmos became he.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "And that someone was homeless.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Completely. And that's what made the next three weeks so fascinating.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio/segment2_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio/segment2_first_contact.mp3" "$audio_url"
    echo "✅ Segment 2 generated"
else
    echo "❌ Segment 2 failed"
fi

sleep 2

# SEGMENT 3: THE SEARCH (4-6 min)
echo "📻 Segment 3: The Search for Home..."
cat > podcast_audio/segment3_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "Walk me through what you mean by homeless octopus.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Okay, so imagine you're house-hunting, but your entire survival depends on finding the perfect spot. Cosmos would approach a crevice - always leading with his left front arm, by the way - and just... investigate. Testing the walls, measuring the space, checking the angles to the current, mapping out potential escape routes.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "Wait, he's thinking about escape routes while house hunting?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Always. These are prey animals living in a world full of sharks. Every home needs to be a fortress. And I watched him reject spot after spot. Too exposed. Too shallow. Wrong angle. He had standards.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "This sounds remarkably human.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "That's the thing that kept hitting me. Here's a creature whose last common ancestor with us was some simple worm-like thing half a billion years ago. And he's house-hunting with the same criteria I'd use: safety, accessibility, good sightlines, multiple exits.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "So when did he find his perfect place?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Day eight. And Mark, when he found it, you could see it in his body language. His chromatophores - those color-changing cells - shifted to calmer tones. His movements slowed. He'd found it.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio/segment3_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio/segment3_the_search.mp3" "$audio_url"
    echo "✅ Segment 3 generated"
else
    echo "❌ Segment 3 failed"
fi

sleep 2

# SEGMENT 4: ENGINEERING (6-8 min)
echo "📻 Segment 4: Building the Fortress..."
cat > podcast_audio/segment4_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "But finding it wasn't enough, was it?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Oh no, finding it was just the beginning. Then came the engineering phase, and this is where Cosmos completely blew my mind.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "Tell me about the engineering.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "For four days straight, I watched him collect materials. Coconut shell halves, smooth stones, broken coral fragments, even a bottle cap someone had littered. He'd carry three, sometimes four objects at once in his arms, bring them back, and arrange them with this obsessive precision.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "He was building walls?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Not just building - designing. Every shell was tested for fit. Every stone was positioned to create defensive barriers while maintaining escape routes. And here's the crazy part: one day I watched him pick up a rock, examine it with his suckers - which can taste and feel simultaneously, by the way - rotate it 180 degrees, and place it in a completely different location. Then he stepped back and looked at his work.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "Wait, he revised his design?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "He revised his design! My research partner surfaced next to me and through our regulators she managed to say: Did that octopus just edit his architecture? And yes. Yes, he did.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio/segment4_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio/segment4_engineering.mp3" "$audio_url"
    echo "✅ Segment 4 generated"
else
    echo "❌ Segment 4 failed"
fi

sleep 2

# SEGMENT 5: THE MOMENT (8-10 min)
echo "📻 Segment 5: The Recognition Moment..."
cat > podcast_audio/segment5_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "There's a moment in your field journal - day 27 - that really struck me. Can you talk about what happened?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[pause] Yeah. That's... that's the day I'll remember forever.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "Take your time.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "So I'd been documenting Cosmos for almost four weeks. Same time every day, same careful approach, same respectful distance. Professional distance, right? I'm a scientist, he's my research subject. But on day 27, I descended to my usual spot about fifteen feet from his fortress. I settled in, turned on my camera, and Cosmos emerged. But this time, he came toward me. Not hunting behavior. Not threat display. Just... approached.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "How close?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Two feet from my camera lens. Close enough that I could see every detail. And then he looked directly into my lens. Not at the camera as an object. Into it. At me.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "What did that feel like?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Terrifying and beautiful at the same time. Every instinct said maintain scientific distance. Every protocol said don't interact. But Mark, he was looking at me. His skin shifted to calm colors. His arms relaxed. And one arm extended slightly - not touching, just reaching. Like he was saying hello.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "Or saying thank you?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Maybe. Maybe saying: I see you. You've been watching me build my home. You've been here for this journey. And then after about thirty seconds, he withdrew to his fortress, and I surfaced. And I cried into my mask the whole way up.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio/segment5_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio/segment5_the_moment.mp3" "$audio_url"
    echo "✅ Segment 5 generated"
else
    echo "❌ Segment 5 failed"
fi

sleep 2

# SEGMENT 6: CLOSING
echo "📻 Segment 6: What Home Means & Closing..."
cat > podcast_audio/segment6_request.json << 'EOF'
{
  "inputs": [
    {
      "text": "So you went out to answer the question: what does home mean to an alien intelligence? What did you learn?",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "[thoughtful pause] I learned that home isn't a place. It's not just shelter or safety or territory, though it's all of those things. Home is what happens when intelligence meets environment and says: this is where I belong. For Cosmos, home was a fortress he engineered himself, a community he learned to navigate, skills he mastered through trial and error, and neighbors he learned to communicate with in the language of color.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "Charlotte, thank you for sharing Cosmos's story with us. And for reminding us that intelligence and consciousness exist in forms we're only beginning to understand.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    },
    {
      "text": "Thank you for having me, Mark. And for everyone listening - the ocean is full of minds like Cosmos. Some have eight arms, some have three hearts, but all of them have something to teach us. All of them deserve to be seen.",
      "voice": "lcMyyd2HUfFzxdCaC4Ta"
    },
    {
      "text": "That was marine biologist Charlotte, sharing the story of Cosmos - an octopus searching for home. I'm Mark, and this is Hidden Nature - finding the extraordinary minds hiding in plain sight. Until next time, stay curious.",
      "voice": "gs0tAILXbY5DNrJrsM6F"
    }
  ]
}
EOF

response=$(curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Key $FAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d @podcast_audio/segment6_request.json)

audio_url=$(echo "$response" | jq -r '.audio.url')
if [[ -n "$audio_url" && "$audio_url" != "null" ]]; then
    curl -s -o "podcast_audio/segment6_closing.mp3" "$audio_url"
    echo "✅ Segment 6 generated"
else
    echo "❌ Segment 6 failed"
fi

echo ""
echo "✨ ================================ ✨"
echo "   PODCAST AUDIO COMPLETE!"
echo "✨ ================================ ✨"
echo ""
echo "📁 Generated segments:"
ls -lh podcast_audio/*.mp3 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
echo ""
echo "🎙️ Next: Concatenate segments into final podcast"
echo ""


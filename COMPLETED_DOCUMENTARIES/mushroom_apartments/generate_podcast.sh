#!/bin/bash

# Generate Anju's Podcast Episode
# Using Brooklyn voice for Anju and Mark for Jeff

set -e

echo "🎙️  GENERATING MUSHROOM APARTMENTS PODCAST"
echo "=========================================="

FAL_KEY="${FAL_KEY}"
OUTPUT_DIR="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments"

# Create the dialogue in the format expected by ElevenLabs
cat > /tmp/podcast_dialogue.json << 'EOF'
{
  "dialogue": [
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "Welcome back to Hidden Nature. I'm Jeff, and today I'm sitting down with field ecologist Anju, who just returned from three weeks studying what she calls \"mushroom apartments\" in the Pacific Northwest. Anju, welcome."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Thanks for having me, Jeff. I'm still finding forest dirt in my gear."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "So, mushroom apartments. That's not exactly standard scientific terminology."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "No, it's not. But the first time I crouched down with my magnifying glass and really watched what was happening, that's what I saw. Tiny residents moving in, setting up shop, raising families. Like watching a whole apartment complex come to life in fast-forward."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "What made you start looking at mushrooms this way?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Most people see a mushroom and think \"Oh, a mushroom.\" They see one thing. But I was tracking fungus gnats for another project, and I kept losing them. They'd just vanish. Turns out they weren't vanishing—they were checking into the mushroom hotel."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "And once you started looking closer..."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "It became obsessive. I'd set up my camera on a fresh mushroom at dawn, let it record all day. By evening, there'd be dozens of species that had moved through. Some stayed, some were just passing through. Some were predators hunting the residents."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "That's wild. How long does a mushroom actually last as a functioning habitat?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "That's the fascinating part. Most mushrooms only last about two weeks from emergence to collapse. But in those two weeks, they go through a complete lifecycle as an ecosystem. Day one, pioneers arrive. By day seven, you've got established residents, predators, even parasites. By day fourteen, it's condemned—everyone evacuates and it collapses."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "In the documentary, there's this moment with a slug that has 27,000 teeth. I had to rewind that."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "The banana slug radula! That's one of my favorite shots. Most people think slugs just sort of... ooze onto mushrooms and absorb them. But they have this ribbon of microscopic teeth—a radula—that's specifically adapted for scraping fungal tissue. 27,000 teeth, arranged in rows. It's like a biological cheese grater."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "And they're picky eaters?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Incredibly picky. Some slug species will only eat specific mushroom species. They'll crawl right past a perfectly good mushroom because it's the wrong flavor. Which tells you how diverse and specific these relationships are."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "What about the predators? You showed pseudoscorpions living inside the gills."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Those were tricky to film. Pseudoscorpions are tiny—like 3 millimeters—but they're fierce. They have venom, they have pincers, and they set up ambush points in the mushroom's internal chambers. They're basically tiny landlords that eat the tenants."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "Then you get into the zombie fungi. That's where things get... unsettling."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Cordyceps. Yeah. That's where you realize fungi aren't just passive apartment buildings—some are puppet masters. Ophiocordyceps infects an ant, hijacks its brain, makes it climb to a very specific height and temperature, clamp down, and then kills it. Then the fungus erupts out of the ant's head and releases spores to infect the next generation."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "The precision is what's disturbing. It's not random."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "It's not random at all. The fungus needs specific conditions for spore dispersal, so it forces the ant to position itself perfectly. It's beautiful and horrifying at the same time. Nature doesn't care about our categories."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "There's also summit disease—flies climbing up high before the fungus bursts out."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Entomophthora muscae. Same concept, different host. The fungus makes the fly climb to the highest point it can find, then kills it and releases spores from above. Gravity and wind do the rest. It's extremely efficient."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "You also show squirrels and deer interacting with mushrooms in unexpected ways."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Right. So we think of mushrooms as decomposers, which they are. But they're also nutritional supplements for animals that can't get certain minerals from plants alone. Deer seek out specific mushroom species because they need trace minerals. And squirrels—squirrels are amazing. They harvest mushrooms, impale them on tree branches to dry like jerky, and store them for winter."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "Wait, they dry them first?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "They dry them first! They know fresh mushrooms will rot, so they create these little drying racks. It's food preservation. I watched one squirrel manage about forty mushrooms across three trees."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "When you step back and look at the whole system, what are we really looking at here?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "We're looking at cities within cities. Most people walk through a forest and see trees. But underneath and between those trees, there are these microcosms—mushroom ecosystems that rise and fall in two-week cycles. Each one supporting dozens of species. Each one connected to the underground mycelial network that connects the trees."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "It changes how you see a forest."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Completely. A forest isn't just trees and animals. It's layers of interconnected systems, most of which we don't see unless we crouch down and really look. The mushrooms are just the visible part—the fruiting bodies. The real network is underground, miles of fungal threads connecting everything."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "What's the hardest part of documenting this stuff?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Time-lapse patience and macro focus. You're filming things that are 2 millimeters long, often moving, in terrible lighting conditions on a forest floor. My back was destroyed after three weeks of crouching. But also, timing. You have to predict when a mushroom will emerge, where, and what species will show up. A lot of waiting, a lot of missed shots."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "But when you get the shot..."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "When you get the shot, it's magic. Watching a nematode get caught in a fungal snare, seeing the noose tighten in real-time—you're watching something most humans will never see. That makes the sore back worth it."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "Is there a conservation message here?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Absolutely. When we talk about protecting forests, we focus on trees and large animals. But if you remove the fungi, the whole system collapses. Fungi are the circulatory system of the forest—they move nutrients, they break down dead matter, they support hundreds of species we barely understand. We're only beginning to catalog fungal diversity, and we're already losing species to habitat loss and climate change."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "So protecting mushrooms means protecting everything around them."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Exactly. It's not just about the mushrooms—it's about the springtails farming bacteria inside them, the beetles that depend on them, the birds that eat those beetles, the trees that rely on the fungal network. It's all connected."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "Last question: what's something you saw in the field that didn't make it into the documentary?"
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Oh, there was this moment—about day ten of filming—where I was lying on my stomach at dusk, camera pointed at a mushroom cluster, and a young deer walked right up to me. Just stood there, maybe six feet away, watching me watch the mushrooms. We locked eyes. I swear it knew exactly what I was doing. Then it delicately bit the top off one mushroom and walked away. Like, \"I see you, researcher. This is my forest.\""
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "That's a perfect moment."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "It was. Reminded me why I do this. We're guests in their world, trying to document the incredible stuff that's always happening, whether we're watching or not."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "Anju, thank you so much for sharing this. And thank you for bringing us into the mushroom apartments."
    },
    {
      "speaker_id": "zWoalRDt5TZrmW4ROIA7",
      "text": "Thanks for having me, Jeff. Now if you'll excuse me, I need to go wash forest dirt out of literally everything I own."
    },
    {
      "speaker_id": "gs0tAILXbY5DNrJrsM6F",
      "text": "That's Anju, forest floor ecologist and mushroom apartment tour guide. You can watch \"The Mushroom Apartments\" on our channel, and find Anju's field journal on our Substack. I'm Jeff, this is Hidden Nature. Thanks for listening."
    }
  ]
}
EOF

echo ""
echo "📝 Dialogue prepared with ${speaker_count} exchanges"
echo ""
echo "🎬 Generating podcast audio..."
echo "   Jeff: Mark (gs0tAILXbY5DNrJrsM6F)"
echo "   Anju: Brooklyn (zWoalRDt5TZrmW4ROIA7)"
echo ""

# Generate podcast using fal.ai ElevenLabs text-to-dialogue API
RESPONSE=$(curl -s -X POST "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3" \
  -H "Authorization: Key ${FAL_KEY}" \
  -H "Content-Type: application/json" \
  -d @/tmp/podcast_dialogue.json)

REQUEST_ID=$(echo "$RESPONSE" | grep -o '"request_id":"[^"]*"' | cut -d'"' -f4)

if [ -z "$REQUEST_ID" ]; then
  echo "❌ Error: No request ID returned"
  echo "$RESPONSE"
  exit 1
fi

echo "⏳ Request ID: $REQUEST_ID"
echo "   Waiting for podcast generation..."

# Poll for completion
MAX_ATTEMPTS=60
ATTEMPT=0
while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  sleep 5
  ATTEMPT=$((ATTEMPT + 1))
  
  STATUS_RESPONSE=$(curl -s "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3/requests/${REQUEST_ID}/status" \
    -H "Authorization: Key ${FAL_KEY}")
  
  STATUS=$(echo "$STATUS_RESPONSE" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
  
  if [ "$STATUS" = "COMPLETED" ]; then
    echo "✅ Podcast generation complete!"
    
    # Get the result
    RESULT=$(curl -s "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3/requests/${REQUEST_ID}" \
      -H "Authorization: Key ${FAL_KEY}")
    
    AUDIO_URL=$(echo "$RESULT" | grep -o '"audio_url":{"url":"[^"]*"' | cut -d'"' -f6)
    
    if [ -z "$AUDIO_URL" ]; then
      echo "❌ Error: No audio URL in response"
      echo "$RESULT"
      exit 1
    fi
    
    echo "📥 Downloading podcast..."
    curl -s -o "${OUTPUT_DIR}/PODCAST_ANJU_MUSHROOM_APARTMENTS.mp3" "$AUDIO_URL"
    
    echo ""
    echo "🎉 SUCCESS!"
    echo "=========================================="
    echo "Podcast saved to:"
    echo "  ${OUTPUT_DIR}/PODCAST_ANJU_MUSHROOM_APARTMENTS.mp3"
    echo ""
    echo "Duration: ~15-20 minutes"
    echo "Voices: Jeff (Mark) & Anju (Brooklyn)"
    echo ""
    
    # Clean up
    rm /tmp/podcast_dialogue.json
    
    exit 0
  elif [ "$STATUS" = "FAILED" ]; then
    echo "❌ Podcast generation failed"
    echo "$STATUS_RESPONSE"
    exit 1
  fi
  
  echo "   Still processing... (attempt $ATTEMPT/$MAX_ATTEMPTS)"
done

echo "❌ Timeout waiting for podcast generation"
exit 1


#!/bin/bash

# Generate Full Podcast in Thematic Segments
# Model: fal-ai/elevenlabs/text-to-dialogue/eleven-v3
# Each segment saved separately for social media clips

echo "🎙️  GENERATING FULL SEGMENTED PODCAST"
echo "======================================"
echo ""

FAL_KEY="9a4a90eb-250b-4953-95e4-86c2db1695fc:61a4e14a87c8e1e87820fe44e8317856"
OUTPUT_DIR="/Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/mushroom_apartments/podcast_segments_full"

mkdir -p "$OUTPUT_DIR"

# Voice IDs
JEFF_VOICE="iP95p4xoKVk53GoZ742B"    # Chris (male)
ANJU_VOICE="cgSgspJ2msm6clMCkdW9"    # Jessica (female)

# Function to generate a segment
generate_segment() {
    local segment_num=$1
    local segment_name=$2
    local dialogue_json=$3
    
    echo "🎬 Generating Segment $segment_num: $segment_name..."
    
    # Submit request
    RESPONSE=$(curl -s -X POST "https://queue.fal.run/fal-ai/elevenlabs/text-to-dialogue/eleven-v3" \
        -H "Authorization: Key ${FAL_KEY}" \
        -H "Content-Type: application/json" \
        -d "$dialogue_json")
    
    REQUEST_ID=$(echo "$RESPONSE" | jq -r '.request_id' 2>/dev/null)
    
    if [ -z "$REQUEST_ID" ] || [ "$REQUEST_ID" = "null" ]; then
        echo "❌ Error: No request ID for segment $segment_num"
        return 1
    fi
    
    echo "   Request ID: $REQUEST_ID"
    echo "   Waiting for generation..."
    
    # Poll for completion
    MAX_ATTEMPTS=60
    ATTEMPT=0
    
    while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
        sleep 3
        ATTEMPT=$((ATTEMPT + 1))
        
        STATUS_RESPONSE=$(curl -s "https://queue.fal.run/fal-ai/elevenlabs/requests/${REQUEST_ID}/status" \
            -H "Authorization: Key ${FAL_KEY}")
        
        STATUS=$(echo "$STATUS_RESPONSE" | jq -r '.status' 2>/dev/null)
        
        if [ "$STATUS" = "COMPLETED" ]; then
            # Get the result
            RESULT=$(curl -s "https://queue.fal.run/fal-ai/elevenlabs/requests/${REQUEST_ID}" \
                -H "Authorization: Key ${FAL_KEY}")
            
            AUDIO_URL=$(echo "$RESULT" | jq -r '.audio.url // empty' 2>/dev/null)
            
            if [ -z "$AUDIO_URL" ]; then
                echo "❌ Error: No audio URL for segment $segment_num"
                return 1
            fi
            
            # Download
            curl -s -o "${OUTPUT_DIR}/segment_${segment_num}_${segment_name}.mp3" "$AUDIO_URL"
            echo "✅ Segment $segment_num complete: ${segment_name}.mp3"
            echo ""
            return 0
        elif [ "$STATUS" = "FAILED" ]; then
            echo "❌ Generation failed for segment $segment_num"
            return 1
        fi
        
        if [ $((ATTEMPT % 5)) -eq 0 ]; then
            echo "   Still processing... ($ATTEMPT/$MAX_ATTEMPTS)"
        fi
    done
    
    echo "❌ Timeout for segment $segment_num"
    return 1
}

# SEGMENT 1: OPENING
echo "════════════════════════════════════════"
echo "SEGMENT 1: Opening & Introduction"
echo "════════════════════════════════════════"
generate_segment "01" "opening" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[warm] Welcome back to Hidden Nature. I'\''m Jeff, and today I'\''m sitting down with field ecologist Anju, who just returned from three weeks studying what she calls mushroom apartments in the Pacific Northwest. [curious] Anju, welcome."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[chuckles] Thanks for having me, Jeff. [sighs] I'\''m STILL finding forest dirt in my gear."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[amused] So... mushroom apartments. That'\''s not exactly standard scientific terminology."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[laughs] No, it'\''s not. But the first time I crouched down with my magnifying glass and really watched what was happening... [excited] that'\''s what I saw. Tiny residents moving in, setting up shop, raising families. Like watching a whole apartment complex come to life in fast-forward."
    }
  ]
}'

# SEGMENT 2: THE DISCOVERY
echo "════════════════════════════════════════"
echo "SEGMENT 2: The Discovery"
echo "════════════════════════════════════════"
generate_segment "02" "discovery" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[interested] What made you start looking at mushrooms this way?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[thoughtful] Most people see a mushroom and think Oh, a mushroom. They see one thing. But I was tracking fungus gnats for another project, and I kept LOSING them. [frustrated] They'\''d just... vanish. [pause] Turns out they weren'\''t vanishing—[excited] they were checking into the mushroom hotel!"
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "And once you started looking closer..."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[enthusiastically] It became OBSESSIVE. I'\''d set up my camera on a fresh mushroom at dawn, let it record all day. By evening... [amazed] there'\''d be DOZENS of species that had moved through. Some stayed, some were just passing through. Some were predators hunting the residents."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[surprised] That'\''s wild. How long does a mushroom actually last as a functioning habitat?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[excited] That'\''s the fascinating part! Most mushrooms only last about two weeks from emergence to collapse. But in those two weeks, they go through a COMPLETE lifecycle as an ecosystem. [explaining] Day one, pioneers arrive. By day seven, you'\''ve got established residents, predators, even parasites. By day fourteen... [pause] it'\''s condemned—everyone evacuates and it collapses."
    }
  ]
}'

# SEGMENT 3: UNEXPECTED RESIDENTS
echo "════════════════════════════════════════"
echo "SEGMENT 3: Unexpected Residents"
echo "════════════════════════════════════════"
generate_segment "03" "residents" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[curious] In the documentary, there'\''s this moment with a slug that has 27,000 teeth. I had to rewind that."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[laughs] The banana slug radula! [excited] That'\''s one of my FAVORITE shots. Most people think slugs just sort of... [slowly] ooze onto mushrooms and absorb them. But they have this ribbon of microscopic teeth—a radula—that'\''s specifically adapted for scraping fungal tissue. [amazed] 27,000 teeth, arranged in ROWS. It'\''s like a biological cheese grater."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[surprised] And they'\''re picky eaters?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[enthusiastically] INCREDIBLY picky. Some slug species will only eat specific mushroom species. They'\''ll crawl right PAST a perfectly good mushroom because it'\''s the wrong flavor. [pause] Which tells you how diverse and specific these relationships are."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[intrigued] What about the predators? You showed pseudoscorpions living inside the gills."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[excited] Oh! Those were TRICKY to film. Pseudoscorpions are tiny—like 3 millimeters—but they'\''re FIERCE. [dramatically] They have venom, they have pincers, and they set up ambush points in the mushroom'\''s internal chambers. [chuckles] They'\''re basically tiny landlords that eat the tenants."
    }
  ]
}'

# SEGMENT 4: THE DARK SIDE
echo "════════════════════════════════════════"
echo "SEGMENT 4: The Dark Side"
echo "════════════════════════════════════════"
generate_segment "04" "dark_side" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[cautiously] Then you get into the zombie fungi. [pause] That'\''s where things get... unsettling."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[sighs] Cordyceps. Yeah. [thoughtful] That'\''s where you realize fungi aren'\''t just passive apartment buildings—[dramatically] some are puppet masters. Ophiocordyceps infects an ant, hijacks its brain, makes it climb to a very specific height and temperature, clamp down... [pause] and then kills it. Then the fungus erupts out of the ant'\''s head and releases spores to infect the next generation."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[disturbed] The precision is what'\''s disturbing. It'\''s not random."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[seriously] It'\''s not random at ALL. The fungus needs specific conditions for spore dispersal, so it forces the ant to position itself perfectly. [pause] It'\''s beautiful and horrifying at the same time. [reflectively] Nature doesn'\''t care about our categories."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[curious] There'\''s also summit disease—flies climbing up high before the fungus bursts out."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[excited] Entomophthora muscae! Same concept, different host. The fungus makes the fly climb to the highest point it can find, then kills it and releases spores from above. [pause] Gravity and wind do the rest. It'\''s extremely efficient."
    }
  ]
}'

# SEGMENT 5: LARGER ECOSYSTEM
echo "════════════════════════════════════════"
echo "SEGMENT 5: Larger Ecosystem Connections"
echo "════════════════════════════════════════"
generate_segment "05" "ecosystem" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[interested] You also show squirrels and deer interacting with mushrooms in unexpected ways."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[enthusiastically] Right! So we think of mushrooms as decomposers, which they are. But they'\''re ALSO nutritional supplements for animals that can'\''t get certain minerals from plants alone. [explaining] Deer seek out specific mushroom species because they need trace minerals. And squirrels—[excited] squirrels are AMAZING. They harvest mushrooms, impale them on tree branches to dry like jerky, and store them for winter."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[surprised] Wait... they dry them FIRST?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[laughs] They dry them first! They KNOW fresh mushrooms will rot, so they create these little drying racks. [amazed] It'\''s food preservation. I watched one squirrel manage about FORTY mushrooms across three trees."
    }
  ]
}'

# SEGMENT 6: THE BIGGER PICTURE
echo "════════════════════════════════════════"
echo "SEGMENT 6: The Bigger Picture"
echo "════════════════════════════════════════"
generate_segment "06" "bigger_picture" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[thoughtfully] When you step back and look at the whole system, what are we really looking at here?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[reflectively] We'\''re looking at cities within cities. [pause] Most people walk through a forest and see trees. But underneath and between those trees, there are these microcosms—[explaining] mushroom ecosystems that rise and fall in two-week cycles. Each one supporting DOZENS of species. Each one connected to the underground mycelial network that connects the trees."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[impressed] It changes how you see a forest."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[emphatically] COMPLETELY. A forest isn'\''t just trees and animals. It'\''s layers of interconnected systems, most of which we don'\''t see unless we crouch down and really LOOK. [pause] The mushrooms are just the visible part—the fruiting bodies. The real network is underground... [amazed] miles of fungal threads connecting everything."
    }
  ]
}'

# SEGMENT 7: FIELD RESEARCH
echo "════════════════════════════════════════"
echo "SEGMENT 7: Field Research Challenges"
echo "════════════════════════════════════════"
generate_segment "07" "research" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[curious] What'\''s the hardest part of documenting this stuff?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[sighs] Time-lapse patience and macro focus. You'\''re filming things that are 2 millimeters long, often moving, in TERRIBLE lighting conditions on a forest floor. [chuckles] My back was destroyed after three weeks of crouching. But also... [thoughtfully] timing. You have to predict when a mushroom will emerge, where, and what species will show up. A lot of waiting, a lot of missed shots."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[encouragingly] But when you get the shot..."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[excited] When you get the shot, it'\''s MAGIC. [pause] Watching a nematode get caught in a fungal snare, seeing the noose tighten in real-time—[amazed] you'\''re watching something most humans will NEVER see. That makes the sore back worth it."
    }
  ]
}'

# SEGMENT 8: CONSERVATION
echo "════════════════════════════════════════"
echo "SEGMENT 8: Conservation Message"
echo "════════════════════════════════════════"
generate_segment "08" "conservation" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[seriously] Is there a conservation message here?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[emphatically] Absolutely. When we talk about protecting forests, we focus on trees and large animals. But if you remove the fungi... [pause] the whole system collapses. [explaining] Fungi are the circulatory system of the forest—they move nutrients, they break down dead matter, they support HUNDREDS of species we barely understand. [concerned] We'\''re only beginning to catalog fungal diversity, and we'\''re already losing species to habitat loss and climate change."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[thoughtfully] So protecting mushrooms means protecting everything around them."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[emphatically] EXACTLY. It'\''s not just about the mushrooms—[explaining] it'\''s about the springtails farming bacteria inside them, the beetles that depend on them, the birds that eat those beetles, the trees that rely on the fungal network. [pause] It'\''s all connected."
    }
  ]
}'

# SEGMENT 9: CLOSING
echo "════════════════════════════════════════"
echo "SEGMENT 9: Closing & Farewell"
echo "════════════════════════════════════════"
generate_segment "09" "closing" '{
  "inputs": [
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[warmly] Last question: what'\''s something you saw in the field that didn'\''t make it into the documentary?"
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[chuckles] Oh... [reflectively] there was this moment—about day ten of filming—where I was lying on my stomach at dusk, camera pointed at a mushroom cluster, and a young deer walked right up to me. [pause] Just stood there, maybe six feet away, watching me watch the mushrooms. We locked eyes. [amazed] I SWEAR it knew exactly what I was doing. Then it delicately bit the top off one mushroom and walked away. [laughs] Like, I see you, researcher. This is MY forest."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[warmly] That'\''s a perfect moment."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[softly] It was. [pause] Reminded me why I do this. We'\''re guests in their world, trying to document the incredible stuff that'\''s always happening... [reflectively] whether we'\''re watching or not."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[warmly] Anju, thank you so much for sharing this. And thank you for bringing us into the mushroom apartments."
    },
    {
      "voice": "'"$ANJU_VOICE"'",
      "text": "[laughs] Thanks for having me, Jeff. Now if you'\''ll excuse me... [sighs] I need to go wash forest dirt out of literally EVERYTHING I own."
    },
    {
      "voice": "'"$JEFF_VOICE"'",
      "text": "[chuckles] That'\''s Anju, forest floor ecologist and mushroom apartment tour guide. You can watch The Mushroom Apartments on our channel, and find Anju'\''s field journal on our Substack. I'\''m Jeff, this is Hidden Nature. [warmly] Thanks for listening."
    }
  ]
}'

echo ""
echo "🎉 ALL SEGMENTS GENERATED!"
echo "======================================"
echo ""
echo "📂 Segment Files:"
ls -1 "${OUTPUT_DIR}"/*.mp3 | while read file; do
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null)
    filename=$(basename "$file")
    echo "   $filename (${duration%.*}s)"
done

echo ""
echo "💡 Next Steps:"
echo "   1. Listen to individual segments"
echo "   2. Use segments for social media clips"
echo "   3. Run concatenation script to create full podcast"
echo ""
echo "To create full podcast, run:"
echo "   ./concatenate_podcast_segments.sh"
echo ""


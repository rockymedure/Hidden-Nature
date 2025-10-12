#!/usr/bin/env python3
import os
import json
import subprocess
import time
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed

# Load API key
FAL_API_KEY = os.getenv('FAL_API_KEY')
AUDIO_ENDPOINT = "https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT = "https://fal.run/fal-ai/veo3/fast"
MUSIC_ENDPOINT = "https://fal.run/fal-ai/stable-audio-25/text-to-audio"
NARRATOR_VOICE_ID = "pN2Hqj1221g5xYQh0221"  # Charlotte

# Concept data
CONCEPTS = {
    "jumping_spider": {
        "name": "🕷️  Jumping Spider's Hunt",
        "seed": 11111,
        "scenes": [
            {
                "narration": "She sees you before you see her. Eight eyes. Each one tracking. Calculating. Waiting for the perfect moment.",
                "visual": "Jumping spider (Phidippus regius) with prominent large front eyes, compact fuzzy body, striped legs, on textured bark surface, extreme close-up of face showing massive forward-facing eyes with reflective quality, other six eyes visible on sides, patient stalking posture with legs coiled, prey (fly) visible blurred in background, macro nature photography, shallow depth of field, natural lighting, no speech, ambient forest sounds",
                "music": "Tense, suspenseful strings with subtle percussive ticking, building anticipation, Key: D minor, Tempo: 85 BPM"
            },
            {
                "narration": "No web needed. She's a hunter. One explosive jump. Thirty times her body length. No room for error.",
                "visual": "Jumping spider (Phidippus regius) with prominent large front eyes, compact fuzzy body, striped legs, mid-leap through air toward prey, legs extended, dragline silk visible trailing behind, freeze-frame quality capturing suspended moment, prey in sharp focus ahead, incredible athletic display, macro nature photography, fast shutter speed effect, dramatic lighting, no speech, ambient only",
                "music": "Explosive orchestral hit with rapid ascending strings, adrenaline rush, Key: D minor to D Major, Tempo: 120 BPM"
            },
            {
                "narration": "Gotcha. She didn't need venom or a web. Just perfect vision, patient timing, and incredible precision. Smartest spider alive.",
                "visual": "Jumping spider (Phidippus regius) with prominent large front eyes, compact fuzzy body, striped legs, holding captured fly with front legs, looking directly at camera with those huge eyes, victorious moment, sitting on leaf, satisfied posture, macro close-up showing detail of eyes and fuzzy body, natural daylight, no speech, ambient forest sounds",
                "music": "Triumphant but playful resolution, pizzicato strings with light woodwinds, clever and satisfied, Key: D Major, Tempo: 90 BPM"
            }
        ]
    },
    "cuttlefish": {
        "name": "🦑 Cuttlefish's Instant Disguise",
        "seed": 22222,
        "scenes": [
            {
                "narration": "Danger. A predator overhead. But she has a superpower. She can become invisible. And it happens in milliseconds.",
                "visual": "Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, floating above sandy ocean floor, currently displaying mottled brown/tan pattern matching sand, predatory shark silhouette visible in background, underwater scene with natural light filtering down, cuttlefish beginning to sense threat, no speech, ambient underwater sounds",
                "music": "Ominous low strings with ocean-like synth pad, underwater tension, Key: E minor, Tempo: 70 BPM"
            },
            {
                "narration": "Watch. Her skin erupts with patterns. Waves of color. Shifting textures. All controlled by millions of cells beneath her skin.",
                "visual": "Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, skin actively transforming in real-time, rapid succession of patterns (stripes, spots, waves) flowing across body, chromatophores visibly expanding and contracting, mesmerizing display of biological technology, extreme close-up showing skin texture changing, iridescent colors appearing, no speech, ambient underwater sounds",
                "music": "Hypnotic arpeggiated synths with fluid string movements, transformation theme, psychedelic documentary style, Key: E minor to E Major, Tempo: 85 BPM"
            },
            {
                "narration": "Perfect match. She's completely invisible. The predator swims past. And she's colorblind. She did all that without seeing color.",
                "visual": "Cuttlefish (Sepia officinalis) with W-shaped pupil eyes, eight arms, two longer tentacles, rippling fin along body edge, now perfectly camouflaged against rocky coral background, almost completely invisible, only subtle outline visible, predator (shark) passing overhead in frame, cuttlefish remains motionless and camouflaged, incredible demonstration of camouflage, underwater lighting, no speech, ambient underwater sounds",
                "music": "Quiet resolution with sparse ambient tones, wonder and mystery, ocean atmosphere, Key: E Major, Tempo: 60 BPM"
            }
        ]
    },
    "tardigrade": {
        "name": "🐻 Tardigrade's Survival Test",
        "seed": 33333,
        "scenes": [
            {
                "narration": "Meet the tardigrade. Less than a millimeter long. Eight legs. Looks like a microscopic bear. And he's nearly indestructible.",
                "visual": "Tardigrade (water bear) with plump segmented body, eight stubby legs with claws, cute bear-like face with simple mouth, translucent body showing internal organs, crawling on moss under microscope, adorable lumbering gait, extreme macro/microscopy view, brightfield illumination, scientific but charming, scaled to show full body, no speech, silent microscopy",
                "music": "Curious and whimsical, playful celesta and pizzicato strings, tiny explorer theme, Key: C Major, Tempo: 78 BPM"
            },
            {
                "narration": "Danger. Extreme cold. No water. But he has a trick. He shrinks. Hardens. Enters suspended animation. A tun state.",
                "visual": "Tardigrade (water bear) with plump segmented body, eight stubby legs with claws, actively contracting into tun state, legs retracting inward, body becoming barrel-shaped and hardened, time-lapse of transformation from active to dormant, microscopic view showing biological transformation, protective tun form, scientific microscopy, dramatic lighting shift, no speech, silent microscopy",
                "music": "Tense transformation music with descending tones, protective shell theme, biological survival, Key: C Major to C minor, Tempo: 65 BPM"
            },
            {
                "narration": "He can survive years like this. Frozen. Boiled. Even the vacuum of space. Then add water. And he just wakes up.",
                "visual": "Tardigrade (water bear) in hardened tun state, barrel-shaped and dormant, then water being added (visible droplet entering frame), tun beginning to expand, legs emerging, returning to active form, full reanimation, crawling again as if nothing happened, incredible biological resurrection, microscopy view, brightfield illumination, miracle of survival, no speech, silent microscopy",
                "music": "Triumphant resolution with building orchestral swell, survival victory, life finds a way theme, Key: C Major, Tempo: 80 BPM"
            }
        ]
    },
    "venus_flytrap": {
        "name": "🌿 Venus Flytrap's Lightning Strike",
        "seed": 44444,
        "scenes": [
            {
                "narration": "She sits. She waits. Jaws open. Six trigger hairs inside. Waiting for prey to make one critical mistake.",
                "visual": "Venus flytrap (Dionaea muscipula) with bright red-pink interior trap, white-green exterior, prominent trigger hairs visible inside trap, trap fully open in waiting position, menacing appearance despite being a plant, macro close-up showing trap detail, natural outdoor lighting, fly visible nearby approaching, carnivorous plant, no speech, ambient nature sounds",
                "music": "Patient suspense with sustained string notes, predatory waiting theme, botanical thriller, Key: F minor, Tempo: 55 BPM"
            },
            {
                "narration": "Trigger. Once. Twice. Snap! Two hundred milliseconds. One of the fastest movements in the entire plant kingdom. She's got him.",
                "visual": "Venus flytrap (Dionaea muscipula) with bright red-pink interior trap, white-green exterior, prominent trigger hairs, trap snapping shut in ultra-slow motion, fly caught inside mid-snap, trigger hairs bending as fly touches them, interlocking teeth/cilia closing like prison bars, dramatic moment of capture, extreme macro showing mechanism, high-speed camera effect, no speech, ambient nature sounds",
                "music": "Explosive percussive strike with sharp string stabs, lightning-fast attack, botanical power, Key: F minor to F Major, Tempo: 140 BPM momentary spike"
            },
            {
                "narration": "Sealed. She releases enzymes. Over ten days, she'll digest him completely. Then the trap opens again. Ready for the next meal.",
                "visual": "Venus flytrap (Dionaea muscipula) with bright red-pink interior trap now sealed shut, teeth/cilia interlocked forming tight seal, slight bulge where fly is trapped inside, time-lapse showing trap gradually reddening as digestion occurs, plant stomach at work, macro view of sealed trap, natural lighting, patient botanical predator, no speech, ambient nature sounds",
                "music": "Slow, ominous resolution with low sustained notes, digestive process theme, nature's patience, Key: F Major, Tempo: 50 BPM"
            }
        ]
    },
    "chameleon": {
        "name": "🦎 Chameleon's Color Conversation",
        "seed": 55555,
        "scenes": [
            {
                "narration": "He's calm. Relaxed. Bright green. His color is his mood. Every emotion has its own shade. And he's about to get angry.",
                "visual": "Chameleon (Furcifer pardalis) with turret-like independently rotating eyes, prehensile tail wrapped around branch, textured scaly skin, zygodactylous feet gripping branch, currently bright relaxed green coloration, sitting peacefully on tree branch, one eye rotating forward to spot intruder, tropical setting, macro detail showing scales and skin texture, no speech, ambient rainforest sounds",
                "music": "Calm ambient tropical tones with soft marimba, peaceful rainforest atmosphere, Key: G Major, Tempo: 65 BPM"
            },
            {
                "narration": "A rival appears. Watch his skin. Green fades. Yellows emerge. Reds ignite. Patterns explode across his body. This is rage.",
                "visual": "Chameleon (Furcifer pardalis) with turret-like independently rotating eyes, prehensile tail wrapped around branch, textured scaly skin, zygodactylous feet gripping branch, colors actively transforming in real-time, green to yellow to orange to red to bold patterns appearing, bands and stripes emerging, chromatophores visibly shifting, both eyes now focused forward in territorial display, mouth opening in threat display, aggressive color explosion, no speech, ambient rainforest sounds",
                "music": "Aggressive building percussion with dissonant strings, color eruption theme, territorial tension, Key: G Major to G minor, Tempo: 95 BPM"
            },
            {
                "narration": "Message sent. Message received. The rival backs down. His colors fade. Back to calm green. That's how chameleons talk.",
                "visual": "Chameleon (Furcifer pardalis) with turret-like independently rotating eyes, prehensile tail wrapped around branch, textured scaly skin, zygodactylous feet gripping branch, colors transitioning back to calm green, aggressive patterns fading, eyes rotating independently again (one forward, one back), relaxed posture returning, territorial display successful, winner on his branch, tropical setting, no speech, ambient rainforest sounds",
                "music": "Triumphant but calm resolution, returning to peaceful marimba, conversation complete, Key: G Major, Tempo: 68 BPM"
            }
        ]
    },
    "monarch": {
        "name": "🦋 Monarch's Impossible Journey",
        "seed": 66666,
        "scenes": [
            {
                "narration": "She just emerged. Wings still drying. But deep inside, something ancient is calling. South. Three thousand miles south. And she's never been there.",
                "visual": "Monarch butterfly (Danaus plexippus) with distinctive orange wings with black veins and white spots along edges, perched on milkweed plant, wings fully spread but still wet from emergence, sun backlighting translucent wings, beautiful but fragile, preparing for impossible journey, macro close-up showing wing detail and scales, natural outdoor lighting, no speech, ambient meadow sounds",
                "music": "Ethereal and mysterious, calling theme with distant woodwinds, journey beckons, Key: A minor, Tempo: 70 BPM"
            },
            {
                "narration": "She navigates by the sun. By Earth's magnetic field. By instinct coded in her DNA. Thousands of others join her. A river of orange in the sky.",
                "visual": "Monarch butterfly (Danaus plexippus) with distinctive orange wings with black veins and white spots along edges, in flight mid-journey, wings in graceful flight position, dozens of other monarchs visible in background creating migration cloud, flying over landscape (fields, forests), sun position visible for navigation, epic aerial journey, beautiful cinematography, mass migration spectacle, no speech, ambient wind and wing sounds",
                "music": "Soaring orchestral theme with ascending strings and French horns, epic journey music, migration theme, Key: A minor to A Major, Tempo: 88 BPM"
            },
            {
                "narration": "She made it. A forest in Mexico. Covered in millions of monarchs. She's never been here. But her great-great-grandparents were. And somehow, she found home.",
                "visual": "Monarch butterfly (Danaus plexippus) with distinctive orange wings with black veins and white spots along edges, landing on oyamel fir tree branch, thousands of other monarchs clustered on trees in background, trees literally covered in orange butterflies, sacred forest sanctuary, miracle of navigation complete, stunning congregation scene, warm golden light filtering through trees, no speech, ambient sounds of butterfly wings",
                "music": "Majestic triumphant resolution with full orchestra, ancestral home theme, genetic memory fulfilled, Key: A Major, Tempo: 75 BPM"
            }
        ]
    }
}

def call_api(url, headers, payload):
    """Call API and return JSON response"""
    cmd = ['curl', '-s', '-X', 'POST', url]
    for key, value in headers.items():
        cmd.extend(['-H', f"{key}: {value}"])
    cmd.extend(['-d', json.dumps(payload)])
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    try:
        return json.loads(result.stdout)
    except:
        print(f"Error: {result.stdout}")
        return None

def download_file(url, output_path):
    """Download file from URL"""
    subprocess.run(['curl', '-s', '-o', str(output_path), url], check=True)

def generate_narration(concept_name, scene_num, text, output_dir):
    """Generate narration audio"""
    payload = {
        "text": text,
        "voice": NARRATOR_VOICE_ID,
        "stability": 0.5,
        "similarity_boost": 0.75,
        "style": 0.7,
        "speed": 1.0
    }
    headers = {
        "Authorization": f"Key {FAL_API_KEY}",
        "Content-Type": "application/json"
    }
    
    response = call_api(AUDIO_ENDPOINT, headers, payload)
    if response and 'audio' in response and 'url' in response['audio']:
        audio_url = response['audio']['url']
        download_file(audio_url, output_dir / f"scene{scene_num}.mp3")
        return True
    else:
        print(f"      ⚠️  Narration {scene_num} failed: {response}")
        return False

def generate_video(concept_name, scene_num, prompt, seed, output_dir):
    """Generate video"""
    payload = {
        "prompt": prompt,
        "duration": 8,
        "aspect_ratio": "9:16",
        "resolution": "1080p",
        "seed": seed,
        "generate_audio": True
    }
    headers = {
        "Authorization": f"Key {FAL_API_KEY}",
        "Content-Type": "application/json"
    }
    
    response = call_api(VIDEO_ENDPOINT, headers, payload)
    if response and 'video' in response and 'url' in response['video']:
        download_file(response['video']['url'], output_dir / f"scene{scene_num}.mp4")
        return True
    return False

def generate_music(concept_name, scene_num, prompt, output_dir):
    """Generate music"""
    payload = {
        "prompt": prompt,
        "seconds_total": 8,
        "num_inference_steps": 8,
        "guidance_scale": 7
    }
    headers = {
        "Authorization": f"Key {FAL_API_KEY}",
        "Content-Type": "application/json"
    }
    
    response = call_api(MUSIC_ENDPOINT, headers, payload)
    if response and 'audio' in response and 'url' in response['audio']:
        download_file(response['audio']['url'], output_dir / f"scene{scene_num}.mp3")
        return True
    return False

def process_concept(concept_key, concept_data):
    """Process all scenes for a concept"""
    print(f"\n{concept_data['name']}")
    concept_dir = Path(concept_key)
    concept_dir.mkdir(exist_ok=True)
    (concept_dir / "audio").mkdir(exist_ok=True)
    (concept_dir / "videos").mkdir(exist_ok=True)
    (concept_dir / "music").mkdir(exist_ok=True)
    
    tasks = []
    with ThreadPoolExecutor(max_workers=9) as executor:
        for i, scene in enumerate(concept_data['scenes'], 1):
            tasks.append(executor.submit(generate_narration, concept_key, i, scene['narration'], concept_dir / "audio"))
            tasks.append(executor.submit(generate_video, concept_key, i, scene['visual'], concept_data['seed'], concept_dir / "videos"))
            tasks.append(executor.submit(generate_music, concept_key, i, scene['music'], concept_dir / "music"))
        
        completed = 0
        for future in as_completed(tasks):
            completed += 1
            if completed % 3 == 0:
                print(f"   Scene {completed//3}/3 complete")
    
    print(f"   ✅ {concept_data['name']}: All assets generated")

def main():
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎬 GENERATING ALL 6 CONCEPT TESTS (24s each)")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    for concept_key, concept_data in CONCEPTS.items():
        process_concept(concept_key, concept_data)
    
    print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("✅ ALL 6 CONCEPTS GENERATED")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("\nNext: Run mix_and_compile.sh to create final shorts")

if __name__ == "__main__":
    main()


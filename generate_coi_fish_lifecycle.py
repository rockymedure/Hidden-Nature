#!/usr/bin/env python3
"""
🐠 COI FISH LIFECYCLE - CHAINED FRAME VIDEO GENERATION
Complete workflow: Eggs → Baby → Young → Adult
Using Nano Banana frames → Veo 3.1 Fast scenes → FFmpeg concat
"""

import sys
import os
import time
import subprocess
import json
from pathlib import Path

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Import fal_client - with error handling
try:
    import fal_client
except ImportError:
    print("❌ fal_client not found. Installing...")
    subprocess.run([sys.executable, "-m", "pip", "install", "fal-client", "--break-system-packages", "-q"], check=True)
    import fal_client

# Setup
os.makedirs("COI_FISH_LIFECYCLE", exist_ok=True)
os.chdir("COI_FISH_LIFECYCLE")

FAL_KEY = os.getenv("FAL_KEY") or os.getenv("FAL_API_KEY")
if not FAL_KEY:
    print("❌ FAL_KEY environment variable not set!")
    sys.exit(1)

print("=" * 70)
print("🐠 COI FISH LIFECYCLE - CHAINED FRAME VIDEO GENERATION")
print("=" * 70)
print(f"✅ FAL_KEY loaded: {FAL_KEY[:20]}...")
print()

# Frame prompts - Coi fish life progression
frame_prompts = {
    0: """Macro underwater photography of coi fish eggs in a koi pond. 
       Hundreds of translucent round eggs attached to water plants. 
       Soft sunlight filtering through water. Blurred aquatic plants. 
       Crystal clear water. Professional underwater macro photography. 
       Close-up detail of egg cluster.""",
    
    1: """Underwater macro photography of newly hatched coi fish fry. 
       Tiny transparent baby fish with large yolk sacs, barely 2mm long. 
       Swimming near aquatic vegetation for protection. 
       Same pond environment with soft natural light. 
       Professional underwater macro photography.""",
    
    2: """Underwater photography of young coi fish juveniles. 
       3-4 week old baby coi, now about 1 cm long. 
       Beautiful emerging color patterns, red and white markings visible. 
       Swimming in small school with siblings among water plants. 
       Clear pond water with natural lighting.""",
    
    3: """Underwater photography of juvenile coi fish. 
       2-3 month old young coi, now 4-5 cm long. 
       Distinct red and white patterning becoming clear. 
       More confident swimming behavior, exploring the pond. 
       Beautiful coloration development visible. Professional pond photography.""",
    
    4: """Stunning underwater photography of adult koi fish. 
       Mature coi, 20+ cm long, in full beautiful coloration. 
       Striking red and white kohaku pattern, fully developed. 
       Graceful movement through clear koi pond water. 
       Beautiful scales catching light, professional aquatic photography."""
}

# ============================================================================
# PHASE 1: FRAME GENERATION
# ============================================================================

print("PHASE 1: Generating Life Cycle Frames")
print("─" * 70)
print()

frame_urls = {}

def generate_frame(stage, prompt):
    """Generate or edit a frame."""
    stage_names = {
        0: "Fish Eggs",
        1: "Fry (Newly Hatched)",
        2: "Young Fry (3-4 weeks)",
        3: "Juvenile (2-3 months)",
        4: "Adult Koi"
    }
    
    if stage == 0:
        print(f"🎨 Generating Frame {stage} ({stage_names[stage]})...")
        model = "fal-ai/nano-banana"
        args = {
            "prompt": prompt,
            "num_images": 1,
            "output_format": "png",
            "aspect_ratio": "16:9"
        }
    else:
        print(f"✏️  Editing Frame {stage} ({stage_names[stage]}) from Frame {stage-1}...")
        model = "fal-ai/nano-banana/edit"
        
        with open(f"frame_{stage-1}_url.txt") as f:
            prev_url = f.read().strip()
        
        args = {
            "prompt": prompt,
            "image_urls": [prev_url],
            "num_images": 1,
            "output_format": "png",
            "aspect_ratio": "16:9"
        }
    
    try:
        print(f"   Calling {model}...")
        result = fal_client.subscribe(
            model,
            arguments=args,
            with_logs=True,
        )
        
        url = result["images"][0]["url"]
        
        with open(f"frame_{stage}_url.txt", "w") as f:
            f.write(url)
        
        print(f"   ✅ Frame {stage} ({stage_names[stage]}): {url[:60]}...")
        print()
        
        return url
        
    except Exception as e:
        print(f"   ❌ Error: {e}")
        raise

# Generate all 5 frames
print("Generating 5 life cycle frames (eggs → adult)...\n")
for stage in range(5):
    generate_frame(stage, frame_prompts[stage])
    time.sleep(1)

print(f"✅ Phase 1 Complete: All life cycle frames generated!\n")

# ============================================================================
# PHASE 2: VIDEO SCENE GENERATION
# ============================================================================

print("PHASE 2: Generating Chained Video Scenes")
print("─" * 70)
print()

scene_configs = [
    {
        "num": 1,
        "stage_name": "Eggs to Fry",
        "first_frame_file": "frame_0_url.txt",
        "last_frame_file": "frame_1_url.txt",
        "prompt": "Fish eggs transforming into newly hatched fry, eggs disappearing as tiny transparent babies emerge with yolk sacs, underwater macro photography"
    },
    {
        "num": 2,
        "stage_name": "Fry to Young",
        "first_frame_file": "frame_1_url.txt",
        "last_frame_file": "frame_2_url.txt",
        "prompt": "Coi fish fry growing and developing color, transitioning from transparent to showing red and white patterns, becoming more active swimmers"
    },
    {
        "num": 3,
        "stage_name": "Young to Juvenile",
        "first_frame_file": "frame_2_url.txt",
        "last_frame_file": "frame_3_url.txt",
        "prompt": "Young coi growing into juvenile, becoming stronger swimmers, color patterns intensifying with distinct red and white markings becoming clearer"
    },
    {
        "num": 4,
        "stage_name": "Juvenile to Adult",
        "first_frame_file": "frame_3_url.txt",
        "last_frame_file": "frame_4_url.txt",
        "prompt": "Juvenile coi fish maturing into beautiful adult, full gorgeous red and white kohaku pattern emerging, graceful movement, fully developed coloration"
    }
]

def generate_scene(config):
    """Generate a chained scene using first-last-frame-to-video."""
    
    with open(config["first_frame_file"]) as f:
        first_url = f.read().strip()
    with open(config["last_frame_file"]) as f:
        last_url = f.read().strip()
    
    print(f"🎬 Generating Scene {config['num']} ({config['stage_name']})...")
    print(f"   First: {first_url[:50]}...")
    print(f"   Last:  {last_url[:50]}...")
    
    try:
        print(f"   Calling Veo 3.1 Fast...")
        result = fal_client.subscribe(
            "fal-ai/veo3.1/fast/first-last-frame-to-video",
            arguments={
                "first_frame_url": first_url,
                "last_frame_url": last_url,
                "prompt": config["prompt"],
                "duration": "8s",
                "aspect_ratio": "16:9",
                "resolution": "1080p",
                "generate_audio": False
            },
            with_logs=True,
        )
        
        video_url = result["video"]["url"]
        
        with open(f"scene_{config['num']}_url.txt", "w") as f:
            f.write(video_url)
        
        print(f"   ✅ Scene {config['num']} ({config['stage_name']}): {video_url[:50]}...\n")
        return video_url
        
    except Exception as e:
        print(f"   ❌ Error: {e}")
        raise

# Generate all 4 scenes
print("Generating 4 chained video scenes...\n")
for config in scene_configs:
    generate_scene(config)
    time.sleep(1)

print(f"✅ Phase 2 Complete: All life cycle scenes generated!\n")

# ============================================================================
# PHASE 3: DOWNLOAD & CONCATENATE
# ============================================================================

print("PHASE 3: Downloading and Concatenating Scenes")
print("─" * 70)
print()

print("📥 Reading scene URLs...")
urls = []
for i in range(1, 5):
    with open(f"scene_{i}_url.txt") as f:
        url = f.read().strip()
        urls.append(url)
        print(f"   Scene {i}: {url[:60]}...")

print("\n📥 Downloading all scenes...")
for i, url in enumerate(urls, 1):
    print(f"   Downloading Scene {i}...")
    subprocess.run(
        f'curl -L -o scene_{i}.mp4 "{url}"',
        shell=True,
        check=False
    )
    if os.path.exists(f"scene_{i}.mp4"):
        size = os.path.getsize(f"scene_{i}.mp4") / (1024*1024)
        print(f"      ✅ scene_{i}.mp4 ({size:.1f} MB)")
    else:
        print(f"      ⚠️  Failed to download scene_{i}.mp4")

print("\n🎞️  Creating FFmpeg concat file...")
with open("concat.txt", "w") as f:
    for i in range(1, 5):
        f.write(f"file 'scene_{i}.mp4'\n")

print("🎬 Concatenating scenes with FFmpeg...")
result = subprocess.run(
    ['ffmpeg', '-f', 'concat', '-safe', '0', '-i', 'concat.txt', 
     '-c', 'copy', '-y', 'COI_FISH_LIFECYCLE_FINAL.mp4'],
    capture_output=True,
    text=True
)

if result.returncode == 0:
    size = os.path.getsize("COI_FISH_LIFECYCLE_FINAL.mp4") / (1024*1024)
    print(f"   ✅ COI_FISH_LIFECYCLE_FINAL.mp4 created ({size:.1f} MB)")
else:
    print(f"   ❌ FFmpeg error: {result.stderr}")

print()

# ============================================================================
# SUMMARY
# ============================================================================

print("=" * 70)
print("✅ COI FISH LIFECYCLE - COMPLETE!")
print("=" * 70)
print()

if os.path.exists("COI_FISH_LIFECYCLE_FINAL.mp4"):
    size = os.path.getsize("COI_FISH_LIFECYCLE_FINAL.mp4") / (1024*1024)
    
    # Get duration with ffprobe
    duration_cmd = "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 COI_FISH_LIFECYCLE_FINAL.mp4"
    duration_result = subprocess.run(duration_cmd, shell=True, capture_output=True, text=True)
    duration = duration_result.stdout.strip() if duration_result.returncode == 0 else "unknown"
    
    print("📊 Video Details:")
    print(f"   Path: {os.path.abspath('COI_FISH_LIFECYCLE_FINAL.mp4')}")
    print(f"   Size: {size:.1f} MB")
    print(f"   Duration: {duration}s")
    print(f"   Aspect Ratio: 16:9 (YouTube)")
    print(f"   Resolution: 1080p")
    print()
    print("📚 Frames Created:")
    print("   • Frame 0: Fish Eggs")
    print("   • Frame 1: Fry (Newly Hatched)")
    print("   • Frame 2: Young Fry (3-4 weeks)")
    print("   • Frame 3: Juvenile (2-3 months)")
    print("   • Frame 4: Adult Koi")
    print()
    print("📚 Scenes Created (Chained):")
    print("   • Scene 1: Eggs → Fry (8s)")
    print("   • Scene 2: Fry → Young (8s)")
    print("   • Scene 3: Young → Juvenile (8s)")
    print("   • Scene 4: Juvenile → Adult (8s)")
    print()
    print("🎬 Ready to:")
    print("   1. Upload to YouTube (16:9)")
    print("   2. Generate TikTok version (9:16)")
    print("   3. Generate Instagram version (1:1)")
    print("   4. Extract highlights for shorts")
    print("   5. Add narration/music")
else:
    print("❌ Video generation incomplete - check logs above")

print()
print("=" * 70)




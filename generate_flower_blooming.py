#!/usr/bin/env python3
"""
🌸 FLOWER BLOOMING - CHAINED FRAME VIDEO GENERATION
Complete workflow: Nano Banana frames → Veo 3.1 Fast scenes → FFmpeg concat
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
os.makedirs("FLOWER_BLOOMING", exist_ok=True)
os.chdir("FLOWER_BLOOMING")

FAL_KEY = os.getenv("FAL_KEY") or os.getenv("FAL_API_KEY")
if not FAL_KEY:
    print("❌ FAL_KEY environment variable not set!")
    sys.exit(1)

print("=" * 70)
print("🌸 FLOWER BLOOMING - CHAINED FRAME VIDEO GENERATION")
print("=" * 70)
print(f"✅ FAL_KEY loaded: {FAL_KEY[:20]}...")
print()

# Frame prompts
frame_prompts = {
    0: """Macro photography of a tightly closed flower bud on a green stem. 
       Morning dew droplets covering the unopened petals and sepals. 
       Soft natural golden-hour light. Fine detail macro photography. 
       Hyper-realistic botanical photography. Pristine clarity. 
       Blurred green leaf background.""",
    
    1: """Macro photography of a flower with petals beginning to unfurl from a bud. 
       First layer of petals curling back gently, revealing inner petals. 
       Same green stem with dewdrops. Morning light. 
       Same botanical macro style. Professional nature photography.""",
    
    2: """Macro photography of a flower half-opened, petals spreading outward symmetrically. 
       Golden stamens and pollen becoming clearly visible in the center. 
       Inner petal details revealed. Same stem and lighting. 
       Professional macro botanical photography.""",
    
    3: """Macro photography of a nearly fully open flower. 
       Most petals spread wide and relaxed. Complete stamens and pollen visible. 
       Golden inner light catching the flower's structure. 
       Professional macro botanical photography. Same composition.""",
    
    4: """Macro photography of a fully open flower in peak bloom. 
       All petals fully spread. Complete view of golden stamens and pollen. 
       Morning dewdrops glistening on petals catching the light. 
       Peak beauty. Professional nature macro photography."""
}

# ============================================================================
# PHASE 1: FRAME GENERATION
# ============================================================================

print("PHASE 1: Generating Progressive Frames")
print("─" * 70)
print()

frame_urls = {}

def generate_frame(stage, prompt):
    """Generate or edit a frame."""
    if stage == 0:
        print(f"🎨 Generating Frame {stage} (Base Bud)...")
        model = "fal-ai/nano-banana"
        args = {
            "prompt": prompt,
            "num_images": 1,
            "output_format": "png",
            "aspect_ratio": "16:9"
        }
    else:
        print(f"✏️  Editing Frame {stage} (from Frame {stage-1})...")
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
        
        print(f"   ✅ Frame {stage}: {url[:60]}...")
        print()
        
        return url
        
    except Exception as e:
        print(f"   ❌ Error: {e}")
        raise

# Generate all 5 frames
print("Generating 5 progressive frames...\n")
for stage in range(5):
    generate_frame(stage, frame_prompts[stage])
    time.sleep(1)

print(f"✅ Phase 1 Complete: All frames generated!\n")

# ============================================================================
# PHASE 2: VIDEO SCENE GENERATION
# ============================================================================

print("PHASE 2: Generating Chained Video Scenes")
print("─" * 70)
print()

scene_configs = [
    {
        "num": 1,
        "first_frame_file": "frame_0_url.txt",
        "last_frame_file": "frame_1_url.txt",
        "prompt": "Flower petals slowly unfurling in morning light, delicate dewdrops visible, first light touching the bloom gently"
    },
    {
        "num": 2,
        "first_frame_file": "frame_1_url.txt",
        "last_frame_file": "frame_2_url.txt",
        "prompt": "Flower continues opening gracefully, petals curling back to reveal inner structure, golden stamens becoming visible, soft light"
    },
    {
        "num": 3,
        "first_frame_file": "frame_2_url.txt",
        "last_frame_file": "frame_3_url.txt",
        "prompt": "Flower bloom fully opening, petals spreading wide, golden stamens and pollen fully revealed, radiant golden light"
    },
    {
        "num": 4,
        "first_frame_file": "frame_3_url.txt",
        "last_frame_file": "frame_4_url.txt",
        "prompt": "Fully open flower at peak bloom, morning dew glistening on petals, golden hour light illuminating details, mature perfection"
    }
]

def generate_scene(config):
    """Generate a chained scene using first-last-frame-to-video."""
    
    with open(config["first_frame_file"]) as f:
        first_url = f.read().strip()
    with open(config["last_frame_file"]) as f:
        last_url = f.read().strip()
    
    print(f"🎬 Generating Scene {config['num']}...")
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
        
        print(f"   ✅ Scene {config['num']}: {video_url[:50]}...\n")
        return video_url
        
    except Exception as e:
        print(f"   ❌ Error: {e}")
        raise

# Generate all 4 scenes
print("Generating 4 chained video scenes...\n")
for config in scene_configs:
    generate_scene(config)
    time.sleep(1)

print(f"✅ Phase 2 Complete: All scenes generated!\n")

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
     '-c', 'copy', '-y', 'FLOWER_BLOOMING_FINAL.mp4'],
    capture_output=True,
    text=True
)

if result.returncode == 0:
    size = os.path.getsize("FLOWER_BLOOMING_FINAL.mp4") / (1024*1024)
    print(f"   ✅ FLOWER_BLOOMING_FINAL.mp4 created ({size:.1f} MB)")
else:
    print(f"   ❌ FFmpeg error: {result.stderr}")

print()

# ============================================================================
# SUMMARY
# ============================================================================

print("=" * 70)
print("✅ FLOWER BLOOMING - COMPLETE!")
print("=" * 70)
print()

if os.path.exists("FLOWER_BLOOMING_FINAL.mp4"):
    size = os.path.getsize("FLOWER_BLOOMING_FINAL.mp4") / (1024*1024)
    
    # Get duration with ffprobe
    duration_cmd = "ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 FLOWER_BLOOMING_FINAL.mp4"
    duration_result = subprocess.run(duration_cmd, shell=True, capture_output=True, text=True)
    duration = duration_result.stdout.strip() if duration_result.returncode == 0 else "unknown"
    
    print("📊 Video Details:")
    print(f"   Path: {os.path.abspath('FLOWER_BLOOMING_FINAL.mp4')}")
    print(f"   Size: {size:.1f} MB")
    print(f"   Duration: {duration}s")
    print()
    print("📚 Assets Created:")
    for f in sorted(Path(".").glob("frame_*.txt")):
        print(f"   {f.name}")
    for f in sorted(Path(".").glob("scene_*.txt")):
        print(f"   {f.name}")
    print()
    print("🎬 Ready to:")
    print("   1. Upload to YouTube (16:9)")
    print("   2. Generate TikTok version (9:16)")
    print("   3. Generate Instagram version (1:1)")
    print("   4. Extract highlights for shorts")
else:
    print("❌ Video generation incomplete - check logs above")

print()
print("=" * 70)

# The Termite Cathedrals
## Hidden Nature Documentary - Complete Production Package

**Series**: Hidden Architects
**Duration**: 3 minutes 12 seconds (24 scenes)
**Narrator**: Rachel (cosmic wonder)
**Status**: Ready for production

---

## 📁 Project Structure

```
termite_cathedrals/
├── MASTER_SCRIPT.md              # Complete 24-scene documentary script
├── YOUTUBE_METADATA.md           # YouTube publishing package
├── .env.template                 # API credentials template
├── .env                          # Your actual API keys (create from template)
│
├── master_production.sh          # 🎬 RUN THIS to produce entire documentary
├── generate_narration.sh         # Generate all 24 narrations
├── generate_videos.sh            # Generate all 24 videos
├── generate_music.sh             # Generate all 24 music clips
├── mix_audio.sh                  # Mix video + narration + music
├── assemble_final.sh             # Concatenate into final documentary
│
├── documentary/                  # Documentary production files
│   ├── videos/                   # Generated video clips (24 × 8s)
│   ├── audio/                    # Narration TTS files (24 scenes)
│   ├── music/                    # Scene-specific music (24 clips)
│   ├── final/                    # Mixed scenes ready for assembly
│   ├── mobile/                   # Native 9:16 mobile versions
│   ├── responses/                # API response logs for debugging
│   └── FINAL_DOCUMENTARY.mp4    # 📹 Your finished documentary!
│
├── field_journal/                # Substack companion content
│   ├── images/                   # Extracted frames for article
│   ├── drafts/                   # Article drafts
│   └── FIELD_JOURNAL_TERMITE_CATHEDRALS.md  # 2,847-word field journal
│
└── podcast/                      # Podcast companion content
    ├── segments/                 # Individual dialogue segments
    ├── full/                     # Complete podcast episode
    └── PODCAST_SCRIPT.md        # 18-20 min conversation script
```

---

## 🚀 Quick Start

### 1. Set Up API Credentials

```bash
# Copy environment template
cp .env.template .env

# Edit .env and add your fal.ai API key
# Get one free at: https://fal.ai/dashboard
nano .env  # or use your preferred editor
```

Add your key to `.env`:
```
FAL_API_KEY=your_actual_api_key_here
```

### 2. Run Production Pipeline

```bash
# Make master script executable
chmod +x master_production.sh

# Execute complete production pipeline
./master_production.sh
```

This will automatically:
1. ✅ Generate all 24 narrations (parallel processing)
2. ✅ Generate all 24 videos (parallel processing)
3. ✅ Generate all 24 music clips (parallel processing)
4. ✅ Mix audio layers for each scene
5. ✅ Assemble final documentary

**Total time**: 30-60 minutes (depending on API speed)
**Estimated cost**: $4.50-6.00 in API credits

### 3. Review Output

```bash
# Play the final documentary
open documentary/FINAL_DOCUMENTARY.mp4  # macOS
xdg-open documentary/FINAL_DOCUMENTARY.mp4  # Linux
```

---

## 📊 What You Get

### Primary Deliverable
- **FINAL_DOCUMENTARY.mp4** - 3m 12s, 1080p, broadcast-ready documentary

### Companion Content
- **Field Journal** - 2,847-word first-person article for Substack
- **Podcast Script** - 18-20 minute conversational dialogue
- **YouTube Metadata** - Optimized title, description, tags, thumbnails

### Production Assets
- 24 individual scene videos (8 seconds each)
- 24 narration audio files (padded to 8.000s)
- 24 unique music clips (scene-specific)
- 24 fully mixed scenes (ready for assembly)

---

## 🎬 Production Phases Explained

### Phase 1: Narration Generation
**Script**: `generate_narration.sh`
- Extracts all 24 narrations from MASTER_SCRIPT.md
- Generates TTS using ElevenLabs (Rachel voice)
- Processes all scenes in parallel for speed
- **Output**: `documentary/audio/scene[1-24].mp3`

### Phase 2: Video Generation
**Script**: `generate_videos.sh`
- Uses visual descriptions from MASTER_SCRIPT.md
- Generates with Veo3 Fast (fal.ai)
- Maintains visual consistency through prompts
- Uses seed progression (77000-77023)
- **Output**: `documentary/videos/scene[1-24].mp4`

### Phase 3: Music Generation
**Script**: `generate_music.sh`
- Creates unique 8-second music for each scene
- Uses Stable Audio 2.5 (fal.ai)
- Scene-specific moods and instrumentation
- Maintains thematic coherence
- **Output**: `documentary/music/scene[1-24]_music.wav`

### Phase 4: Audio Mixing
**Script**: `mix_audio.sh`
- Three-layer mix per scene:
  - Video ambient audio: 0.175x
  - Narration: 1.3x
  - Music: 0.20x
- Pads narrations to exactly 8.000s (prevents bleeding)
- Ensures audio consistency (AAC 44.1kHz mono)
- **Output**: `documentary/final/scene[1-24]_mixed.mp4`

### Phase 5: Final Assembly
**Script**: `assemble_final.sh`
- Concatenates all 24 mixed scenes
- Uses stream copy (no re-encoding)
- Preserves audio consistency
- **Output**: `documentary/FINAL_DOCUMENTARY.mp4`

---

## 🛠️ Requirements

### Software Dependencies
- **bash** - Shell scripting
- **curl** - API calls
- **jq** - JSON parsing
- **ffmpeg** - Audio/video processing
- **ffprobe** - Media analysis
- **bc** - Mathematical calculations

Install on Ubuntu/Debian:
```bash
sudo apt-get install curl jq ffmpeg bc
```

Install on macOS:
```bash
brew install curl jq ffmpeg bc
```

### API Requirements
- **fal.ai API key** (required)
  - Provides access to: Veo3 (video), ElevenLabs (TTS), Stable Audio (music)
  - Get free credits at: https://fal.ai/dashboard

---

## 💰 Cost Breakdown

**Per-Scene Costs** (approximate):
- Video generation (Veo3): $0.15-0.20
- Narration (ElevenLabs): $0.01
- Music (Stable Audio): $0.02

**Total Documentary** (24 scenes):
- Video: $3.60-4.80
- Narration: $0.24
- Music: $0.48
- **TOTAL**: ~$4.50-6.00

---

## 🎯 Next Steps After Production

### 1. Create Mobile Version (9:16)
Re-generate all videos with `aspect_ratio: "9:16"` for Instagram/TikTok

### 2. Generate Podcast Audio
Use podcast script with ElevenLabs text-to-dialogue API

### 3. Extract YouTube Shorts
Create 3-5 viral clips (60s each) from key moments

### 4. Publish & Promote
- Upload to YouTube with metadata from YOUTUBE_METADATA.md
- Publish field journal to Substack
- Release podcast episode
- Create social media clips

---

## 🐛 Troubleshooting

### "❌ ERROR: .env file not found"
```bash
cp .env.template .env
# Edit .env and add your FAL_API_KEY
```

### "❌ Narration generation failed"
- Check your FAL_API_KEY in .env
- Verify you have sufficient API credits
- Check `documentary/responses/narration_scene*.json` for error details

### "❌ Audio dropouts during concatenation"
The script automatically handles this by ensuring all scenes have identical audio properties (AAC 44.1kHz mono). If issues persist, run:
```bash
./mix_audio.sh  # Re-run mixing with corrected settings
```

### Some scenes missing/failed
Check `documentary/responses/` folder for API error logs. Common issues:
- Insufficient API credits
- Network connectivity
- Rate limiting (scripts include delays to prevent this)

---

## 📚 Documentation

- **MASTER_SCRIPT.md** - Complete scene-by-scene script with visual descriptions
- **YOUTUBE_METADATA.md** - Publishing strategy, SEO, thumbnails, promotion
- **field_journal/FIELD_JOURNAL_TERMITE_CATHEDRALS.md** - Companion article
- **podcast/PODCAST_SCRIPT.md** - Conversational podcast dialogue
- **PRODUCTION_SYSTEM/MASTER_DOCUMENTARY_SYSTEM.md** - Complete system documentation

---

## 🎨 Creative Credits

**Documentary Script**: Hidden Nature Productions
**Series**: Hidden Architects
**Narrator**: Rachel (ElevenLabs)
**Visual Style**: Science documentary with macro photography
**Music**: Scene-specific original compositions (Stable Audio 2.5)

---

## 📝 License

© 2025 Hidden Nature Productions

This documentary is part of the Hidden Nature educational series revealing extraordinary engineering, intelligence, and wonder in the natural world.

---

## 🌟 Part of Hidden Nature Series

**Hidden Architects** explores nature's master builders and engineers:
- The Termite Cathedrals ← You are here
- Beaver Dam Engineering (coming soon)
- Coral Reef Construction (coming soon)
- Spider Silk Architecture (coming soon)
- Ant Colony Megacities (coming soon)

Subscribe to Hidden Nature for weekly documentaries!

---

**Ready to create your documentary?**

```bash
./master_production.sh
```

Let the termites teach you about collective genius! 🏗️✨

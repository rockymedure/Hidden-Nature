# QUICK START GUIDE
## Nature's Polka Dots - Production-Ready Documentary

**STATUS**: ✅ READY TO EXECUTE

---

## ONE-COMMAND PRODUCTION

```bash
./PRODUCTION_MASTER.sh
```

That's it. Single command produces:
- ✅ YouTube 16:9 version (3:12)
- ✅ TikTok 9:16 version (3:12)
- ✅ Highlight segments (16/24 seconds for Instagram/YouTube Shorts)

**Expected Runtime**: 40-50 minutes (mostly parallel processing)

---

## WHAT HAPPENS AUTOMATICALLY

### Phase 2-4 (PARALLEL - ~20-25 minutes)
- 🎙️ **24 narrations** generated via ElevenLabs (Rachel voice)
- 🎥 **24 videos (16:9)** generated via Veo 3.1 Fast
- 🎥 **24 videos (9:16)** generated via Veo 3.1 Fast
- 🎵 **24 music tracks** generated (C Major, orchestral)

All running simultaneously!

### Phase 5 (AUDIO MIXING - ~2-3 minutes)
- 🎚️ **48 scenes mixed** (24 × 2 formats)
- 3-layer audio: ambient (0.175x) + narration (1.3x) + music (0.20x)

### Phase 6 (COMPILATION - ~1 minute)
- 📺 **YouTube version**: All 24 scenes → single 3:12 video
- 📱 **TikTok version**: All 24 scenes → single 3:12 video

### Phase 7 (HIGHLIGHTS - ~1 minute)
- ✂️ **Social clips**: Auto-segmented into 16s/24s pieces
- Perfect for Instagram Reels, YouTube Shorts

---

## REQUIREMENTS

### Before Running:
1. **Environment file**: Ensure `../../.env` exists with `FAL_API_KEY`
2. **Dependencies**: `curl`, `jq`, `ffmpeg`, `ffprobe`, `bc`
3. **API Credits**: Fal.ai account with sufficient credits

### Check Your Setup:
```bash
# Verify .env file
cat ../../.env | grep FAL_API_KEY

# Verify dependencies
which curl jq ffmpeg ffprobe bc
```

---

## OUTPUT STRUCTURE

After completion, your directory will contain:

```
natures_polka_dots/
├── audio/                          # 24 narration files (8s each)
│   ├── scene1.mp3
│   ├── scene2.mp3
│   └── ... (through scene24.mp3)
│
├── videos/                         # 24 YouTube videos (16:9)
│   ├── scene1.mp4
│   ├── scene2.mp4
│   └── ... (through scene24.mp4)
│
├── videos_9x16/                    # 24 TikTok videos (9:16)
│   ├── scene1.mp4
│   ├── scene2.mp4
│   └── ... (through scene24.mp4)
│
├── music/                          # 24 music tracks (8s each)
│   ├── scene1_music.wav
│   ├── scene2_music.wav
│   └── ... (through scene24_music.wav)
│
├── final/                          # YouTube final output
│   ├── scene1_mixed.mp4 ... scene24_mixed.mp4
│   ├── scene_list.txt
│   └── NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4  ⭐ MAIN OUTPUT
│
├── final_9x16/                     # TikTok final output
│   ├── scene1_mixed.mp4 ... scene24_mixed.mp4
│   ├── scene_list.txt
│   └── NATURES_POLKA_DOTS_TIKTOK_9x16.mp4   ⭐ MAIN OUTPUT
│
└── highlights/                     # Social media clips
    ├── highlight_1_16s.mp4
    ├── highlight_2_24s.mp4
    ├── highlight_3_16s.mp4
    └── ... (5-6 segments total)
```

---

## WHAT YOU GET

### 1. YouTube Documentary (16:9)
- **File**: `final/NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4`
- **Duration**: 3:12 (192 seconds)
- **Format**: 1080p landscape, broadcast quality
- **Audio**: 3-layer professional mix
- **Ready for**: YouTube main channel upload

### 2. TikTok Documentary (9:16)
- **File**: `final_9x16/NATURES_POLKA_DOTS_TIKTOK_9x16.mp4`
- **Duration**: 3:12 (192 seconds)
- **Format**: 1080p vertical, mobile-optimized
- **Audio**: Same professional mix
- **Ready for**: TikTok, Instagram Reels

### 3. Highlight Clips
- **Files**: `highlights/highlight_*_*.mp4`
- **Durations**: Alternating 16s and 24s segments
- **Format**: 9:16 vertical
- **Ready for**: Instagram Reels, YouTube Shorts, TikTok clips

---

## TROUBLESHOOTING

### Script Fails Immediately:
```bash
# Check environment
source ../../.env
echo $FAL_API_KEY

# If empty, create .env file:
echo 'FAL_API_KEY=your_api_key_here' > ../../.env
```

### Some Scenes Fail:
- **Normal**: 1-2 scenes may fail due to API timeouts
- **Solution**: Re-run individual scene generation
- **Impact**: Minimal - other scenes complete independently

### Audio/Video Desync:
- **Cause**: Narration duration != 8.0 seconds
- **Auto-fix**: Script pads short narrations automatically
- **Manual fix**: Use `ffmpeg` to adjust duration

### Out of Credits:
- **Cost Estimate**: ~$15-25 per complete documentary
- **Breakdown**:
  - Narrations: ~$2-3 (24 × ElevenLabs TTS)
  - Videos: ~$12-18 (48 × Veo 3.1 Fast)
  - Music: ~$1-2 (24 × Stable Audio)

---

## MONITORING PROGRESS

The script outputs real-time status:

```
✅ Scene 1: Narration (background)
✅ Scene 1: Video 16:9 (background)
✅ Scene 1: Video 9:16 (background)
✅ Scene 1: Music (background)
...
⏳ Waiting for parallel generation to complete...
✅ Narrations complete
✅ Videos 16:9 complete
✅ Videos 9:16 complete
✅ Music complete
```

Watch for:
- ❌ symbols indicate failures
- ✅ symbols indicate success
- Background processes complete independently

---

## NEXT STEPS AFTER COMPLETION

### 1. Quality Check
```bash
# Preview YouTube version
open final/NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4

# Preview TikTok version
open final_9x16/NATURES_POLKA_DOTS_TIKTOK_9x16.mp4

# Check duration
ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 \
  final/NATURES_POLKA_DOTS_YOUTUBE_16x9.mp4
# Should output: 192.000000 (exactly 3:12)
```

### 2. Upload to YouTube
- Title: "Nature's Polka Dots: The Secret Lives of Spots | Hidden Beauty"
- Tags: nature documentary, spotted animals, evolution, wildlife, camouflage
- Category: Education
- Thumbnail: Frame from Scene 1 (spotted pattern montage)

### 3. Upload to TikTok
- Use: `final_9x16/NATURES_POLKA_DOTS_TIKTOK_9x16.mp4`
- Caption: "From camouflage to warning signs, every spot tells a story 🐆✨ #NatureDocumentary"

### 4. Post Highlights
- Upload: `highlights/highlight_1_16s.mp4` → Instagram Reels
- Upload: `highlights/highlight_2_24s.mp4` → YouTube Shorts
- Stagger posts over several days

---

## CUSTOMIZATION OPTIONS

### Change Narrator Voice:
Edit line 48 in `PRODUCTION_MASTER.sh`:
```bash
NARRATOR="Rachel"  # Change to: Charlotte, Roger, Lucy, Jessica
```

### Adjust Audio Mix Levels:
Edit lines 284 and 299:
```bash
[0:a]volume=0.175[ambient]   # Adjust ambient volume
[1:a]volume=1.3[narration]   # Adjust narration volume
[2:a]volume=0.20[music]      # Adjust music volume
```

### Change Music Key:
Edit music prompts (lines 214-237), change "C Major" to desired key.

---

## SUPPORT

If you encounter issues:
1. Check `SYSTEM_SUMMARY.md` for technical details
2. Review `NATURES_POLKA_DOTS_SCRIPT.md` for narrative content
3. Consult `NATURES_POLKA_DOTS_VIDEO_PROMPTS.md` for visual specifications

---

**Ready to create your spotted animals documentary?**

```bash
./PRODUCTION_MASTER.sh
```

🎬 Let's go!

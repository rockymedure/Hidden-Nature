# THE WASP'S PAPER FACTORY
## Hidden Architects Series - Episode 4
**3:12 Documentary | 24 Scenes × 8 Seconds**

---

## 📁 **PROJECT STRUCTURE**

```
wasps_paper_factory/
├── .env                          # API credentials (FAL_API_KEY)
├── README.md                     # This file
├── THE_WASPS_PAPER_FACTORY_SCRIPT.md  # Master script (24 scenes)
│
├── audio/                        # Generated narrations
│   ├── scene1.mp3
│   ├── scene2.mp3
│   └── ... (24 total)
│
├── videos/                       # Generated video clips
│   ├── scene1.mp4
│   ├── scene2.mp4
│   └── ... (24 total)
│
├── music/                        # Scene-specific music
│   ├── scene1_music.wav
│   ├── scene2_music.wav
│   └── ... (24 total)
│
├── final/                        # Mixed scenes (ready for compilation)
│   ├── scene1_mixed.mp4
│   ├── scene2_mixed.mp4
│   └── ... (24 total)
│
├── responses/                    # API response logs
│   ├── narration_responses.json
│   ├── video_responses.json
│   └── music_responses.json
│
├── generate_narrations.sh        # Phase 3: Narration generation
├── generate_videos.sh            # Phase 4: Video generation
├── generate_music.sh             # Phase 5: Music generation
├── mix_all_scenes.sh            # Phase 6: Audio mixing
├── compile_final.sh             # Phase 7: Final compilation
│
└── THE_WASPS_PAPER_FACTORY.mp4  # FINAL OUTPUT (3:12)
```

---

## 🎯 **ENVIRONMENT SETUP**

### **API Credentials**
File: `.env`
```bash
FAL_API_KEY=9a4a90eb-250b-4953-95e4-86c2db1695fc:61a4e14a87c8e1e87820fe44e8317856
```

### **Verify Environment**
```bash
cd /Users/rockymedure/Desktop/hidden_nature/HIDDEN_ARCHITECTS_SERIES/wasps_paper_factory
source .env
echo $FAL_API_KEY  # Should display the API key
```

---

## 📊 **PRODUCTION SPECIFICATIONS**

| Parameter | Value |
|-----------|-------|
| **Series** | Hidden Architects |
| **Episode** | 4 - The Wasp's Paper Factory |
| **Narrator** | Rachel (precision, design focus) |
| **Duration** | 3:12 (192 seconds) |
| **Format** | 24 scenes × 8 seconds each |
| **Aspect Ratio** | 16:9 (1920×1080) |
| **Resolution** | 1080p |
| **Visual Style** | Extreme macro (50-100x magnification) |
| **Lighting** | Golden hour, professional macro setup |

---

## 🎙️ **NARRATION DETAILS**

**Narrator**: Rachel
**Voice ID**: (Search via ElevenLabs MCP)
**Model**: eleven_turbo_v2_5 (supports audio tags if needed)
**Stability**: 0.5 (natural, balanced)
**Similarity Boost**: 0.75
**Style**: 0.5
**Speed**: 1.0 (natural delivery)

**Target Duration Per Scene**: 6.0-7.8 seconds
**Final Padding**: All scenes padded to exactly 8.000 seconds

---

## 🎬 **PRODUCTION WORKFLOW**

### **PHASE 1: ✅ SCRIPT DEVELOPMENT** (COMPLETE)
- [x] 24-scene script written
- [x] All narration text finalized
- [x] Visual descriptions detailed
- [x] Music prompts specified
- **File**: `THE_WASPS_PAPER_FACTORY_SCRIPT.md`

### **PHASE 2: 🎙️ NARRATION GENERATION** (READY TO START)
```bash
./generate_narrations.sh
```
**Output**: `audio/scene{1-24}.mp3`
**Timing**: ~15 minutes (parallel API calls)
**Quality Check**: Verify all files 6.0-7.8s, pad to 8.000s

### **PHASE 3: 🎥 VIDEO GENERATION** (PARALLEL)
```bash
./generate_videos.sh
```
**Output**: `videos/scene{1-24}.mp4`
**Visual Style**: Extreme macro (50-100x), golden hour lighting, botanical focus
**Timing**: ~30 minutes (parallel API calls)
**Quality Check**: All videos exactly 8 seconds

### **PHASE 4: 🎵 MUSIC GENERATION** (PARALLEL)
```bash
./generate_music.sh
```
**Output**: `music/scene{N}_music.wav`
**Style**: D Major, 65-85 BPM progression, architectural/elegant theme
**Timing**: ~20 minutes (parallel API calls)
**Quality Check**: All music exactly 8 seconds

### **PHASE 5: 🔊 AUDIO MIXING** (SEQUENTIAL)
```bash
./mix_all_scenes.sh
```
**Inputs**: 
- Video ambient audio (0.175x volume)
- Narration (1.3x volume)
- Scene music (0.20x volume)

**Output**: `final/scene{1-24}_mixed.mp4`
**Audio Specs**: AAC codec, 44.1kHz, mono (CRITICAL for concatenation)
**Timing**: ~10 minutes
**Quality Check**: Verify all scenes have consistent audio properties

### **PHASE 6: ✂️ FINAL COMPILATION** (SEQUENTIAL)
```bash
./compile_final.sh
```
**Input**: `final/scene{1-24}_mixed.mp4`
**Output**: `THE_WASPS_PAPER_FACTORY.mp4`
**Duration**: Exactly 3:12 (192 seconds)
**Timing**: ~2 minutes
**Quality Check**: Playback verification, audio consistency

---

## 🎬 **CLIPS EXTRACTION**

### **YouTube Shorts** (60 seconds each)
After final compilation:

**Clip 1**: "The Paper Invention" (Scenes 1-2)
- 0:00-1:12 (Scene 1-2 content)
- Hook: Wasp inventing paper discovery
- CTA: Subscribe for full documentary

**Clip 2**: "Hexagon Perfection" (Scenes 7-8)
- ~1:00-2:16 (from full doc)
- Hook: Perfect geometry reveal
- CTA: How does nature do math?

**Clip 3**: "Engineering Mastery" (Scenes 11-12)
- ~1:40-2:36 (from full doc)
- Hook: Optimization challenge
- CTA: Nature vs human engineering

### **TikTok Clips** (15-30 seconds each)

**Clip 1**: "Nature's Paper Mill" (Scenes 3-4)
- 15 seconds, opening with mandibles working
- Hook in first 2s: Extreme close-up of wasp processing wood
- #NatureEngineering #Biomimicry

**Clip 2**: "Perfect Geometry" (Scenes 9-10)
- 20 seconds, focus on hexagon precision
- Hook: Mathematical perfection revealed
- #NatureGeometry #ArchitectureInNature

**Clip 3**: "We Copied This" (Scenes 17-18)
- 18 seconds, wasp nest → human structures
- Hook: Humans copying nature
- #Biomimicry #NatureFirst

---

## ⚙️ **CRITICAL QUALITY CHECKS**

### **Audio Synchronization**
- [ ] All narrations 6.0-7.8 seconds before padding
- [ ] All narrations padded to exactly 8.000s
- [ ] No audio bleeding between scenes
- [ ] All mixed scenes have AAC 44.1kHz mono audio
- [ ] Final compilation plays smoothly with no dropouts

### **Video Quality**
- [ ] All 24 videos exactly 8 seconds
- [ ] All videos 1920×1080 (1080p)
- [ ] Consistent color grading (golden hour theme)
- [ ] Macro photography style maintained
- [ ] Scene transitions smooth and logical

### **Audio Mixing**
- [ ] Ambient audio audible but not dominant
- [ ] Narration clear and prominent
- [ ] Music supports without overpowering
- [ ] No clipping or distortion
- [ ] Balanced levels across all scenes

### **Final Output**
- [ ] Duration exactly 3:12 (192 seconds)
- [ ] All 24 scenes compiled in order
- [ ] No missing scenes
- [ ] Audio plays throughout
- [ ] File playable on all major platforms

---

## 🚀 **ESTIMATED TIMELINE**

| Phase | Task | Time | Status |
|-------|------|------|--------|
| 1 | Script Development | ✅ DONE | Complete |
| 2 | Narration Generation | ~15 min | Ready to start |
| 3 | Video Generation | ~30 min | Parallel to Phase 2 |
| 4 | Music Generation | ~20 min | Parallel to Phase 2-3 |
| 5 | Audio Mixing | ~10 min | After Phase 2-4 |
| 6 | Final Compilation | ~2 min | After Phase 5 |
| 7 | Clips Extraction | ~5 min | After Phase 6 |
| **TOTAL** | **Complete Documentary** | **~50-60 minutes** | **Queue ready** |

---

## 📝 **NEXT STEPS**

1. **Confirm Rachel's voice ID** via ElevenLabs MCP
2. **Create `generate_narrations.sh`** script
3. **Run narration generation** (Phase 2)
4. **Monitor API usage** (should use ~200K credits for full doc)
5. **Quality check** each phase before proceeding
6. **Extract clips** for multi-platform distribution

---

## 🎯 **SUCCESS CRITERIA**

✅ All 24 scenes generate successfully
✅ Narration timing fits within 6.0-7.8s range
✅ Audio padding creates perfect 8.000s boundaries
✅ Music supports architectural/elegant theme
✅ Final documentary is exactly 3:12
✅ YouTube Shorts ready for publication
✅ TikTok clips optimized for virality
✅ No audio dropouts or synchronization issues

---

**Ready to begin Phase 2: Narration Generation!** 🎙️

Location: `/Users/rockymedure/Desktop/hidden_nature/HIDDEN_ARCHITECTS_SERIES/wasps_paper_factory/`

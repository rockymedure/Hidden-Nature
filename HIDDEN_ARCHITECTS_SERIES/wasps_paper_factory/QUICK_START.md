# THE WASP'S PAPER FACTORY - QUICK START GUIDE

## 🚀 ONE COMMAND TO RULE THEM ALL

```bash
cd /Users/rockymedure/Desktop/hidden_nature/HIDDEN_ARCHITECTS_SERIES/wasps_paper_factory
./PRODUCTION_MASTER.sh
```

**That's it.** Everything else happens automatically.

---

## ⚡ WHAT HAPPENS

### PHASE 2-4: PARALLEL GENERATION (runs simultaneously)
- 🎙️ **24 Narrations** - Rachel voice, 8 seconds each
- 🎥 **24 Videos (16:9)** - YouTube format
- 🎥 **24 Videos (9:16)** - TikTok format  
- 🎵 **24 Music tracks** - Scene-specific D Major orchestration

### PHASE 5: AUDIO MIXING
- 3-layer mix (ambient 0.175x + narration 1.3x + music 0.20x)
- Applied to both 16:9 and 9:16 versions

### PHASE 6: COMPILATION
- ✅ YouTube 16:9 (3:12 complete)
- ✅ TikTok 9:16 (3:12 complete)

### PHASE 7: HIGHLIGHTS GENERATION
- 🎬 Automatically chops TikTok into alternating 16/24-second segments
- Perfect for social media clips

---

## 📺 FINAL OUTPUTS

```
final/
  └── THE_WASPS_PAPER_FACTORY_YOUTUBE_16x9.mp4  ← YouTube upload
  
final_9x16/
  └── THE_WASPS_PAPER_FACTORY_TIKTOK_9x16.mp4   ← TikTok upload

highlights/
  ├── highlight_1_16s.mp4   ← 16 seconds (0:00-0:16)
  ├── highlight_2_24s.mp4   ← 24 seconds (0:16-0:40)
  ├── highlight_3_16s.mp4   ← 16 seconds (0:40-0:56)
  ├── highlight_4_24s.mp4   ← 24 seconds (0:56-1:20)
  └── ... (more segments)
```

---

## ⏱️ EXPECTED TIMELINE

- **Narrations**: ~3-5 minutes
- **Videos (16:9 + 9:16)**: ~15-20 minutes (parallel!)
- **Music**: ~5-10 minutes (parallel!)
- **Mixing**: ~5 minutes
- **Compilation**: ~2 minutes
- **Highlights**: ~2 minutes

**TOTAL**: ~35-45 minutes for complete production

---

## ✅ QUALITY GUARANTEE

- ✅ All narrations exactly 8.000 seconds
- ✅ All videos exactly 8 seconds
- ✅ All music exactly 8 seconds
- ✅ YouTube 16:9 ready to upload
- ✅ TikTok 9:16 ready to upload
- ✅ Highlight segments optimized for social media

---

## 🎯 SETUP CHECKLIST

- [x] `.env` file with FAL_API_KEY
- [x] Script folder structure created
- [x] All dependencies available (ffmpeg, curl, jq)
- [x] Master script ready

**Status**: ✅ **READY TO EXECUTE**

---

## 🔴 IF SOMETHING FAILS

1. Check `.env` has valid FAL_API_KEY
2. Verify network connection
3. Ensure FFmpeg is installed (`ffmpeg -version`)
4. Check disk space (need ~500MB+ for temp files)
5. Try running again - sometimes API calls timeout

---

## 🎬 GO!

```bash
./PRODUCTION_MASTER.sh
```

Sit back. Coffee break. Everything happens in parallel while you wait. ☕


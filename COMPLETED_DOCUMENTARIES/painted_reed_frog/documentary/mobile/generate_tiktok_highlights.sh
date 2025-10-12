#!/bin/bash

HIGHLIGHTS_DIR="highlights"
mkdir -p "$HIGHLIGHTS_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎬 GENERATING TIKTOK/SHORTS HIGHLIGHT REELS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# REEL 1: The Awakening (Scenes 1-4) - 32s - Dawn camouflage
echo "🎥 REEL 1: The Awakening (32s)..."
ffmpeg -y -i "mixed/scene01_mixed.mp4" -i "mixed/scene02_mixed.mp4" -i "mixed/scene03_mixed.mp4" -i "mixed/scene04_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a]concat=n=4:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL1_The_Awakening.mp4" 2>/dev/null
echo "✅ REEL 1 complete (32s)"

# REEL 2: Transformation Begins (Scenes 7-10) - 32s - Twilight color change
echo "🎥 REEL 2: Transformation Begins (32s)..."
ffmpeg -y -i "mixed/scene07_mixed.mp4" -i "mixed/scene08_mixed.mp4" -i "mixed/scene09_mixed.mp4" -i "mixed/scene10_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a]concat=n=4:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL2_Transformation_Begins.mp4" 2>/dev/null
echo "✅ REEL 2 complete (32s)"

# REEL 3: Full Bloom 🔥 (Scenes 11-13) - 24s - Complete transformation reveal
echo "🎥 REEL 3: Full Bloom 🔥 (24s)..."
ffmpeg -y -i "mixed/scene11_mixed.mp4" -i "mixed/scene12_mixed.mp4" -i "mixed/scene13_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL3_Full_Bloom.mp4" 2>/dev/null
echo "✅ REEL 3 complete (24s) 🔥"

# REEL 4: Finding Voice (Scenes 14-16) - 24s - Night freedom
echo "🎥 REEL 4: Finding Voice (24s)..."
ffmpeg -y -i "mixed/scene14_mixed.mp4" -i "mixed/scene15_mixed.mp4" -i "mixed/scene16_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL4_Finding_Voice.mp4" 2>/dev/null
echo "✅ REEL 4 complete (24s)"

# REEL 5: Courtship Dance (Scenes 17-19) - 24s - Mating display
echo "🎥 REEL 5: Courtship Dance (24s)..."
ffmpeg -y -i "mixed/scene17_mixed.mp4" -i "mixed/scene18_mixed.mp4" -i "mixed/scene19_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL5_Courtship_Dance.mp4" 2>/dev/null
echo "✅ REEL 5 complete (24s)"

# REEL 6: Hidden World (Scenes 20-21) - 16s - Community reveal
echo "🎥 REEL 6: Hidden World (16s)..."
ffmpeg -y -i "mixed/scene20_mixed.mp4" -i "mixed/scene21_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL6_Hidden_World.mp4" 2>/dev/null
echo "✅ REEL 6 complete (16s)"

# REEL 7: Fading Beauty (Scenes 22-24) - 24s - Sunrise transformation reverse
echo "🎥 REEL 7: Fading Beauty (24s)..."
ffmpeg -y -i "mixed/scene22_mixed.mp4" -i "mixed/scene23_mixed.mp4" -i "mixed/scene24_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL7_Fading_Beauty.mp4" 2>/dev/null
echo "✅ REEL 7 complete (24s)"

# REEL 8: Complete Journey (Scenes 9,10,11,12,23) - 40s - Quick transformation arc
echo "🎥 REEL 8: Complete Journey (40s)..."
ffmpeg -y -i "mixed/scene09_mixed.mp4" -i "mixed/scene10_mixed.mp4" -i "mixed/scene11_mixed.mp4" -i "mixed/scene12_mixed.mp4" -i "mixed/scene23_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a][4:v][4:a]concat=n=5:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k "$HIGHLIGHTS_DIR/REEL8_Complete_Journey.mp4" 2>/dev/null
echo "✅ REEL 8 complete (40s)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL TIKTOK/SHORTS HIGHLIGHTS COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Created $(ls $HIGHLIGHTS_DIR/*.mp4 2>/dev/null | wc -l) highlight reels:"
echo ""
ls -lh "$HIGHLIGHTS_DIR"/*.mp4 | awk '{print "   " $9 " (" $5 ")"}'
echo ""
echo "🎬 Reels ready for TikTok, Instagram Reels, YouTube Shorts!"


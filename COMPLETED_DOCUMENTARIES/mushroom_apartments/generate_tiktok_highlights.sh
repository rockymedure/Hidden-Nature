#!/bin/bash

echo "🎬 GENERATING TIKTOK HIGHLIGHT REELS"
echo "📱 Using existing 9:16 mobile mixed scenes"
echo ""

mkdir -p highlights

# REEL 1: THE LIVING CITY (Scenes 2-4, 7) - 32 seconds
echo "🎥 REEL 1: The Living City (32s)..."
ffmpeg -y \
    -i "mobile/scene02_mixed.mp4" \
    -i "mobile/scene03_mixed.mp4" \
    -i "mobile/scene04_mixed.mp4" \
    -i "mobile/scene07_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a]concat=n=4:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    "highlights/REEL1_The_Living_City.mp4" 2>/dev/null

echo "✅ REEL 1 complete (32s)"

# REEL 2: GOURMETS & FARMERS (Scenes 8-10) - 24 seconds
echo "🎥 REEL 2: Gourmets & Farmers (24s)..."
ffmpeg -y \
    -i "mobile/scene08_mixed.mp4" \
    -i "mobile/scene09_mixed.mp4" \
    -i "mobile/scene10_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    "highlights/REEL2_Gourmets_and_Farmers.mp4" 2>/dev/null

echo "✅ REEL 2 complete (24s)"

# REEL 3: PREDATORS (Scenes 11-12) - 16 seconds
echo "🎥 REEL 3: Predators (16s)..."
ffmpeg -y \
    -i "mobile/scene11_mixed.mp4" \
    -i "mobile/scene12_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    "highlights/REEL3_Predators.mp4" 2>/dev/null

echo "✅ REEL 3 complete (16s)"

# REEL 4: WILDLIFE RESIDENTS (Scenes 13-15) - 24 seconds
echo "🎥 REEL 4: Wildlife Residents (24s)..."
ffmpeg -y \
    -i "mobile/scene13_mixed.mp4" \
    -i "mobile/scene14_mixed.mp4" \
    -i "mobile/scene15_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    "highlights/REEL4_Wildlife_Residents.mp4" 2>/dev/null

echo "✅ REEL 4 complete (24s)"

# REEL 5: ZOMBIE FUNGI 🔥 VIRAL POTENTIAL (Scenes 17-22) - 48 seconds
echo "🎥 REEL 5: Zombie Fungi 🔥 (48s)..."
ffmpeg -y \
    -i "mobile/scene17_mixed.mp4" \
    -i "mobile/scene18_mixed.mp4" \
    -i "mobile/scene19_mixed.mp4" \
    -i "mobile/scene20_mixed.mp4" \
    -i "mobile/scene21_mixed.mp4" \
    -i "mobile/scene22_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a][3:v][3:a][4:v][4:a][5:v][5:a]concat=n=6:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    "highlights/REEL5_Zombie_Fungi.mp4" 2>/dev/null

echo "✅ REEL 5 complete (48s) 🔥 VIRAL POTENTIAL"

# REEL 6: LIFE CYCLE (Scenes 23-25) - 24 seconds
echo "🎥 REEL 6: Life Cycle (24s)..."
ffmpeg -y \
    -i "mobile/scene23_mixed.mp4" \
    -i "mobile/scene24_mixed.mp4" \
    -i "mobile/scene25_mixed.mp4" \
    -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
    -map "[v]" -map "[a]" \
    -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k \
    "highlights/REEL6_Life_Cycle.mp4" 2>/dev/null

echo "✅ REEL 6 complete (24s)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ TIKTOK HIGHLIGHT REELS COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Generated 6 TikTok-ready reels:"
echo ""
echo "   1. The Living City (32s) - Opening hook"
echo "   2. Gourmets & Farmers (24s) - 27,000 teeth fact"
echo "   3. Predators (16s) - Tiny hunters"
echo "   4. Wildlife Residents (24s) - Charming animals"
echo "   5. Zombie Fungi (48s) 🔥 - VIRAL POTENTIAL"
echo "   6. Life Cycle (24s) - Beautiful renewal"
echo ""
echo "📁 Location: highlights/"
echo "✅ All reels include narration + music + ambient audio"
echo ""
echo "Next: Review TIKTOK_POSTING_GUIDE.md for posting strategy"

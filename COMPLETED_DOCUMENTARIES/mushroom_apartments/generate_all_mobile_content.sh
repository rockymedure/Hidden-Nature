#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🍄 THE MUSHROOM APARTMENTS"
echo "   Complete Mobile & TikTok Content Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will generate:"
echo "  📱 9:16 Mobile Documentary (scenes 2-26)"
echo "  🎬 6 TikTok Highlight Reels (16s-48s each)"
echo ""
echo "⏭️  Note: Scene 1 (Anju intro) skipped for mobile version"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1: Generate Mobile Videos (9:16)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

./generate_mobile_videos_9x16.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2: Mix Mobile Scenes (Audio)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

./mix_mobile_scenes.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3: Compile Final Mobile Documentary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

./compile_mobile_documentary.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 4: Generate TikTok Highlight Reels"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

./generate_tiktok_highlights.sh

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ ALL MOBILE CONTENT COMPLETE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📱 Mobile Documentary:"
echo "   THE_MUSHROOM_APARTMENTS_MOBILE_9x16.mp4"
echo ""
echo "🎬 TikTok Reels (highlights/):"
echo "   1. The Living City (32s)"
echo "   2. Gourmets & Farmers (24s)"
echo "   3. Predators (16s)"
echo "   4. Wildlife Residents (24s)"
echo "   5. Zombie Fungi (48s) 🔥 VIRAL POTENTIAL"
echo "   6. Life Cycle (24s)"
echo ""
echo "📋 Next Steps:"
echo "   1. Review TIKTOK_POSTING_GUIDE.md for posting strategy"
echo "   2. Start with Reel 1 + Reel 2 on Day 1"
echo "   3. Drop Reel 5 (Zombie Fungi) on Day 2 morning for max viral"
echo ""
echo "🚀 Ready to dominate TikTok!"

#!/bin/bash
# LIQUID STARLIGHT - Master Production Script
# Complete documentary production pipeline from script to final output

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║         LIQUID STARLIGHT                               ║"
echo "║         Complete Documentary Production Pipeline             ║"
echo "║         Hidden Beauty Series                             ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check for .env file
if [[ ! -f .env ]]; then
    echo "❌ ERROR: .env file not found!"
    echo ""
    echo "Please create .env file with your API credentials:"
    echo "  cp .env.template .env"
    echo "  # Edit .env and add your FAL_API_KEY"
    echo ""
    exit 1
fi

# Load environment variables
source .env

# Verify API key exists
if [[ -z "$FAL_API_KEY" ]]; then
    echo "❌ ERROR: FAL_API_KEY not set in .env file!"
    echo ""
    echo "Please edit .env and add your fal.ai API key:"
    echo "  FAL_API_KEY=your_actual_api_key_here"
    echo ""
    exit 1
fi

echo "✅ Environment configured"
echo "   Project: Liquid Starlight: The Hidden Beauty of Algae"
echo "   Narrator: Arabella"
echo "   Series: Hidden Beauty"
echo ""

# Make all scripts executable
chmod +x *.sh

# ============================================
# PRODUCTION PIPELINE
# ============================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 1: NARRATION GENERATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
./generate_narration.sh
if [[ $? -ne 0 ]]; then
    echo ""
    echo "❌ Narration generation failed. Stopping pipeline."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 2: VIDEO GENERATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
./generate_videos.sh
if [[ $? -ne 0 ]]; then
    echo ""
    echo "❌ Video generation failed. Stopping pipeline."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 3: MUSIC GENERATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
./generate_music.sh
if [[ $? -ne 0 ]]; then
    echo ""
    echo "❌ Music generation failed. Stopping pipeline."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 4: AUDIO MIXING"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
./mix_audio.sh
if [[ $? -ne 0 ]]; then
    echo ""
    echo "❌ Audio mixing failed. Stopping pipeline."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 5: FINAL ASSEMBLY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
./assemble_final.sh
if [[ $? -ne 0 ]]; then
    echo ""
    echo "❌ Final assembly failed. Stopping pipeline."
    exit 1
fi

# ============================================
# PRODUCTION COMPLETE
# ============================================

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║  ✨ PRODUCTION COMPLETE! ✨                                  ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 DELIVERABLES:"
echo ""
echo "   📹 DOCUMENTARY:"
echo "      documentary/FINAL_DOCUMENTARY.mp4"
echo ""
echo "   📝 COMPANION CONTENT:"
echo "      field_journal/FIELD_JOURNAL_TERMITE_CATHEDRALS.md (2,847 words)"
echo "      podcast/PODCAST_SCRIPT.md (18-20 min dialogue)"
echo ""
echo "   📢 YOUTUBE PUBLISHING:"
echo "      YOUTUBE_METADATA.md (complete publishing package)"
echo ""
echo "   🎬 MASTER SCRIPT:"
echo "      MASTER_SCRIPT.md (24 scenes, 3:12 duration)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎯 NEXT STEPS:"
echo ""
echo "   1. Review documentary/FINAL_DOCUMENTARY.mp4"
echo "   2. Generate mobile version (9:16): ./generate_mobile.sh"
echo "   3. Generate podcast audio: ./generate_podcast.sh"
echo "   4. Publish to YouTube with metadata from YOUTUBE_METADATA.md"
echo "   5. Publish field journal to Substack"
echo "   6. Upload podcast to podcast platforms"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ Liquid Starlight: The Hidden Beauty of Algae - A Hidden Nature Production ✨"
echo ""

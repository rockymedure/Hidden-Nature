#!/bin/bash
# Octopus Mind Folder Cleanup
# Removes intermediate files and old versions
# Reduces from 6.2GB to ~1.2GB (80% reduction)

set -e

echo "🗂️  OCTOPUS MIND FOLDER CLEANUP"
echo "=============================="
echo ""
echo "This will delete ~5.0GB of intermediate and duplicate files"
echo "Final products and source scripts will be preserved"
echo ""

# Safety check
read -p "Are you sure you want to proceed? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "🗑️  Starting cleanup..."
echo ""

# 1. Delete intermediate video directories (4.5GB)
echo "Removing intermediate video directories..."
rm -rf octopus_videos/
rm -rf octopus_mixed_emotional/
rm -rf octopus_mixed_arabella/
rm -rf cosmos_mixed_integrated/
rm -rf charlotte_final/
rm -rf charlotte_videos/
echo "✅ Removed video processing directories (4.5GB)"

# 2. Delete old teaser clips (564MB)
echo "Removing old teaser clips..."
rm -rf teaser_clips/
rm -rf teaser_clips_fixed/
echo "✅ Removed teaser clips directories (564MB)"

# 3. Delete duplicate/fake images (9.4MB)
echo "Removing duplicate and AI-generated images..."
rm -rf field_journal_images/
rm -rf field_journal_raw_frames/
echo "✅ Removed duplicate image directories (9.4MB)"

# 4. Delete intermediate audio/response files (4.8MB)
echo "Removing intermediate audio files..."
rm -rf charlotte_audio/
rm -rf charlotte_responses/
rm -rf octopus_responses/
rm -rf field_journal_responses/
rm -rf field_journal_responses_enhanced/
rm -rf octopus_narrations/
echo "✅ Removed intermediate audio/response directories"

# 5. Delete old narration files in root
echo "Removing old narration files..."
rm -f scene*_FIXED.mp3
rm -f scene*_PROPER_INTRO*.mp3
echo "✅ Removed old narration files"

# 6. Delete old/duplicate scripts
echo "Removing old generation scripts..."
rm -f generate_octopus*.sh
rm -f generate_cosmos*.sh
rm -f generate_charlottes*.sh
rm -f enhance_frames*.sh
rm -f extract_and_enhance*.sh
rm -f create_30sec_teaser.sh  # Keep only the FIXED version
echo "✅ Removed old generation scripts"

# 7. Delete old/duplicate markdown files
echo "Removing old markdown versions..."
rm -f THE_OCTOPUS_MIND_CHARLOTTE_VERSION.md
rm -f COSMOS_HOME_QUEST_SCRIPT.md
rm -f MUSIC_SCORE_TIMELINE_OLD.md
rm -f MUSIC_GENERATION_PROMPTS.md
echo "✅ Removed old markdown versions"

# 8. Delete old videos in root (keep only the final and teaser)
echo "Removing old video versions..."
rm -f CHARLOTTES_OCTOPUS_MIND_EMOTIONAL.mp4  # We have the WITH_MUSIC version
rm -f OCTOPUS_MIND_30SEC_TEASER.mp4
rm -f OCTOPUS_MIND_30SEC_TEASER_WEB.mp4
rm -f OCTOPUS_MIND_30SEC_WEB_FIXED.mp4
rm -f OCTOPUS_MIND_30SEC_TEASER_FIXED.mp4
rm -f OCTOPUS_MIND_30SEC_SUBSTACK.mp4  # Old version with cut-off
echo "✅ Removed old video versions"

# 9. Delete playlist files (we don't need these after compilation)
echo "Removing playlist files..."
rm -f *playlist*.txt
echo "✅ Removed playlist files"

echo ""
echo "✨ ================================ ✨"
echo "   CLEANUP COMPLETE!"
echo "✨ ================================ ✨"
echo ""
echo "📊 Final folder contents:"
du -sh .
echo ""
echo "✅ KEPT FILES:"
echo "   • CHARLOTTES_OCTOPUS_MIND_EMOTIONAL_WITH_MUSIC.mp4 (Full documentary)"
echo "   • OCTOPUS_MIND_30SEC_SUBSTACK_FIXED.mp4 (Substack teaser)"
echo "   • Octopus_Mind_Documentary_Score_2025-10-01T175955.mp3 (Music)"
echo "   • field_journal_enhanced/ (10 images for Substack)"
echo "   • SUBSTACK_FIELD_JOURNAL.md (Article)"
echo "   • YOUTUBE_METADATA.md (Metadata)"
echo "   • CHARLOTTES_COSMOS_HOME_QUEST.md (Script)"
echo "   • THE_OCTOPUS_MIND_SCRIPT.md (Original script)"
echo "   • MUSIC_SCORE_TIMELINE.md (Score notes)"
echo "   • .env (API keys)"
echo ""
echo "🎉 Saved ~5.0GB of disk space!"


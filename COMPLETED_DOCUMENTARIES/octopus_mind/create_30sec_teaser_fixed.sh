#!/bin/bash
# Create 30-second teaser with FULL narrations (no cut-offs)
# Adjusted to ensure complete sentences

set -e

echo "🎬 CREATING 30-SECOND TEASER (FIXED NARRATIONS)"
echo "================================================"
echo ""

VIDEO="CHARLOTTES_OCTOPUS_MIND_EMOTIONAL_WITH_MUSIC.mp4"

if [[ ! -f "$VIDEO" ]]; then
    echo "❌ Error: Source video not found"
    exit 1
fi

mkdir -p teaser_clips_fixed

echo "📹 Extracting key moments with complete narrations..."
echo ""

# Adjusted timing to capture full narrations:
# Scene 1 is 8 seconds, but we'll take 6s to keep teaser short
# Scene 2 is 8s - take 4s  
# Scene 3 is 8s - take 4s
# Jump to key moments for rest

echo "Clip 1: Charlotte introduction - FULL narration (8s)"
ffmpeg -y -ss 00:00:00 -i "$VIDEO" -t 8 -c copy teaser_clips_fixed/clip1.mp4 2>/dev/null

echo "Clip 2: Aerial reef overview (4s)"
ffmpeg -y -ss 00:00:08 -i "$VIDEO" -t 4 -c copy teaser_clips_fixed/clip2.mp4 2>/dev/null

echo "Clip 3: Cosmos emerges (4s)"
ffmpeg -y -ss 00:00:16 -i "$VIDEO" -t 4 -c copy teaser_clips_fixed/clip3.mp4 2>/dev/null

echo "Clip 4: Problem solving (3s)"
ffmpeg -y -ss 00:00:48 -i "$VIDEO" -t 3 -c copy teaser_clips_fixed/clip4.mp4 2>/dev/null

echo "Clip 5: Building fortress (3s)"
ffmpeg -y -ss 00:01:24 -i "$VIDEO" -t 3 -c copy teaser_clips_fixed/clip5.mp4 2>/dev/null

echo "Clip 6: Color communication (3s)"
ffmpeg -y -ss 00:02:32 -i "$VIDEO" -t 3 -c copy teaser_clips_fixed/clip6.mp4 2>/dev/null

echo "Clip 7: Recognition moment (3s)"
ffmpeg -y -ss 00:02:57 -i "$VIDEO" -t 3 -c copy teaser_clips_fixed/clip7.mp4 2>/dev/null

echo "Clip 8: Final triumph (2s)"
ffmpeg -y -ss 00:03:26 -i "$VIDEO" -t 2 -c copy teaser_clips_fixed/clip8.mp4 2>/dev/null

echo ""
echo "🎞️  Concatenating clips..."

# Create concat file
cat > teaser_clips_fixed/concat.txt << EOF
file 'clip1.mp4'
file 'clip2.mp4'
file 'clip3.mp4'
file 'clip4.mp4'
file 'clip5.mp4'
file 'clip6.mp4'
file 'clip7.mp4'
file 'clip8.mp4'
EOF

# Concatenate all clips
ffmpeg -y -f concat -safe 0 -i teaser_clips_fixed/concat.txt -c copy \
    OCTOPUS_MIND_30SEC_TEASER_TEMP_FIXED.mp4 2>/dev/null

# Trim to exactly 30 seconds and re-encode
ffmpeg -y -i OCTOPUS_MIND_30SEC_TEASER_TEMP_FIXED.mp4 -t 30 \
    -c:v libx264 -preset slow -crf 18 \
    -c:a aac -b:a 192k \
    OCTOPUS_MIND_30SEC_TEASER_FIXED.mp4 2>/dev/null

# Create web-optimized version
echo ""
echo "🗜️  Creating web-optimized version..."
ffmpeg -y -i OCTOPUS_MIND_30SEC_TEASER_FIXED.mp4 \
    -c:v libx264 -preset slow -crf 23 \
    -c:a aac -b:a 128k -movflags +faststart \
    OCTOPUS_MIND_30SEC_WEB_FIXED.mp4 2>/dev/null

# Create Substack-optimized version
echo "🗜️  Creating Substack-optimized version..."
ffmpeg -y -i OCTOPUS_MIND_30SEC_TEASER_FIXED.mp4 \
    -vf "scale=1280:720" \
    -c:v libx264 -preset slow -crf 28 \
    -c:a aac -b:a 96k -movflags +faststart \
    OCTOPUS_MIND_30SEC_SUBSTACK_FIXED.mp4 2>/dev/null

# Clean up temp files
rm -f OCTOPUS_MIND_30SEC_TEASER_TEMP_FIXED.mp4

# Get file info
duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "OCTOPUS_MIND_30SEC_SUBSTACK_FIXED.mp4" | cut -d. -f1)
filesize=$(ls -lh "OCTOPUS_MIND_30SEC_SUBSTACK_FIXED.mp4" | awk '{print $5}')

echo ""
echo "✨ ===================================== ✨"
echo "   30-SECOND TEASER FIXED - COMPLETE!"
echo "✨ ===================================== ✨"
echo ""
echo "📊 Stats:"
echo "   Duration: ${duration}s"
echo "   File Size: $filesize (Substack version)"
echo ""
echo "📁 Files created:"
ls -lh OCTOPUS_MIND_30SEC*FIXED.mp4 | awk '{print "   " $9 ": " $5}'
echo ""
echo "📝 Teaser structure (30s total):"
echo "   0:00-0:08 → Charlotte FULL introduction (complete narration)"
echo "   0:08-0:12 → Aerial reef overview"
echo "   0:12-0:16 → Meet Cosmos"
echo "   0:16-0:19 → Problem-solving intelligence"
echo "   0:19-0:22 → Building fortress"
echo "   0:22-0:25 → Color communication"
echo "   0:25-0:28 → Recognition moment"
echo "   0:28-0:30 → Final triumph"
echo ""
echo "✅ Charlotte's narration is now COMPLETE!"
echo "   Use: OCTOPUS_MIND_30SEC_SUBSTACK_FIXED.mp4"
echo ""


#!/bin/bash
# Finalize both podcast versions with intro/outro music and ambient sounds
# Standard vs Enhanced comparison ready

set -e

cd /Users/rockymedure/Desktop/hidden_nature/COMPLETED_DOCUMENTARIES/octopus_mind

echo "🎸 FINALIZING PODCASTS"
echo "====================="
echo ""

# Check if we have the music score
MUSIC="../Octopus_Mind_Documentary_Score_2025-10-01T175955.mp3"
if [[ ! -f "$MUSIC" ]] && [[ -f "Octopus_Mind_Documentary_Score_2025-10-01T175955.mp3" ]]; then
    MUSIC="Octopus_Mind_Documentary_Score_2025-10-01T175955.mp3"
fi

echo "📻 Step 1: Concatenating STANDARD podcast segments..."
# Create playlist for standard version
cat > podcast_audio/playlist.txt << EOF
file 'segment1_intro.mp3'
file 'segment2_first_contact.mp3'
file 'segment3_the_search.mp3'
file 'segment4_engineering.mp3'
file 'segment5_the_moment.mp3'
file 'segment6_closing.mp3'
EOF

ffmpeg -y -f concat -safe 0 -i podcast_audio/playlist.txt -c copy \
    "OCTOPUS_MIND_PODCAST_STANDARD.mp3" 2>/dev/null

echo "✅ Standard version concatenated"
echo ""

echo "✨ Step 2: Concatenating ENHANCED podcast segments..."
# Create playlist for enhanced version
cat > podcast_audio_enhanced/playlist.txt << EOF
file 'segment1_intro.mp3'
file 'segment2_first_contact.mp3'
file 'segment3_the_search.mp3'
file 'segment4_engineering.mp3'
file 'segment5_the_moment.mp3'
file 'segment6_closing.mp3'
EOF

ffmpeg -y -f concat -safe 0 -i podcast_audio_enhanced/playlist.txt -c copy \
    "OCTOPUS_MIND_PODCAST_ENHANCED.mp3" 2>/dev/null

echo "✅ Enhanced version concatenated"
echo ""

# Add music intro/outro if available
if [[ -f "$MUSIC" ]]; then
    echo "🎵 Step 3: Adding musical intro/outro..."
    
    # Extract 8 seconds for intro and 10 seconds for outro
    ffmpeg -y -i "$MUSIC" -ss 0 -t 8 -af "afade=t=out:st=6:d=2" \
        "podcast_intro_music.mp3" 2>/dev/null
    
    ffmpeg -y -i "$MUSIC" -ss 180 -t 10 -af "afade=t=in:st=0:d=2,afade=t=out:st=8:d=2" \
        "podcast_outro_music.mp3" 2>/dev/null
    
    # Create versions with music
    echo "🎼 Adding music to STANDARD version..."
    cat > podcast_with_music_standard.txt << EOF
file 'podcast_intro_music.mp3'
file 'OCTOPUS_MIND_PODCAST_STANDARD.mp3'
file 'podcast_outro_music.mp3'
EOF
    
    ffmpeg -y -f concat -safe 0 -i podcast_with_music_standard.txt -c copy \
        "OCTOPUS_MIND_PODCAST_STANDARD_WITH_MUSIC.mp3" 2>/dev/null
    
    echo "✅ Standard + music complete"
    
    echo "🎼 Adding music to ENHANCED version..."
    cat > podcast_with_music_enhanced.txt << EOF
file 'podcast_intro_music.mp3'
file 'OCTOPUS_MIND_PODCAST_ENHANCED.mp3'
file 'podcast_outro_music.mp3'
EOF
    
    ffmpeg -y -f concat -safe 0 -i podcast_with_music_enhanced.txt -c copy \
        "OCTOPUS_MIND_PODCAST_ENHANCED_WITH_MUSIC.mp3" 2>/dev/null
    
    echo "✅ Enhanced + music complete"
    echo ""
    
    # Clean up temp files
    rm -f podcast_intro_music.mp3 podcast_outro_music.mp3
    rm -f podcast_with_music_standard.txt podcast_with_music_enhanced.txt
else
    echo "⚠️  No music file found, skipping musical intro/outro"
    echo ""
fi

echo ""
echo "🎸 ================================== 🎸"
echo "   PODCAST FINALIZATION COMPLETE!"
echo "🎸 ================================== 🎸"
echo ""
echo "📊 COMPARISON READY:"
echo ""
echo "📻 Standard Versions (Jeff + Lucy, no audio tags):"
ls -lh OCTOPUS_MIND_PODCAST_STANDARD*.mp3 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
echo ""
echo "✨ Enhanced Versions (Jeff + Lucy, with audio tags):"
ls -lh OCTOPUS_MIND_PODCAST_ENHANCED*.mp3 2>/dev/null | awk '{print "   " $9 " (" $5 ")"}'
echo ""

# Get durations
echo "⏱️  Durations:"
for file in OCTOPUS_MIND_PODCAST_STANDARD.mp3 OCTOPUS_MIND_PODCAST_ENHANCED.mp3; do
    if [[ -f "$file" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null | awk '{printf "%d:%02d", $1/60, $1%60}')
        echo "   $file: $duration"
    fi
done
echo ""

echo "🎧 RECOMMENDED LISTENING ORDER:"
echo "   1. OCTOPUS_MIND_PODCAST_STANDARD_WITH_MUSIC.mp3"
echo "   2. OCTOPUS_MIND_PODCAST_ENHANCED_WITH_MUSIC.mp3"
echo ""
echo "💡 The enhanced version uses ElevenLabs V3 audio tags for:"
echo "   • Natural pauses and breathing"
echo "   • Emotional inflection (laughs, sighs, whispers)"
echo "   • Dynamic pacing and emphasis"
echo ""
echo "🚀 Ready to compare the difference audio tags make!"
echo ""


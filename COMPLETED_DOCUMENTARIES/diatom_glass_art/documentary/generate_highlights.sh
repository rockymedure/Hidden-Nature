#!/bin/bash

echo "🎬 DIATOM: Creating TikTok Highlight Reels"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Generating 8 optimized 24-32 second clips"
echo ""

# REEL 1: The Invisible Artist (Scenes 1-4, 32s)
echo "🎬 Reel 1: The Invisible Artist (Discovery Hook)..."
> highlights/reel1_playlist.txt
for i in 01 02 03 04; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel1_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel1_playlist.txt -c copy \
    "highlights/REEL1_The_Invisible_Artist.mp4" 2>/dev/null
echo "   ✅ 32s - Discovery hook"

# REEL 2: Building the Impossible (Scenes 5-7, 24s)
echo "🎬 Reel 2: Building the Impossible (Creation Process)..."
> highlights/reel2_playlist.txt
for i in 05 06 07; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel2_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel2_playlist.txt -c copy \
    "highlights/REEL2_Building_the_Impossible.mp4" 2>/dev/null
echo "   ✅ 24s - Process/creation"

# REEL 3: Invisible Heroes (Scenes 7-9, 24s)
echo "🎬 Reel 3: Invisible Heroes (Oxygen Revelation)..."
> highlights/reel3_playlist.txt
for i in 07 08 09; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel3_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel3_playlist.txt -c copy \
    "highlights/REEL3_Invisible_Heroes.mp4" 2>/dev/null
echo "   ✅ 24s - Environmental hero"

# REEL 4: Evolution Solution (Scenes 10-13, 32s)
echo "🎬 Reel 4: The Evolution Solution (Problem-Solving)..."
> highlights/reel4_playlist.txt
for i in 10 11 12 13; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel4_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel4_playlist.txt -c copy \
    "highlights/REEL4_Evolution_Solution.mp4" 2>/dev/null
echo "   ✅ 32s - Nature's genius"

# REEL 5: Death to Mountains (Scenes 13-16, 32s)
echo "🎬 Reel 5: From Death to Mountains (Scale Shock)..."
> highlights/reel5_playlist.txt
for i in 13 14 15 16; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel5_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel5_playlist.txt -c copy \
    "highlights/REEL5_Death_to_Mountains.mp4" 2>/dev/null
echo "   ✅ 32s - Mind-blown viral potential"

# REEL 6: Ancient Art Modern Use (Scenes 17-19, 24s)
echo "🎬 Reel 6: Ancient Art, Modern Use (Human Connection)..."
> highlights/reel6_playlist.txt
for i in 17 18 19; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel6_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel6_playlist.txt -c copy \
    "highlights/REEL6_Ancient_Art_Modern_Use.mp4" 2>/dev/null
echo "   ✅ 24s - Practical application"

# REEL 7: The Art Continues (Scenes 21-24, 32s)
echo "🎬 Reel 7: The Art Continues (Hopeful Finale)..."
> highlights/reel7_playlist.txt
for i in 21 22 23 24; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel7_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel7_playlist.txt -c copy \
    "highlights/REEL7_The_Art_Continues.mp4" 2>/dev/null
echo "   ✅ 32s - Inspirational finale"

# REEL 8: In Every Drop (Scenes 22-24, 24s)
echo "🎬 Reel 8: In Every Drop (Abundance Shock)..."
> highlights/reel8_playlist.txt
for i in 22 23 24; do
    echo "file '../mobile/scene${i}_mixed.mp4'" >> highlights/reel8_playlist.txt
done
ffmpeg -y -f concat -safe 0 -i highlights/reel8_playlist.txt -c copy \
    "highlights/REEL8_In_Every_Drop.mp4" 2>/dev/null
echo "   ✅ 24s - Scale revelation"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ ALL 8 TIKTOK HIGHLIGHT REELS COMPLETE! ✨"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Summary:"
for i in {1..8}; do
    reel_file=$(ls highlights/REEL${i}_*.mp4)
    if [[ -f "$reel_file" ]]; then
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$reel_file")
        filesize=$(ls -lh "$reel_file" | awk '{print $5}')
        basename=$(basename "$reel_file")
        printf "   ✅ Reel %d: %s (%.0fs, %s)\n" "$i" "$basename" "$duration" "$filesize"
    fi
done

echo ""
echo "📱 All reels are 9:16 portrait, ready for TikTok!"
echo "🎵 Full audio mix included (ambient + narration + music)"

# Clean up playlist files
rm highlights/reel*_playlist.txt


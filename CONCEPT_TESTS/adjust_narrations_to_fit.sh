#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚙️  ADJUSTING NARRATIONS TO FIT 16s VIDEO (SUBTLE SPEEDUP)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Target: ~15.5s max (to avoid cutoff at 16s video)"
echo ""

for dir in jumping_spider cuttlefish tardigrade venus_flytrap chameleon monarch; do
    narration_file="$dir/audio/narration_16s_natural.mp3"
    
    if [[ -f "$narration_file" ]]; then
        duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$narration_file")
        
        echo "$dir: ${duration}s"
        
        # If duration > 15.5s, speed it up to fit
        needs_adjustment=$(echo "$duration > 15.5" | bc -l)
        
        if [[ $needs_adjustment -eq 1 ]]; then
            # Calculate speed factor to fit in 15.5s
            speed=$(echo "$duration / 15.5" | bc -l)
            
            echo "   ⚙️  Adjusting speed by ${speed}x to fit..."
            
            ffmpeg -y -i "$narration_file" \
                -filter:a "atempo=$speed" \
                "$dir/audio/narration_16s_fitted.mp3" 2>/dev/null
            
            new_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$dir/audio/narration_16s_fitted.mp3")
            
            echo "   ✅ Adjusted: ${duration}s → ${new_duration}s (${speed}x speed)"
        else
            # Copy as-is if already fits
            cp "$narration_file" "$dir/audio/narration_16s_fitted.mp3"
            echo "   ✅ Already fits - no adjustment needed"
        fi
        echo ""
    fi
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ALL NARRATIONS ADJUSTED TO FIT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"


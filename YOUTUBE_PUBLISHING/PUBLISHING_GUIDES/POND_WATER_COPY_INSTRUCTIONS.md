# Manual Copy Instructions for Pond Water Documentary

## 📁 **SOURCE FILES** (Second Workspace)
Located at: `/Users/rockymedure/Desktop/julia/educational_network/pond_water_microscopic/`

### **Files to Copy:**
1. **Desktop Version**: `POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4`
2. **Mobile Version**: `POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4`

## 📁 **DESTINATION** (YouTube Ready Structure)
Copy to: `/Users/rockymedure/Desktop/hidden_nature/YOUTUBE_READY/`

### **Manual Copy Commands:**
```bash
# Copy desktop version
cp "/Users/rockymedure/Desktop/julia/educational_network/pond_water_microscopic/POND_WATER_MICROSCOPIC_NETFLIX_1080P.mp4" "/Users/rockymedure/Desktop/hidden_nature/YOUTUBE_READY/DOCUMENTARIES_16x9/05_Hidden_Worlds_Pond_Water_16x9.mp4"

# Copy mobile version  
cp "/Users/rockymedure/Desktop/julia/educational_network/pond_water_microscopic/POND_WATER_MICROSCOPIC_MOBILE_9x16.mp4" "/Users/rockymedure/Desktop/hidden_nature/YOUTUBE_READY/DOCUMENTARIES_9x16/02_Hidden_Worlds_Pond_Water_Mobile_9x16.mp4"
```

## ✅ **AFTER COPYING - VERIFICATION**
```bash
# Verify files copied successfully
ls -la "/Users/rockymedure/Desktop/hidden_nature/YOUTUBE_READY/DOCUMENTARIES_16x9/"*Pond*
ls -la "/Users/rockymedure/Desktop/hidden_nature/YOUTUBE_READY/DOCUMENTARIES_9x16/"*Pond*

# Check file sizes and durations
ffprobe -v quiet -show_entries format=duration,size -of default=noprint_wrappers=1 "YOUTUBE_READY/DOCUMENTARIES_16x9/05_Hidden_Worlds_Pond_Water_16x9.mp4"
```

## 📊 **EXPECTED RESULTS**
- **Desktop**: ~180MB, 3m 4s (23 scenes × 8s)
- **Mobile**: ~160MB, 3m 4s (same content, optimized framing)
- **Quality**: 1080p Netflix-standard with perfect synchronization

Once copied, your pond water documentary will be ready for YouTube publishing with complete metadata already prepared!

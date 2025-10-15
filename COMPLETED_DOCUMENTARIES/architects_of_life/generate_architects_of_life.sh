#!/bin/bash
source ../../.env

AUDIO_ENDPOINT="https://fal.run/fal-ai/elevenlabs/tts/eleven-v3"
VIDEO_ENDPOINT="https://fal.run/fal-ai/veo3/fast"
MUSIC_ENDPOINT="https://fal.run/fal-ai/stable-audio-25/text-to-audio"
NARRATOR_VOICE_ID="lcMyyd2HUfFzxdCaC4Ta" # Rachel - Cosmic Wonder
SEED=77777

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧬 GENERATING: THE ARCHITECTS OF LIFE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create folder structure
mkdir -p {audio,videos,music,final,responses}

# Narration array - 24 scenes
declare -a narrations=(
    "Inside every living thing exists an invisible architecture. Trillions of individual cells, each following ancient instructions, coordinating in perfect synchrony. This is how you were built."
    "It all begins with DNA. The instruction manual written in chemical code. Billions of letters. One continuous story. Read by billions of readers simultaneously."
    "Before a cell can do anything, it must first know who it is. So the DNA makes copies of itself. Billions of RNA messengers carry the instructions to where they're needed."
    "Ribosomes are the builders. Tiny factories that read the instructions and assemble proteins. Thousands of them working inside every cell. Each one building the molecules of life."
    "But all this work requires power. Deep inside the cell, structures called mitochondria burn fuel to create energy. The currency of life itself."
    "Cells don't work in isolation. They communicate. Constantly sending and receiving signals. Chemical whispers between neighbors. Instructions that say: grow, divide, specialize, or die."
    "Growth begins with division. One cell becomes two. Two become four. A mathematical expansion. But there's a secret hidden in this process. Perfect copies, every time."
    "One becomes two. Two become four. Four become eight. Exponential expansion. Within weeks, a single cell has multiplied into millions. The raw material is ready. Now comes the real work."
    "But not all cells are the same. Among the millions, each must choose what to become. A heart cell. A brain cell. A bone cell. How does a cell know? The answer is hidden in its position."
    "As signals flow through the growing tissue, cells transform. Turn on genes. Turn off others. Sculpt themselves into new shapes. Become specialists. Become heart. Become nerve. Become blood."
    "And here's the miracle. Despite their differences, these specialized cells don't compete. They cooperate. Building something none of them could build alone. A tissue. An organ. A system."
    "Connections form. Thousands of them. Millions. Neurons reaching out to touch other neurons. Creating networks. These connections are where thinking happens. Where memory lives. Where you become you."
    "Meanwhile, other cells are building scaffolding. Protein frameworks that give shape to the growing forms. Collagen strands weaving together. Supporting. Protecting. Holding everything in place."
    "Blood vessels are being built. Miles of them. Endothelial cells forming tubes that will carry oxygen and nutrients to billions of hungry cells. A circulatory system assembling itself."
    "Each tissue develops its own personality. Heart cells beat. Brain cells think. Bone cells calcify. Skin cells flake away and regenerate. Trillions of workers, each knowing exactly what to do."
    "Nothing is left to chance. Cells that don't fit the pattern are eliminated. Damaged cells are removed. The system self-corrects. Self-assembles. Self-perfects. An architecture built by pure biological engineering."
    "Gradually, separate tissues merge into organs. Individual organs coordinate into systems. Systems communicate with each other. A brain that can think. A heart that can feel. Lungs that can breathe."
    "Somewhere in this process, something remarkable happens. A threshold is crossed. No longer a collection of cells. Now a unified being. Something that can learn. Respond. Dream. Create."
    "But the building never really stops. Even now, billions of cells are dividing. Trillions are dying. Skin flakes away. Hair grows back. Bones strengthen. Blood regenerates. You are constantly being rebuilt."
    "And throughout it all, signals flow. Hormones. Neurotransmitters. Chemical whispers. Billions of cells in constant conversation. They sense damage. Respond to threat. Coordinate healing. The body speaking to itself in a language older than words."
    "Your cells adapt to every demand. Muscles grow stronger under load. Brain grows denser with learning. Skin toughens where it's needed. The architecture is not fixed. It evolves. It learns."
    "And when cells reach their limit, they have one final purpose. To make room for new ones. To pass on the instructions. The architecture is built for impermanence. Each cell knowing its time is temporary. Its contribution permanent."
    "You contain 37 trillion cells. Each one born from the same instruction. Each one following a role written before you existed. Each one expendable. Yet together, irreplaceable. This is what it means to be alive."
    "You are not made of stuff that builds itself. You ARE the builders. Architects of your own form. Trillions of them, following the oldest recipe. Creating something that's never been before. Something entirely new. Entirely alive."
)

# Visual prompts array - 24 scenes
declare -a visuals=(
    "Extreme macro shot of human embryo zooming into cellular level. Nucleus with DNA double helix visible. Warm golden lighting with cosmic perspective. Human silhouette for scale. Scientific and beautiful."
    "Extreme close-up of DNA double helix rotating slowly. Nucleotides and base pairs glowing in blue and gold. Ribbons unwinding. 100x magnification. Molecular precision and artistic beauty combined."
    "Animated cellular machinery in action. DNA unwinding, RNA polymerase transcribing. RNA messengers floating through cytoplasm. Blue DNA, orange/yellow RNA, green ribosomes. Highly detailed and vibrant."
    "Ribosomes assembling proteins like tiny factories. Amino acid chains being connected. 100x magnification. Multiple ribosomes working simultaneously. Glowing energy and motion effects. Semi-transparent cellular structures."
    "Mitochondrial cristae with intricate folded membranes. ATP synthase spinning like a turbine. Energy bursting in white/yellow light. Extreme magnification showing molecular detail. Multiple mitochondria firing."
    "Two adjacent cells with signal molecules traveling between them. Receptor proteins like locks and keys. Vesicles releasing neurotransmitters. Neon glowing connections. Cell membrane with protein receptors visible."
    "Time-lapse of cell division (mitosis). Chromosomes condensing, spindle fibers pulling chromatids apart, cleavage furrow forming. Two daughter cells separating. Blue/purple chromosomes, green spindle fibers. Multiple cycles."
    "Time-lapse of cell proliferation. 1→2→4→8→16→32→64→128 cells. Growing cluster into tissue mass. Zoom from microscopic to macro showing embryo growth. Warm golden/purple lighting. Multicellular development."
    "Early embryo with different regions in different colors. Morphogen concentration gradients visible. Cells responding to chemical signals. Differentiation beginning. Multiple cell types: cuboidal, columnar, neurons. 100x magnification."
    "Three comparative cellular differentiation sequences. Cardiomyocytes forming striations, neurons sprouting axons, blood cells differentiating. 100x magnification. Chromatin remodeling visible. Color coding: red, purple, orange."
    "Macro shot of early heart tissue beating. Zoom to individual cardiomyocytes with intercalated discs. Electrical signals traveling between cells. Gap junctions at 100x magnification. Synchronized rhythm visible."
    "100x magnification of neural network formation. Growing axons reaching dendrites. Synapses forming with vesicles visible. Multiple neurons connected creating networks. Bioluminescent electrical activity. Beautiful branching patterns."
    "Collagen fibrils under extreme magnification showing triple helix. Fibroblasts assembling collagen. 3D visualization of fibrous protein networks forming matrix. Cross-linked bundles creating strength. White/silver on dark background."
    "Angiogenesis - new blood vessel formation. Endothelial cells arranging into tubes. Capillaries branching into networks. Time-lapse of vascular development. Blood cells flowing through vessels. Cross-section of vessel wall at 100x magnification."
    "Split-screen of four tissue types at 100x magnification. Cardiac muscle with striations, brain tissue with neural connections, bone cells in lacunae, epithelial skin cells. Each showing characteristic structure. Some in action."
    "Programmed cell death (apoptosis). Cells with death markers being engulfed by macrophages. Cellular quality control mechanisms. 100x magnification of phagocytosis. Organelles being recycled. System self-correction visible."
    "Zoom from cellular level outward through tissue to macro view. Complete developing organs forming. Heart, brain, lungs. Organ-level complexity shown. Connections between organs visible. Beautiful lighting at each scale."
    "Macro view of nearly complete fetus. Movement and stretching visible. Sensory development - eye responding to light, ear to sound. Neural activity in brain imaging. Beautiful cinematic footage showing life and agency."
    "Adult human body from inside. Intestinal epithelial cells with rapid turnover at 100x magnification. Hair follicles generating hair. Bone cells remodeling bone. Skin cells differentiating upward. Compressed 24-hour renewal timeline."
    "Cellular signaling at 100x magnification. Signal molecules binding to receptors. Cascade effects throughout tissue. Inflammatory response to injury. Immune cells mobilizing. Healing with cells working together. Signal transduction pathways animated."
    "Muscle cells at 100x magnification with expanded sarcomeres. Neurons with enhanced dendritic spines from learning. Skin cells thickening. Mitochondria proliferating. Adaptation occurring in time-lapse. Evolution and learning visible."
    "Cellular aging - telomeres shortening, senescence. Cells undergoing apoptosis gracefully. Parent cells dividing creating daughters. Life cycle from birth through division/death. Beautiful cellular turnover rendering. Generational progression."
    "Macro shot of complete human body. Gradually zoom deeper through tissue to cellular to molecular to atomic level. Fractal nature of life shown. Complexity at every scale. Cells working together. Health and vitality visible."
    "Zoom from cellular level to human reflecting. Person as part of larger environment. Same architectural principles in nature everywhere. Trees, animals, organisms. Fractal patterns and universal design. Contemplative human face with wonder."
)

# Music prompts array - 24 scenes
declare -a music_prompts=(
    "Key: C Major, Tempo: 60 BPM, Instrumentation: Solo cello establishing theme, gentle ambient pads, sense of beginning and wonder, Mood: Birth of consciousness, microscopic mystery revealed, cosmic scale"
    "Key: C Major, Tempo: 65 BPM, Instrumentation: Layered strings (violin, viola, cello), subtle synthesizer notes like reading code, intellectual and beautiful, Mood: Scientific wonder, precision, elegance of molecular design"
    "Key: C Major, Tempo: 70 BPM, Instrumentation: Strings with rhythmic plucking (pizzicato), subtle percussion like tiny machinery sounds, building energy, Mood: Precision work, molecular assembly lines, organized chaos"
    "Key: C Major, Tempo: 75 BPM, Instrumentation: Rhythmic strings with metallic percussion, woodwinds entering, building complexity, Mood: Assembly lines, cooperation, mechanical precision with life"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Building orchestration: brass entering, timpani, strings driving forward, Mood: Power generation, energy, the engine of life, unstoppable force"
    "Key: C Major, Tempo: 75 BPM, Instrumentation: Conversational between two instruments (violin and cello dialogue), ambient pads, Mood: Communication, connection, cellular conversation, harmony"
    "Key: C Major, Tempo: 85 BPM, Instrumentation: Mirroring theme splitting into two voices, both identical, symmetrical composition, Mood: Duplication, precision, the mathematics of growth"
    "Key: C Major, Tempo: 90 BPM, Instrumentation: Theme repeating and layering, doubling with each iteration, exponential musical expansion, Mood: Multiplication, expansion, growth accelerating"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Different instruments entering for different cell types, creating ensemble, Mood: Specialization, diversity emerging from unity, individuality within collective"
    "Key: C Major, Tempo: 75 BPM, Instrumentation: Different melodic lines for cell types, but harmonizing together, Mood: Transformation, specialization, finding purpose"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Multiple instruments in perfect synchronization, creating unified rhythm, harmonious and powerful, Mood: Cooperation, teamwork, emergence of something greater"
    "Key: C Major, Tempo: 85 BPM, Instrumentation: Complex polyphonic arrangement with many interconnected melodic lines, all contributing to unified soundscape, Mood: Connection, consciousness emerging, infinite possibility"
    "Key: C Major, Tempo: 70 BPM, Instrumentation: Deep bass notes from low strings, solid foundation, supporting higher melodies, Mood: Structure, stability, the foundation that enables growth"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Flowing melody like water moving through channels, continuous and vital, Mood: Flow, circulation, life moving through the system"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Four distinct musical themes playing simultaneously, each recognizable, each contributing, Mood: Diversity, specialization, orchestrated complexity"
    "Key: C Major, Tempo: 75 BPM, Instrumentation: Clean, resolving chord progressions, mistakes being corrected into harmony, Mood: Precision, perfection through selection, building through elimination"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Themes merging from separate instruments into unified orchestra, all playing together, Mood: Integration, systems thinking, emergence of complexity"
    "Key: C Major, Tempo: 85 BPM, Instrumentation: Full orchestral theme, all parts playing, building to crescendo, Mood: Awakening, consciousness, emergence of self"
    "Key: C Major, Tempo: 90 BPM, Instrumentation: Rhythmic, steady, repetitive patterns showing continuous process, Mood: Maintenance, renewal, the constant work of staying alive"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Responsive musical dialogue, patterns echoing and building, call and response, Mood: Communication, conversation at molecular scale, coordination"
    "Key: C Major, Tempo: 85 BPM, Instrumentation: Themes evolving and developing, growing more complex, adapting their patterns, Mood: Evolution, learning, the system responding to challenge"
    "Key: C Major with minor resolution, Tempo: 75 BPM, Instrumentation: Gentle resolution of themes, cycles completing, new themes beginning, Mood: Mortality, purpose, continuity through change"
    "Key: C Major, Tempo: 85 BPM, Instrumentation: Full orchestral statement of main theme, all instruments, complex and beautiful, Mood: Magnificence, wonder, the beauty of organization"
    "Key: C Major, Tempo: 80 BPM, Instrumentation: Full theme resolving, all parts harmonizing perfectly, with extension suggesting continuation, Mood: Profound wonder, the mystery of consciousness, infinite possibility"
)

# Generate all narrations in parallel
echo "🎙️  Generating narrations..."
for i in {0..23}; do
    scene=$((i + 1))
    narration="${narrations[$i]}"
    
    (
        response=$(curl -s -X POST "$AUDIO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"text\": \"$narration\", \"voice\": \"$NARRATOR_VOICE_ID\", \"stability\": 0.5, \"similarity_boost\": 0.75, \"style\": 0.5, \"speed\": 1.0}")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        if [[ -n "$audio_url" ]]; then
            curl -s -o "audio/scene${scene}.mp3" "$audio_url"
            duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "audio/scene${scene}.mp3")
            
            # Adjust speed if needed
            if (( $(echo "$duration > 15.5" | bc -l) )); then
                speed=$(echo "$duration / 15.5" | bc -l)
                ffmpeg -y -i "audio/scene${scene}.mp3" -filter:a "atempo=$speed" "audio/scene${scene}_fitted.mp3" 2>/dev/null
                mv "audio/scene${scene}_fitted.mp3" "audio/scene${scene}.mp3"
            fi
            
            echo "   ✅ Scene $scene narration"
        fi
    ) &
    
    sleep 0.3
done
wait
echo "   ✅ All narrations complete"

# Generate all videos in parallel
echo ""
echo "🎥 Generating videos..."
for i in {0..23}; do
    scene=$((i + 1))
    visual="${visuals[$i]}"
    seed=$((SEED + i))
    
    (
        response=$(curl -s -X POST "$VIDEO_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$visual, no speech, ambient only\", \"duration\": 8, \"aspect_ratio\": \"16:9\", \"resolution\": \"1080p\", \"seed\": $seed, \"generate_audio\": true}")
        
        video_url=$(echo "$response" | jq -r '.video.url // empty')
        if [[ -n "$video_url" ]]; then
            curl -s -o "videos/scene${scene}.mp4" "$video_url"
            echo "   ✅ Scene $scene video"
        fi
    ) &
    
    sleep 2
done
wait
echo "   ✅ All videos complete"

# Generate all music in parallel
echo ""
echo "🎵 Generating music..."
for i in {0..23}; do
    scene=$((i + 1))
    music="${music_prompts[$i]}"
    
    (
        response=$(curl -s -X POST "$MUSIC_ENDPOINT" \
            -H "Authorization: Key $FAL_API_KEY" \
            -H "Content-Type: application/json" \
            -d "{\"prompt\": \"$music\", \"seconds_total\": 8, \"num_inference_steps\": 8, \"guidance_scale\": 7}")
        
        audio_url=$(echo "$response" | jq -r '.audio.url // empty')
        if [[ -n "$audio_url" ]]; then
            curl -s -o "music/scene${scene}.wav" "$audio_url"
            echo "   ✅ Scene $scene music"
        fi
    ) &
    
    sleep 1
done
wait
echo "   ✅ All music complete"

# Mix all scenes
echo ""
echo "🔊 Mixing scenes..."
for scene in {1..24}; do
    if [[ -f "videos/scene${scene}.mp4" && -f "audio/scene${scene}.mp3" && -f "music/scene${scene}.wav" ]]; then
        ffmpeg -y -i "videos/scene${scene}.mp4" \
                  -i "audio/scene${scene}.mp3" \
                  -i "music/scene${scene}.wav" \
            -filter_complex "[0:a]volume=0.175[ambient];[1:a]volume=1.3[narration];[2:a]volume=0.20[music];[ambient][narration][music]amix=inputs=3:duration=first:dropout_transition=0[audio]" \
            -map 0:v -map "[audio]" \
            -c:v copy -c:a aac -ac 1 -ar 44100 \
            "final/scene${scene}_mixed.mp4" 2>/dev/null
        echo "   ✅ Scene $scene mixed"
    fi
done

# Compile final documentary
echo ""
echo "📹 Compiling documentary..."
> scene_list.txt
for scene in {1..24}; do
    if [[ -f "final/scene${scene}_mixed.mp4" ]]; then
        echo "file 'final/scene${scene}_mixed.mp4'" >> scene_list.txt
    fi
done

ffmpeg -y -f concat -safe 0 -i scene_list.txt -c copy "THE_ARCHITECTS_OF_LIFE.mp4" 2>/dev/null

if [[ -f "THE_ARCHITECTS_OF_LIFE.mp4" ]]; then
    size=$(ls -lh "THE_ARCHITECTS_OF_LIFE.mp4" | awk '{print $5}')
    duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "THE_ARCHITECTS_OF_LIFE.mp4" | awk '{printf "%.1fs", $1}')
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✨ THE ARCHITECTS OF LIFE COMPLETE!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📱 File: THE_ARCHITECTS_OF_LIFE.mp4"
    echo "⏱️  Duration: $duration"
    echo "📏 Size: $size"
    echo "🧬 Narrator: Rachel (Cosmic Wonder)"
    echo "📊 Scenes: 24 × 8s = 3:12 total"
else
    echo "❌ Failed to create final documentary"
fi

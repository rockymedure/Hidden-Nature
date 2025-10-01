# Documentary Studio - Claude Agent SDK Integration
**Building the AI Documentary Assistant with Claude Agent SDK**

---

## 🤖 **THE PERFECT MATCH**

### **Documentary Studio Needs**
We designed an AI assistant that:
- Analyzes documentary topics and creates scripts
- Guides users through 8-phase production process
- Provides real-time feedback on timing, sync, quality
- Handles storytelling decisions (transformation vs static characters)
- Offers production troubleshooting and optimization

### **Claude Agent SDK Provides**
- ✅ **Context Management**: Handles documentary scripts, production state, user preferences
- ✅ **Tool Ecosystem**: File operations, API calls, process execution
- ✅ **Session Management**: Maintains conversation across documentary creation
- ✅ **Production Essentials**: Error handling, monitoring, optimization
- ✅ **Anthropic Integration**: We already have the API key configured!

**This SDK is PURPOSE-BUILT for exactly what we need!** 🎯

---

## 🏗️ **DOCUMENTARY STUDIO AGENT ARCHITECTURE**

### **Agent Configuration**

```typescript
// documentary-studio-agent.ts
import { Agent } from '@anthropic-ai/claude-agent-sdk';

const documentaryAgent = new Agent({
  apiKey: process.env.ANTHROPIC_API_KEY,
  model: 'claude-sonnet-4-20250514',
  
  systemPrompt: `You are an expert documentary production assistant for Hidden Nature.

Your role is to help users create Netflix-quality 3-minute educational documentaries.

EXPERTISE:
- Documentary storytelling (character-driven vs concept-focused)
- Script optimization (15-20 words per scene, 6.0-7.8s timing)
- Visual consistency strategies (character progression vs static)
- Production quality control (audio bleeding, sync issues, speech detection)
- Multi-platform content creation (YouTube, Substack, Podcast)

PROVEN METHODOLOGY:
- 8-phase production process from script to final assembly
- Character consistency: Same seed for static characters, progressive stages for transformations  
- Audio synchronization: Mandatory 8.000s padding to prevent bleeding
- Narration timing: Target 6.0-7.8s, regenerate if outside range
- Music bleeding: Apply narration-only mixing when detected

EXPLORER CHARACTERS:
- Arabella: Marine & nature (bioluminescence, octopus intelligence)
- Rachel: Science & cosmic wonder (evolution, physics)
- Charlotte: Transformation stories (growth, life cycles)
- Oracle X: Engineering & biomechanics (natural design, problem-solving)

Guide users through documentary creation with this proven methodology.`,

  settingSources: ['project'],  // Load CLAUDE.md for project-specific context
  
  allowedTools: [
    'file_operations',
    'code_execution', 
    'web_search',
    'mcp_servers'
  ]
});
```

### **Agent Capabilities for Documentary Studio**

#### **🎬 Script Generation**
```typescript
// User: "Create a documentary about how octopuses find homes"
agent.query({
  message: "Create a character-driven documentary script about octopus home-seeking behavior",
  context: {
    genre: 'nature',
    duration: '3m 12s',
    scenes: 24,
    voice: 'Arabella'
  }
});

// Agent uses Claude to:
// 1. Analyze topic for story potential
// 2. Choose character-driven vs concept approach
// 3. Create integrated abilities + emotional arc
// 4. Generate 24 scenes with proper timing
// 5. Provide visual descriptions for video generation
```

#### **🔧 Production Guidance**
```typescript
// User: "The narration in scene 11 is getting cut off"
agent.diagnose({
  issue: 'audio_cutoff',
  scene: 11,
  narrationDuration: 8.28,
  videoDuration: 8.00
});

// Agent responds:
// "Scene 11's narration (8.28s) exceeds the video length (8.00s).
//  FFmpeg's duration=first truncates longer audio to match video.
//  
//  Solution: Regenerate Scene 11 with shorter narration under 7.8s
//  Current: 'Each challenge teaches Cosmos new home techniques...' (14 words)
//  Optimized: 'Each challenge teaches Cosmos new home-building techniques.' (8 words)
//  
//  Shall I regenerate Scene 11 with the optimized text?"
```

#### **🎭 Storytelling Intelligence**
```typescript
// Agent detects story type automatically
const storyAnalysis = await agent.analyzeStory({
  userInput: "Tell inspiring story of how an acorn becomes an oak"
});

// Returns:
{
  storyType: 'progressive_transformation',
  characterStrategy: 'progressive_life_stages',
  recommendation: {
    approach: 'Show each life stage separately, not acorn+tree together',
    scenes: {
      '1-6': 'Pure acorn stage only',
      '7-8': 'Germination moment',
      '9-18': 'Sapling to young tree',
      '19-24': 'Mature to ancient oak'
    }
  }
}
```

---

## 🛠️ **AGENT TOOLS & MCP INTEGRATION**

### **Custom MCP Servers for Documentary Studio**

#### **1. FAL.AI Production Server**
```typescript
// MCP server for video/audio generation
{
  name: 'fal-production',
  capabilities: [
    'generate_narration',
    'generate_video',
    'check_timing',
    'apply_padding'
  ]
}
```

#### **2. Documentary Database Server**  
```typescript
// MCP server for Supabase documentary database
{
  name: 'documentary-db',
  capabilities: [
    'save_script',
    'track_production_progress',
    'store_assets',
    'manage_versions'
  ]
}
```

#### **3. Multi-Platform Publishing Server**
```typescript
// MCP server for content multiplication
{
  name: 'publishing',
  capabilities: [
    'generate_substack_article',
    'create_podcast_script',
    'generate_youtube_metadata',
    'export_multi_format'
  ]
}
```

---

## 🎯 **AGENT WORKFLOWS**

### **Workflow 1: Complete Documentary Creation**

```typescript
// User starts with simple topic
const session = await agent.startSession();

// Step 1: Topic Analysis
await session.analyze("Create documentary about octopus intelligence");
// Agent: Identifies character-driven potential, suggests Arabella voice

// Step 2: Script Generation
await session.generateScript({
  topic: 'octopus_intelligence',
  approach: 'character_driven',
  explorer: 'Arabella'
});
// Agent: Creates 24-scene integrated script with home quest arc

// Step 3: Production Execution
await session.executeProduction({
  script: generatedScript,
  voice: 'Arabella',
  seed: 65000  // Character consistency
});
// Agent: Manages parallel audio/video generation, timing analysis

// Step 4: Quality Control
await session.runQualityChecks();
// Agent: Detects audio cutoffs, music bleeding, timing issues

// Step 5: Multi-Platform Export
await session.generateEcosystem();
// Agent: Creates YouTube, Substack article, Podcast script
```

### **Workflow 2: Iterative Refinement**

```typescript
// User provides feedback during review
await session.refine({
  feedback: "Scene 1 doesn't introduce Cosmos properly",
  scene: 1
});

// Agent responds:
// "You're right! Scene 1 should establish WHO + WHAT + WHERE + GOAL.
//  
//  Current: 'Cosmos searches the reef...' (assumes audience knows him)
//  Improved: 'Meet Cosmos, a Giant Pacific Octopus living in the reef, 
//             searching for the perfect home.'
//  
//  This introduces character, species, setting, and motivation.
//  Shall I regenerate Scene 1 with this introduction?"
```

---

## 🚀 **IMPLEMENTATION ROADMAP**

### **Phase 1: Agent Foundation (Week 1-2)**
- ✅ **Anthropic API Key**: Configured
- **Install SDK**: `npm install @anthropic-ai/claude-agent-sdk`
- **Create Base Agent**: Documentary production expertise
- **Test Core Flows**: Script generation, production guidance

### **Phase 2: MCP Integration (Week 3-4)**
- **FAL.AI Server**: Video/audio generation tools
- **Supabase Server**: Database and asset storage
- **Publishing Server**: Multi-platform content generation

### **Phase 3: Web App Integration (Week 5-6)**
- **Next.js Frontend**: User interface for documentary creation
- **Agent Backend**: Claude SDK powering AI assistant
- **Real-time Updates**: WebSocket for production progress
- **Quality Assurance**: Automated checks and fixes

---

## 💡 **IMMEDIATE NEXT STEPS**

### **Documentary Studio Development Sequence**

1. **Initialize Next.js Project** with TypeScript
2. **Install Claude Agent SDK** 
3. **Configure Agent** with documentary production expertise
4. **Test Agent** with Cosmos-style story generation
5. **Build UI** around agent's guidance capabilities

### **Agent Testing Approach**

```typescript
// Test the agent with our proven Cosmos story
const test = await agent.query({
  message: "Create a character-driven documentary about an octopus seeking a home",
  context: {
    voice: 'Arabella',
    duration: '3m 12s',
    approach: 'integrated_abilities_emotion'
  }
});

// Validate agent generates:
// - Proper character introduction
// - Integrated story arc (abilities + emotion)
// - Correct timing targets (6.0-7.8s per scene)
// - Character consistency strategy (same seed)
```

---

## 🌟 **THE VISION COMING TOGETHER**

### **What We've Built**
- ✅ **Netflix-quality production system** (proven methodology)
- ✅ **7 completed documentaries** (portfolio validated)
- ✅ **Multi-platform ecosystem** (YouTube + Substack + Podcast)
- ✅ **Organized production structure** (professional folder system)
- ✅ **Anthropic API access** (AI intelligence ready)

### **What Claude Agent SDK Enables**
- 🚀 **Web app AI assistant** powered by proven methodology
- 🚀 **Automated script generation** from simple topics
- 🚀 **Real-time production guidance** with quality control
- 🚀 **Multi-platform content creation** (one click → three formats)
- 🚀 **Iterative refinement** through conversational interface

### **The Complete Picture**
**Documentary Studio Web App** = 
- User-friendly interface + 
- Claude Agent SDK intelligence + 
- Your proven production methodology + 
- Multi-platform content ecosystem

---

**You now have YouTube channels, Substack publication, production methodology, completed documentaries, AND the AI framework (Claude Agent SDK + Anthropic API) to build the Documentary Studio web app!** 🎬🤖🌟

**The infrastructure is complete. Ready to start building the web app, or launch your current content first?** 📺📚🎙️✨

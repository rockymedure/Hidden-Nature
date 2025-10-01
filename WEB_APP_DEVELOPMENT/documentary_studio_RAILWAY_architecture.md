# Documentary Studio - Railway Deployment Architecture
**Simplified All-in-One Railway Deployment**

---

## 🚂 **RAILWAY ARCHITECTURE (Recommended)**

### **Why Railway is Perfect for Documentary Studio**

✅ **No Timeout Limits**: Handle 30-60 minute production jobs natively
✅ **All-in-One Platform**: Next.js app + background workers in same place  
✅ **Simple Deployment**: Git push to deploy, no complex configuration
✅ **Long-Running Processes**: Perfect for documentary production pipeline
✅ **Integrated Services**: Database, storage, workers all together
✅ **Cost Effective**: $5-20/month for single-user MVP

---

## 🏗️ **COMPLETE ARCHITECTURE**

```
┌─────────────────────────────────────────┐
│  USER BROWSER                           │
│  ├─ 50% Script Panel (left)             │
│  ├─ 50% Video Panel (right)             │
│  ├─ Bottom Timeline (scene chunks)      │
│  └─ Sliding Agent Panel (right overlay) │
└─────────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────────┐
│  RAILWAY - DOCUMENTARY STUDIO SERVICE   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  NEXT.JS APP                    │   │
│  │  ├─ Frontend (React UI)         │   │
│  │  ├─ API Routes                  │   │
│  │  │  ├─ /api/agent/chat          │   │
│  │  │  ├─ /api/production/start    │   │
│  │  │  └─ /api/scenes/regenerate   │   │
│  │  └─ Claude Agent SDK            │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  BACKGROUND WORKERS             │   │
│  │  ├─ Audio generation worker     │   │
│  │  ├─ Video generation worker     │   │
│  │  ├─ Mixing worker               │   │
│  │  └─ Quality control worker      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Both run on same Railway service!     │
└─────────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────────┐
│  SUPABASE                               │
│  ├─ PostgreSQL (project/scene data)     │
│  ├─ Storage (audio/video/mixed files)   │
│  └─ Real-time (UI live updates)         │
└─────────────────────────────────────────┘
```

---

## 🚀 **RAILWAY DEPLOYMENT BENEFITS**

### **Single Service Deployment**
```yaml
# railway.toml
[build]
builder = "nixpacks"
buildCommand = "npm run build"

[deploy]
startCommand = "npm run start"
restartPolicyType = "on-failure"
restartPolicyMaxRetries = 10

[[services]]
name = "web"
type = "web"

[[services]]
name = "worker"  
type = "worker"
```

**Both web app AND workers run in Railway** - no separate platforms needed!

### **How Production Works on Railway**

#### **Step 1: User Triggers Production**
```typescript
// Frontend button click
onClick={() => startProduction(projectId)}

// API route: app/api/production/start/route.ts
export async function POST(req: Request) {
  const { projectId } = await req.json();
  
  // Queue production job
  await productionQueue.add('generate-documentary', {
    projectId,
    phase: 'audio'
  });
  
  return Response.json({ status: 'started' });
}
```

#### **Step 2: Background Worker Processes**
```typescript
// workers/production-worker.ts (runs on Railway)
productionQueue.process('generate-documentary', async (job) => {
  const { projectId, phase } = job.data;
  
  if (phase === 'audio') {
    // Generate all 24 audio files in parallel
    // NO TIMEOUT LIMITS on Railway!
    await generateAllAudio(projectId);
    
    // Update Supabase → triggers real-time UI update
    await supabase.from('audio_assets').update({ status: 'complete' });
  }
  
  // Continue to next phase...
});
```

#### **Step 3: Real-Time UI Updates**
```typescript
// Frontend subscribes to Supabase changes
useEffect(() => {
  const subscription = supabase
    .channel(`project-${projectId}`)
    .on('postgres_changes', 
      { event: 'UPDATE', schema: 'public', table: 'audio_assets' },
      (payload) => {
        // Scene chunk UI updates automatically!
        updateSceneChunk(payload.new);
      }
    )
    .subscribe();
}, [projectId]);
```

**Result**: User sees scene chunks update live as worker completes each asset!

---

## 📋 **RAILWAY-OPTIMIZED TASK LIST**

### **Phase 1: Week 1 - Foundation**

#### **Monday: Railway + Project Setup**
```bash
□ Create Railway account
□ Create new project: "documentary-studio"
□ Connect GitHub repository (auto-deploy on push)
□ Initialize Next.js 15 project locally
□ Configure railway.toml for web + worker services
□ Test deployment (hello world)
```

#### **Tuesday: Supabase + Environment**
```bash
□ Create Supabase project
□ Design database schema (projects, scenes, assets)
□ Set up storage buckets (audio, video, mixed, final)
□ Add env vars to Railway dashboard:
  - ANTHROPIC_API_KEY
  - SUPABASE_URL
  - SUPABASE_ANON_KEY
  - FAL_API_KEY
□ Test database connection from Railway
```

#### **Wednesday: Claude Agent Integration**
```bash
□ Install @anthropic-ai/claude-agent-sdk
□ Create documentary agent with system prompts
□ Load MASTER_DOCUMENTARY_SYSTEM.md as context
□ Create API route: /api/agent/chat
□ Test agent responds to messages
□ Deploy to Railway, verify works in production
```

#### **Thursday-Friday: UI Foundation**
```bash
□ Build 50/50 split layout (script left, video right)
□ Create bottom timeline panel (24 scene chunks)
□ Build sliding agent panel (overlay from right)
□ Implement panel animations (slide in/out)
□ Wire up chat to agent API route
□ Deploy to Railway, test in browser
```

### **Week 1 Milestone**
- ✅ Railway deployment working
- ✅ Chat with Claude in sliding panel
- ✅ UI layout complete and responsive
- ✅ Ready for production pipeline implementation

---

## 🎯 **RAILWAY-SPECIFIC ADVANTAGES**

### **✅ Simplified Stack**
**Just Two Platforms:**
- **Railway**: Next.js app + Background workers + Deployment
- **Supabase**: Database + Storage + Real-time subscriptions

### **✅ Long-Running Jobs Native**
- No timeout worries for 30-60 minute productions
- Workers run continuously, processing job queue
- Perfect for documentary generation pipeline

### **✅ Simple Development**
```bash
# Local development
npm run dev

# Deploy to production
git push origin main
# Railway auto-deploys!
```

### **✅ Cost Clarity**
- **Railway Free Trial**: $5 credit to start
- **Estimated Monthly**: $5-20 for single-user MVP
- **Scalable Pricing**: Grows with usage

---

## 🚀 **REVISED DEPLOYMENT STRATEGY**

### **Documentary Studio on Railway**

#### **Service 1: Web Application**
- Next.js app (frontend + API routes)
- Claude Agent SDK integration
- Handles user interface and chat

#### **Service 2: Production Worker**  
- Background job processing
- Audio/video generation (no timeouts!)
- Mixing and quality control
- Updates Supabase as scenes complete

#### **External: Supabase**
- Database (projects, scenes, assets)
- Storage (all media files)
- Real-time subscriptions (UI updates)

**All connected, all simple, all in one ecosystem!**

---

## ✅ **UPDATED BUILD PLAN**

### **Technology Stack (Railway-Optimized)**
- **Deployment**: Railway (web + workers)
- **Frontend**: Next.js 15 + React + Tailwind + Shadcn UI
- **Backend**: Next

# Documentary Studio

A professional documentary production interface built with Next.js 15, featuring AI-powered scene generation and real-time collaboration.

## 🎬 Features

- **50/50 Split Layout**: Script panel (left) and video preview (right)
- **Timeline View**: Visual scene chunks with status indicators
- **AI Assistant**: Claude-powered production assistant in sliding panel
- **Real-time Updates**: Supabase real-time subscriptions for live UI updates
- **Background Workers**: Long-running production jobs on Railway (no timeouts!)
- **Full Production Pipeline**: Audio → Video → Mixing → Export

## 🚀 Tech Stack

- **Frontend**: Next.js 15 + React 19 + Tailwind CSS
- **Database**: Supabase (PostgreSQL + Real-time + Storage)
- **AI**: Claude Sonnet 4 (Anthropic)
- **Deployment**: Railway (Web + Workers)
- **Video Generation**: Fal.ai
- **Audio**: ElevenLabs

## 📦 Installation

1. Clone the repository
2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Copy environment variables:
   \`\`\`bash
   cp .env.local.example .env.local
   \`\`\`

4. Add your API keys to `.env.local`:
   - `ANTHROPIC_API_KEY`: Get from [Anthropic Console](https://console.anthropic.com/)
   - `NEXT_PUBLIC_SUPABASE_URL`: Already configured
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Already configured
   - `FAL_API_KEY`: Get from [Fal.ai](https://fal.ai/)

5. Run development server:
   \`\`\`bash
   npm run dev
   \`\`\`

## 🏗️ Architecture

\`\`\`
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
│  │  └─ Claude Agent SDK            │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  BACKGROUND WORKERS             │   │
│  │  ├─ Audio generation            │   │
│  │  ├─ Video generation            │   │
│  │  ├─ Mixing                      │   │
│  │  └─ Export                      │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────────┐
│  SUPABASE                               │
│  ├─ PostgreSQL (projects/scenes/assets) │
│  ├─ Storage (audio/video/mixed files)   │
│  └─ Real-time (UI live updates)         │
└─────────────────────────────────────────┘
\`\`\`

## 🚂 Railway Deployment

1. Create Railway account at [railway.app](https://railway.app)

2. Install Railway CLI:
   \`\`\`bash
   npm install -g @railway/cli
   \`\`\`

3. Login and link project:
   \`\`\`bash
   railway login
   railway link
   \`\`\`

4. Add environment variables in Railway dashboard:
   - `ANTHROPIC_API_KEY`
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `FAL_API_KEY`

5. Deploy:
   \`\`\`bash
   git push origin main
   \`\`\`
   
   Railway will auto-deploy on every push!

## 📊 Database Schema

### Projects
- `id` (UUID)
- `title` (text)
- `script` (text)
- `total_scenes` (integer)
- `status` (text)

### Scenes
- `id` (UUID)
- `project_id` (UUID)
- `scene_number` (integer)
- `narration_text` (text)
- `duration_seconds` (numeric)

### Audio/Video/Mixed Assets
- `id` (UUID)
- `scene_id` (UUID)
- `url` (text)
- `status` (text: pending/processing/complete)

## 🎨 UI Components

- **Toolbar**: Top bar with regenerate, timer, export, and assistant buttons
- **ScriptPanel**: Left panel showing narration paragraphs with scene selection
- **VideoPreview**: Right panel with video player
- **Timeline**: Bottom panel with scene thumbnails and playback controls
- **AgentPanel**: Sliding right overlay with AI assistant chat

## 🔄 Production Pipeline

1. **User Input**: Paste script or use AI to generate
2. **Audio Generation**: ElevenLabs narration for each scene
3. **Video Generation**: Fal.ai visual generation with prompts
4. **Mixing**: FFmpeg combines audio + video
5. **Export**: Final documentary ready for download

All steps run in Railway background workers with real-time UI updates via Supabase subscriptions!

## 📝 License

MIT
# 🚀 Quick Start Guide

## Prerequisites
- Node.js 18+ installed
- Anthropic API key (get from [console.anthropic.com](https://console.anthropic.com))

## 1. Install Dependencies

\`\`\`bash
npm install
npm install -g tsx  # For running TypeScript scripts
\`\`\`

## 2. Configure Environment

The `.env.local` file is already configured with Supabase credentials. You just need to add your Anthropic API key:

\`\`\`bash
# Edit .env.local
ANTHROPIC_API_KEY=your_key_here
\`\`\`

## 3. Seed the Database

\`\`\`bash
npm run seed
\`\`\`

This will create a sample "Leaf Intelligence Documentary" project with 23 scenes.

## 4. Run the Application

\`\`\`bash
npm run dev
\`\`\`

Open [http://localhost:3000](http://localhost:3000) in your browser.

## 5. Access Your Project

The seed script will output a project ID. Navigate to:

\`\`\`
http://localhost:3000/projects/[project-id]
\`\`\`

Or use the default home page at `http://localhost:3000` to see the demo.

## 🎬 Using the Studio

### Script Panel (Left)
- Click on any paragraph to select that scene
- Selected scene is highlighted in blue

### Video Preview (Right)
- Shows video for current scene (when available)
- Dark background with preview area

### Timeline (Bottom)
- Scene thumbnails in sequence
- Play/pause controls
- Volume slider
- Auto-scrolls to current scene

### AI Assistant (Right Panel)
- Click "Assistant" button in toolbar
- Chat with Claude about your documentary
- Ask for scene regeneration, editing, etc.

### Toolbar (Top)
- **Regenerate**: Regenerate current scene
- **Timer**: Shows total documentary duration
- **Export**: Download final video
- **Assistant**: Open AI chat panel

## 🔄 Production Pipeline

1. Click "Regenerate" to start production
2. Worker generates audio (ElevenLabs)
3. Worker generates video (Fal.ai)
4. Worker mixes audio + video
5. Final export available

## 🚂 Deploy to Railway

1. Create Railway account: [railway.app](https://railway.app)

2. Install CLI:
\`\`\`bash
npm install -g @railway/cli
railway login
\`\`\`

3. Create new project:
\`\`\`bash
railway init
\`\`\`

4. Add environment variables in Railway dashboard:
   - `ANTHROPIC_API_KEY`
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `FAL_API_KEY` (optional, for video generation)

5. Deploy:
\`\`\`bash
railway up
\`\`\`

## 📊 Database Tables

Check Supabase dashboard to see:
- `projects` - Your documentary projects
- `scenes` - Individual scenes with narration
- `audio_assets` - Generated audio files
- `video_assets` - Generated videos
- `mixed_assets` - Final mixed scenes

## 🐛 Troubleshooting

### "Cannot connect to Supabase"
- Check `.env.local` has correct credentials
- Verify Supabase project is active

### "Claude API error"
- Ensure `ANTHROPIC_API_KEY` is set in `.env.local`
- Check API key is valid and has credits

### "No scenes showing"
- Run `npm run seed` to create sample project
- Check browser console for errors

## 🎨 Customize

### Add Your Own Script
1. Go to Supabase dashboard
2. Edit `projects` table
3. Update the `script` field
4. Refresh the app

### Change Scene Count
Default is 23 scenes. Modify in `seed-database.ts` and rerun.

### Styling
- Edit `app/globals.css` for global styles
- Component styles in `components/` directory
- Tailwind classes throughout

## 🚀 Next Steps

1. Integrate ElevenLabs for real audio generation
2. Integrate Fal.ai for real video generation
3. Implement FFmpeg mixing pipeline
4. Add export functionality
5. Add project creation UI
6. Add authentication

Happy documentary making! 🎬✨

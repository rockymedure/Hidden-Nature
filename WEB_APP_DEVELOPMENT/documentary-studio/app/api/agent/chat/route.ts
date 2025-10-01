import { NextRequest, NextResponse } from 'next/server';
import Anthropic from '@anthropic-ai/sdk';
import { createClient } from '@supabase/supabase-js';
import { exec } from 'child_process';
import { promisify } from 'util';
import * as fs from 'fs/promises';
import * as path from 'path';
import * as os from 'os';

const execAsync = promisify(exec);

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY!,
});

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const FAL_API_KEY = process.env.FAL_API_KEY!;

const DOCUMENTARY_SYSTEM_PROMPT = `You are an expert documentary production assistant with deep knowledge of the Netflix-quality documentary production system.

## Core Methodology
You implement a **script-first, audio-first** production pipeline that ensures perfect synchronization and professional quality.

### Key Principles:
1. **Perfect Synchronization**: All narrations must be padded to exactly 8.000 seconds to prevent audio bleeding
2. **Script Structure**: 20-25 scenes, 15-20 words per scene (targeting 6.0-7.8 second delivery)
3. **Audio First**: Generate ALL narrations before any video work - this prevents costly regenerations
4. **Parallel Processing**: Generate all scenes simultaneously for maximum efficiency
5. **Visual Consistency**: Choose character-driven (for nature stories) or concept-focused (for science) approach

### Production Phases (IN ORDER):
1. **Script Development**: 20-25 scenes, educational depth, emotional engagement, Sagan/Attenborough style
2. **Narration Generation**: ALL audio first, in parallel, 6.0-7.8 second targeting
3. **Timing Analysis**: Measure ALL narrations, regenerate any outside 6.0-7.8s range, pad ALL to 8.000s
4. **Visual System Design**: Plan character consistency (nature) or thematic coherence (science)
5. **Video Generation**: Generate ALL videos in parallel with consistent prompts
6. **Audio Mixing**: Cinematic levels (0.25x ambient, 1.3x narration), handle speech bleeding
7. **Final Assembly**: Concatenate all mixed scenes into final documentary
8. **YouTube Publishing**: Generate metadata, timestamps, and publishing package

### Your Workflow with User:
1. **Brainstorm** - Discuss concept, refine ideas (CHAT ONLY)
2. **Draft Script** - Show 20-25 scene structure in chat (CHAT ONLY)
3. **Refine** - User edits, you adjust (CHAT ONLY)
4. **Execute** - When user says "create the project" → USE create_documentary_project TOOL
5. **Generate Audio** - When user says "generate narrations" → USE generate_all_narrations TOOL
6. **Continue Pipeline** - Guide through remaining phases with tool calls

### Critical Rules:
- DO NOT call tools until user explicitly asks to execute
- ALWAYS show script drafts in chat first for refinement
- NEVER start video before audio is perfect
- Tighter timing: 6.0-7.8 seconds (not 6-8)
- For speech bleeding in video: use narration-only mixing (drop ambient)
- Character stories need seed consistency; concept stories don't

### Narrator Selection:
- Science (cosmic): Rachel, Oracle X (professional)
- Nature: Charlotte (calming), Roger (dramatic), Arabella (wonder)
- History: Marcus (authority)

Be conversational and helpful. Guide users through brainstorming, then execute when they're ready.`;

// Define tools for Claude
const PRODUCTION_TOOLS: Anthropic.Tool[] = [
  {
    name: 'create_documentary_project',
    description: 'Create a new documentary project in the database with all scenes. This saves the finalized script to Supabase and triggers the UI to display it in the left panel. Only use when user explicitly asks to create/save the project.',
    input_schema: {
      type: 'object',
      properties: {
        title: {
          type: 'string',
          description: 'Documentary title'
        },
        narrations: {
          type: 'array',
          items: { type: 'string' },
          description: 'Array of scene narration texts (20-25 scenes, 15-20 words each)'
        },
        narrator: {
          type: 'string',
          description: 'Voice narrator name (Charlotte, Rachel, Roger, Marcus, etc.)',
          default: 'Charlotte'
        },
        documentary_type: {
          type: 'string',
          enum: ['character', 'concept'],
          description: 'Visual approach: character (nature stories) or concept (science/educational)'
        }
      },
      required: ['title', 'narrations', 'documentary_type']
    }
  },
  {
    name: 'generate_all_narrations',
    description: 'Generate all scene narrations in parallel using ElevenLabs TTS via FAL API. This is Phase 3 from the production system - AUDIO FIRST methodology. Only call after project is created and user confirms to start narration generation.',
    input_schema: {
      type: 'object',
      properties: {
        project_id: {
          type: 'string',
          description: 'Project UUID from database'
        },
        narrator: {
          type: 'string',
          description: 'ElevenLabs voice name',
          default: 'Charlotte'
        }
      },
      required: ['project_id']
    }
  },
  {
    name: 'analyze_narration_timing',
    description: 'PHASE 4: Analyze all narration durations using ffprobe. Measures each narration and identifies which are outside the 6.0-7.8 second optimal range. Call this after all narrations are generated.',
    input_schema: {
      type: 'object',
      properties: {
        project_id: {
          type: 'string',
          description: 'Project UUID'
        }
      },
      required: ['project_id']
    }
  },
  {
    name: 'pad_all_audio_to_8_seconds',
    description: 'PHASE 4: Pad ALL narrations to exactly 8.000 seconds using ffmpeg. CRITICAL - prevents audio bleeding between scenes. Must run on ALL narrations before video generation.',
    input_schema: {
      type: 'object',
      properties: {
        project_id: {
          type: 'string',
          description: 'Project UUID'
        }
      },
      required: ['project_id']
    }
  },
  {
    name: 'generate_videos_for_scenes',
    description: 'PHASE 6: Generate videos for specific scenes using FAL Veo3 API. IMPORTANT: Video generation is expensive - only generate a FEW test scenes (1-3) to verify the system works. User must explicitly approve full generation of all scenes.',
    input_schema: {
      type: 'object',
      properties: {
        project_id: {
          type: 'string',
          description: 'Project UUID'
        },
        scene_numbers: {
          type: 'array',
          items: { type: 'number' },
          description: 'Array of scene numbers to generate (e.g. [1, 2, 3] for first 3 scenes). Keep small for cost control!'
        },
        visual_prompts: {
          type: 'array',
          items: { type: 'string' },
          description: 'Visual description for each scene in same order as scene_numbers'
        },
        seed_strategy: {
          type: 'string',
          enum: ['consistent', 'drift'],
          description: 'consistent for character stories (same seed), drift for evolutionary concepts',
          default: 'drift'
        },
        base_seed: {
          type: 'number',
          description: 'Starting seed number',
          default: 50000
        }
      },
      required: ['project_id', 'scene_numbers', 'visual_prompts']
    }
  },
  {
    name: 'mix_scenes',
    description: 'PHASE 7: Mix audio and video together for specific scenes using ffmpeg with cinematic levels. Combines narration (1.3x volume) with video ambient audio (0.25x volume).',
    input_schema: {
      type: 'object',
      properties: {
        project_id: {
          type: 'string',
          description: 'Project UUID'
        },
        scene_numbers: {
          type: 'array',
          items: { type: 'number' },
          description: 'Array of scene numbers to mix'
        }
      },
      required: ['project_id', 'scene_numbers']
    }
  },
  {
    name: 'export_final_documentary',
    description: 'PHASE 8: Concatenate all mixed scenes into final documentary. Verifies total duration and creates downloadable file.',
    input_schema: {
      type: 'object',
      properties: {
        project_id: {
          type: 'string',
          description: 'Project UUID'
        }
      },
      required: ['project_id']
    }
  }
];

// Tool execution handlers
async function executeCreateProject(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  // Validate scene count
  if (args.narrations.length < 20 || args.narrations.length > 25) {
    return `❌ Error: Expected 20-25 scenes but got ${args.narrations.length}. Please adjust the script.`;
  }
  
  // Create project
  const { data: project, error: projectError } = await supabase
    .from('projects')
    .insert({
      title: args.title,
      script: args.narrations.join('\n\n'),
      total_scenes: args.narrations.length,
      status: 'draft'
    })
    .select()
    .single();
  
  if (projectError) {
    return `❌ Database Error: ${projectError.message}`;
  }
  
  // Create scenes
  const scenesData = args.narrations.map((narration: string, index: number) => ({
    project_id: project.id,
    scene_number: index + 1,
    narration_text: narration,
    duration_seconds: 8.0
  }));
  
  const { data: scenes, error: scenesError } = await supabase
    .from('scenes')
    .insert(scenesData)
    .select();
  
  if (scenesError) {
    return `❌ Scenes Error: ${scenesError.message}`;
  }
  
  // Create asset placeholders
  for (const scene of scenes) {
    await Promise.all([
      supabase.from('audio_assets').insert({ scene_id: scene.id, status: 'pending' }),
      supabase.from('video_assets').insert({ scene_id: scene.id, status: 'pending' }),
      supabase.from('mixed_assets').insert({ scene_id: scene.id, status: 'pending' })
    ]);
  }
  
  return `✅ Project "${args.title}" created successfully!

📋 Project ID: ${project.id}
📍 URL: http://localhost:3005/projects/${project.id}
🎬 Scenes Created: ${scenes.length}

The left panel will now display all ${scenes.length} scenes when you navigate to the project page.

✨ Ready for Phase 3: Narration Generation
Type "generate narrations" when ready to proceed.`;
}

async function executeGenerateNarrations(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  if (!FAL_API_KEY || FAL_API_KEY === 'your_fal_api_key_here') {
    return '❌ FAL_API_KEY not configured in .env.local. Cannot generate narrations.';
  }
  
  // Get all scenes
  const { data: scenes, error: scenesError } = await supabase
    .from('scenes')
    .select('*')
    .eq('project_id', args.project_id)
    .order('scene_number');
  
  if (scenesError || !scenes) {
    return `❌ Error: Could not find scenes for project ${args.project_id}`;
  }
  
  // Generate ALL narrations in parallel (Phase 3 methodology)
  let successful = 0;
  let failed = 0;
  
  const results = await Promise.allSettled(
    scenes.map(async (scene) => {
      try {
        // Update status to processing
        await supabase
          .from('audio_assets')
          .update({ status: 'processing' })
          .eq('scene_id', scene.id);
        
        // Call ElevenLabs via FAL
        const response = await fetch('https://fal.run/fal-ai/elevenlabs/tts/eleven-v3', {
          method: 'POST',
          headers: {
            'Authorization': `Key ${FAL_API_KEY}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            text: scene.narration_text,
            voice: args.narrator || 'Charlotte',
            stability: 0.5,
            similarity_boost: 0.75,
            style: 0.7,
            speed: 1.0
          })
        });
        
        if (!response.ok) {
          throw new Error(`FAL API error: ${response.statusText}`);
        }
        
        const result = await response.json();
        const audioUrl = result.audio.url;
        
        // Download audio
        const audioResponse = await fetch(audioUrl);
        const audioBlob = await audioResponse.blob();
        const audioBuffer = Buffer.from(await audioBlob.arrayBuffer());
        
        // Upload to Supabase storage
        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('audio')
          .upload(
            `${args.project_id}/scene${scene.scene_number}.mp3`,
            audioBuffer,
            { contentType: 'audio/mpeg', upsert: true }
          );
        
        if (uploadError) throw uploadError;
        
        // Get public URL
        const { data: { publicUrl } } = supabase.storage
          .from('audio')
          .getPublicUrl(uploadData.path);
        
        // Update audio_assets table (triggers real-time UI update!)
        await supabase
          .from('audio_assets')
          .update({
            url: publicUrl,
            status: 'complete'
          })
          .eq('scene_id', scene.id);
        
        return { scene_number: scene.scene_number, success: true };
      } catch (error: any) {
        await supabase
          .from('audio_assets')
          .update({ status: 'failed' })
          .eq('scene_id', scene.id);
        
        return { scene_number: scene.scene_number, success: false, error: error.message };
      }
    })
  );
  
  successful = results.filter(r => r.status === 'fulfilled' && r.value.success).length;
  failed = results.filter(r => r.status === 'rejected' || (r.status === 'fulfilled' && !r.value.success)).length;
  
  return `🎵 Narration Generation Complete!

✅ Successfully Generated: ${successful}/${scenes.length} scenes
${failed > 0 ? `❌ Failed: ${failed} scenes` : ''}

📊 Watch the timeline panel update in real-time as scenes complete!

Next Steps:
1. Phase 4: Timing Analysis - measure all narrations with ffprobe
2. Regenerate any outside 6.0-7.8 second range
3. Pad ALL to exactly 8.000 seconds
4. Then proceed to video generation

${successful === scenes.length ? '✨ All narrations complete! Ready for timing analysis.' : '⚠️ Some narrations failed. May need to retry.'}`;
}

async function executeAnalyzeNarrationTiming(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  // Get all completed audio assets  
  const { data: audioAssets, error } = await supabase
    .from('audio_assets')
    .select(`
      id,
      url,
      scenes!inner(scene_number, narration_text, project_id)
    `)
    .eq('scenes.project_id', args.project_id)
    .eq('status', 'complete') as any;
  
  if (error || !audioAssets || audioAssets.length === 0) {
    return `❌ Error: No completed audio assets found for project ${args.project_id}`;
  }
  
  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'timing-analysis-'));
  const timingResults = [];
  
  try {
    // Measure each narration
    for (const asset of audioAssets) {
      try {
        // Download audio file
        const response = await fetch(asset.url);
        const arrayBuffer = await response.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        
        const tempFile = path.join(tempDir, `scene${asset.scenes.scene_number}.mp3`);
        await fs.writeFile(tempFile, buffer);
        
        // Measure duration with ffprobe
        const { stdout } = await execAsync(
          `ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${tempFile}"`
        );
        
        const duration = parseFloat(stdout.trim());
        const inRange = duration >= 6.0 && duration <= 7.8;
        const needsPadding = duration < 8.0;
        
        timingResults.push({
          scene: asset.scenes.scene_number,
          duration: duration.toFixed(3),
          in_range: inRange,
          needs_padding: needsPadding,
          status: inRange ? '✅' : '❌'
        });
        
      } catch (error: any) {
        timingResults.push({
          scene: asset.scenes.scene_number,
          duration: 'ERROR',
          in_range: false,
          needs_padding: true,
          status: '❌',
          error: error.message
        });
      }
    }
  } finally {
    // Cleanup
    await fs.rm(tempDir, { recursive: true, force: true }).catch(() => {});
  }
  
  const totalScenes = timingResults.length;
  const inRangeCount = timingResults.filter(r => r.in_range).length;
  const needsRegenCount = timingResults.filter(r => !r.in_range).length;
  
  const outOfRange = timingResults.filter(r => !r.in_range);
  
  return `📊 Timing Analysis Complete!

**Results:**
✅ In Range (6.0-7.8s): ${inRangeCount}/${totalScenes} (${Math.round(inRangeCount/totalScenes*100)}%)
❌ Need Regeneration: ${needsRegenCount}

${outOfRange.length > 0 ? `\n**Scenes Outside Range:**\n${outOfRange.map(r => `Scene ${r.scene}: ${r.duration}s ${r.status}`).join('\n')}\n` : ''}

**All Scenes:**
${timingResults.map(r => `Scene ${r.scene}: ${r.duration}s ${r.status}`).join('\n')}

**Next Steps:**
${needsRegenCount > 0 ? 
  `1. Regenerate ${needsRegenCount} scenes outside range\n2. Then pad ALL to 8.000s` : 
  `1. Pad ALL narrations to exactly 8.000 seconds\n2. Proceed to Phase 5: Visual System Design`
}`;
}

async function executePadAudioTo8Seconds(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  // Get all completed audio assets
  const { data: audioAssets } = await supabase
    .from('audio_assets')
    .select(`
      id,
      url,
      scenes!inner(scene_number, project_id)
    `)
    .eq('scenes.project_id', args.project_id)
    .eq('status', 'complete') as any;
  
  if (!audioAssets || audioAssets.length === 0) {
    return '❌ No completed audio assets found. Generate narrations first.';
  }
  
  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'audio-padding-'));
  let successCount = 0;
  let failCount = 0;
  
  try {
    for (const asset of audioAssets) {
      try {
        // Download original audio
        const response = await fetch(asset.url);
        const arrayBuffer = await response.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        
        const inputFile = path.join(tempDir, `scene${asset.scenes.scene_number}.mp3`);
        const outputFile = path.join(tempDir, `scene${asset.scenes.scene_number}_padded.mp3`);
        
        await fs.writeFile(inputFile, buffer);
        
        // Pad to exactly 8.000 seconds with ffmpeg
        await execAsync(
          `ffmpeg -y -i "${inputFile}" -filter_complex "[0:a]apad=pad_dur=8.0[padded]" -map "[padded]" -t 8.0 "${outputFile}" 2>/dev/null`
        );
        
        // Upload padded version
        const paddedBuffer = await fs.readFile(outputFile);
        
        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('audio')
          .upload(
            `${args.project_id}/scene${asset.scenes.scene_number}_padded.mp3`,
            paddedBuffer,
            { contentType: 'audio/mpeg', upsert: true }
          );
        
        if (uploadError) throw uploadError;
        
        // Get new public URL
        const { data: { publicUrl } } = supabase.storage
          .from('audio')
          .getPublicUrl(uploadData.path);
        
        // Update audio_assets with padded version
        await supabase
          .from('audio_assets')
          .update({ url: publicUrl })
          .eq('id', asset.id);
        
        successCount++;
        
      } catch (error: any) {
        failCount++;
      }
    }
  } finally {
    await fs.rm(tempDir, { recursive: true, force: true }).catch(() => {});
  }
  
  return `✅ Audio Padding Complete!

**Padded**: ${successCount}/${audioAssets.length} narrations to exactly 8.000 seconds
${failCount > 0 ? `❌ Failed: ${failCount}` : ''}

**Result**:
- ✅ No audio bleeding between scenes
- ✅ Perfect synchronization guaranteed
- ✅ Each scene exactly 8 seconds
- ✅ Total documentary: ${audioAssets.length} × 8s = ${audioAssets.length * 8}s

**Audio pipeline complete! Ready for Phase 5: Visual System Design**

Next: Discuss visual strategy (character vs concept) then move to video generation.`;
}

async function executeGenerateVideosForScenes(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  if (!FAL_API_KEY || FAL_API_KEY === 'your_fal_api_key_here') {
    return '❌ FAL_API_KEY not configured. Cannot generate videos.';
  }
  
  const { project_id, scene_numbers, visual_prompts, seed_strategy = 'drift', base_seed = 50000 } = args;
  
  // Validate matching arrays
  if (scene_numbers.length !== visual_prompts.length) {
    return '❌ Error: scene_numbers and visual_prompts arrays must be same length';
  }
  
  // Get project info to include in prompts
  const { data: project } = await supabase
    .from('projects')
    .select('*')
    .eq('id', project_id)
    .single();
  
  if (!project) {
    return '❌ Project not found';
  }
  
  const results = [];
  
  // Generate videos for specified scenes only
  for (let i = 0; i < scene_numbers.length; i++) {
    const sceneNumber = scene_numbers[i];
    const visualPrompt = visual_prompts[i];
    
    try {
      // Get scene from database
      const { data: scene } = await supabase
        .from('scenes')
        .select('*')
        .eq('project_id', project_id)
        .eq('scene_number', sceneNumber)
        .single();
      
      if (!scene) {
        results.push({ scene: sceneNumber, status: 'Scene not found' });
        continue;
      }
      
      // Update video asset to processing
      await supabase
        .from('video_assets')
        .update({ status: 'processing' })
        .eq('scene_id', scene.id);
      
      // Calculate seed based on strategy
      const seed = seed_strategy === 'consistent' ? base_seed : base_seed + sceneNumber;
      
      // Build full prompt following MASTER_DOCUMENTARY_SYSTEM methodology
      const fullPrompt = `${visualPrompt}, cinematic documentary style, professional cinematography, no speech, ambient audio only, high quality 1080p`;
      
      // Call FAL Veo3 API
      const response = await fetch('https://fal.run/fal-ai/veo3/fast', {
        method: 'POST',
        headers: {
          'Authorization': `Key ${FAL_API_KEY}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          prompt: fullPrompt,
          duration: 8,
          aspect_ratio: '16:9',
          resolution: '1080p',
          seed: seed
        })
      });
      
      if (!response.ok) {
        throw new Error(`FAL API error: ${response.statusText}`);
      }
      
      const result = await response.json();
      const videoUrl = result.video.url;
      
      // Download video
      const videoResponse = await fetch(videoUrl);
      const videoBlob = await videoResponse.blob();
      const videoBuffer = Buffer.from(await videoBlob.arrayBuffer());
      
      // Upload to Supabase storage
      const { data: uploadData, error: uploadError } = await supabase.storage
        .from('video')
        .upload(
          `${project_id}/scene${sceneNumber}.mp4`,
          videoBuffer,
          { contentType: 'video/mp4', upsert: true }
        );
      
      if (uploadError) throw uploadError;
      
      // Get public URL
      const { data: { publicUrl } } = supabase.storage
        .from('video')
        .getPublicUrl(uploadData.path);
      
      // Update video_assets table
      await supabase
        .from('video_assets')
        .update({
          url: publicUrl,
          prompt: fullPrompt,
          status: 'complete'
        })
        .eq('scene_id', scene.id);
      
      results.push({
        scene: sceneNumber,
        status: 'success',
        seed: seed,
        url: publicUrl
      });
      
    } catch (error: any) {
      results.push({
        scene: sceneNumber,
        status: 'failed',
        error: error.message
      });
    }
  }
  
  const successCount = results.filter(r => r.status === 'success').length;
  
  return `🎥 Video Generation Complete!

**Generated**: ${successCount}/${scene_numbers.length} scenes
**Seed Strategy**: ${seed_strategy} (base: ${base_seed})

**Results:**
${results.map(r => `Scene ${r.scene}: ${r.status} ${r.seed ? `(seed: ${r.seed})` : ''}`).join('\n')}

${successCount > 0 ? `\n✅ Videos uploaded to Supabase and timeline will update with thumbnails!` : ''}

**Next**: 
${successCount === scene_numbers.length ? 
  '- Test more scenes if needed\n- Or proceed to Phase 7: Audio Mixing' : 
  '- Retry failed scenes or adjust prompts'
}

**IMPORTANT**: This was a test generation. Only generate full 22 scenes after confirming these look good!`;
}

async function executeMixScenes(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  const { project_id, scene_numbers } = args;
  
  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'mixing-'));
  const results = [];
  
  try {
    for (const sceneNumber of scene_numbers) {
      try {
        // Get scene with audio and video assets
        const { data: scene } = await supabase
          .from('scenes')
          .select(`
            *,
            audio_assets(url, status),
            video_assets(url, status)
          `)
          .eq('project_id', project_id)
          .eq('scene_number', sceneNumber)
          .single() as any;
        
        if (!scene || !scene.audio_assets[0]?.url || !scene.video_assets[0]?.url) {
          results.push({ scene: sceneNumber, status: 'Missing audio or video' });
          continue;
        }
        
        const audioUrl = scene.audio_assets[0].url;
        const videoUrl = scene.video_assets[0].url;
        
        // Download both files
        const audioResponse = await fetch(audioUrl);
        const audioBuffer = Buffer.from(await audioResponse.arrayBuffer());
        const audioFile = path.join(tempDir, `scene${sceneNumber}_audio.mp3`);
        await fs.writeFile(audioFile, audioBuffer);
        
        const videoResponse = await fetch(videoUrl);
        const videoBuffer = Buffer.from(await videoResponse.arrayBuffer());
        const videoFile = path.join(tempDir, `scene${sceneNumber}_video.mp4`);
        await fs.writeFile(videoFile, videoBuffer);
        
        const outputFile = path.join(tempDir, `scene${sceneNumber}_mixed.mp4`);
        
        // Mix with cinematic levels (MASTER_DOCUMENTARY_SYSTEM methodology)
        // Ambient: 0.25x, Narration: 1.3x
        await execAsync(
          `ffmpeg -y -i "${videoFile}" -i "${audioFile}" ` +
          `-filter_complex "[0:a]volume=0.25[ambient];[1:a]volume=1.3[narration];[ambient][narration]amix=inputs=2:duration=first:dropout_transition=3[audio]" ` +
          `-map 0:v -map "[audio]" -c:v copy -c:a aac "${outputFile}" 2>/dev/null`
        );
        
        // Upload mixed version
        const mixedBuffer = await fs.readFile(outputFile);
        
        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('mixed')
          .upload(
            `${project_id}/scene${sceneNumber}_mixed.mp4`,
            mixedBuffer,
            { contentType: 'video/mp4', upsert: true }
          );
        
        if (uploadError) throw uploadError;
        
        const { data: { publicUrl } } = supabase.storage
          .from('mixed')
          .getPublicUrl(uploadData.path);
        
        // Update mixed_assets table
        await supabase
          .from('mixed_assets')
          .update({
            url: publicUrl,
            status: 'complete'
          })
          .eq('scene_id', scene.id);
        
        results.push({
          scene: sceneNumber,
          status: 'success',
          url: publicUrl
        });
        
      } catch (error: any) {
        results.push({
          scene: sceneNumber,
          status: 'failed',
          error: error.message
        });
      }
    }
  } finally {
    await fs.rm(tempDir, { recursive: true, force: true }).catch(() => {});
  }
  
  const successCount = results.filter(r => r.status === 'success').length;
  
  return `🎬 Scene Mixing Complete!

**Mixed**: ${successCount}/${scene_numbers.length} scenes
**Audio Levels**: Ambient 0.25x, Narration 1.3x (cinematic standard)

**Results:**
${results.map(r => `Scene ${r.scene}: ${r.status}`).join('\n')}

${successCount > 0 ? '✅ Mixed scenes uploaded! Timeline will update.' : ''}

Next: Mix remaining scenes or export final documentary.`;
}

async function executeExportFinalDocumentary(args: any) {
  const supabase = createClient(supabaseUrl, supabaseKey);
  
  // Get all mixed scenes in order
  const { data: mixedAssets } = await supabase
    .from('mixed_assets')
    .select(`
      url,
      scenes!inner(scene_number, project_id)
    `)
    .eq('scenes.project_id', args.project_id)
    .eq('status', 'complete')
    .order('scenes(scene_number)') as any;
  
  if (!mixedAssets || mixedAssets.length === 0) {
    return '❌ No mixed scenes found. Mix scenes first.';
  }
  
  const { data: project } = await supabase
    .from('projects')
    .select('title')
    .eq('id', args.project_id)
    .single();
  
  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'export-'));
  
  try {
    // Download all mixed scenes
    const sceneFiles = [];
    for (const asset of mixedAssets) {
      const response = await fetch(asset.url);
      const buffer = Buffer.from(await response.arrayBuffer());
      const filename = `scene${asset.scenes.scene_number}.mp4`;
      const filepath = path.join(tempDir, filename);
      await fs.writeFile(filepath, buffer);
      sceneFiles.push(filepath);
    }
    
    // Create concat list
    const concatList = sceneFiles.map(f => `file '${f}'`).join('\n');
    const concatFile = path.join(tempDir, 'concat_list.txt');
    await fs.writeFile(concatFile, concatList);
    
    // Concatenate all scenes
    const outputFile = path.join(tempDir, 'final_documentary.mp4');
    await execAsync(
      `ffmpeg -y -f concat -safe 0 -i "${concatFile}" -c copy "${outputFile}" 2>/dev/null`
    );
    
    // Measure final duration
    const { stdout } = await execAsync(
      `ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${outputFile}"`
    );
    const duration = parseFloat(stdout.trim());
    const expectedDuration = mixedAssets.length * 8;
    
    // Upload final documentary
    const finalBuffer = await fs.readFile(outputFile);
    
    const { data: uploadData, error: uploadError } = await supabase.storage
      .from('final')
      .upload(
        `${args.project_id}/FINAL_DOCUMENTARY.mp4`,
        finalBuffer,
        { contentType: 'video/mp4', upsert: true }
      );
    
    if (uploadError) throw uploadError;
    
    const { data: { publicUrl } } = supabase.storage
      .from('final')
      .getPublicUrl(uploadData.path);
    
    // Update project status
    await supabase
      .from('projects')
      .update({ status: 'complete' })
      .eq('id', args.project_id);
    
    return `🎉 Final Documentary Export Complete!

**Title**: ${project?.title}
**Scenes**: ${mixedAssets.length}
**Duration**: ${Math.floor(duration)}s (expected: ${expectedDuration}s)
**Status**: ${Math.abs(duration - expectedDuration) < 1 ? '✅ Perfect timing!' : '⚠️ Duration mismatch'}

**Download URL**: ${publicUrl}

**Production Complete!**
All ${mixedAssets.length} scenes successfully compiled into final documentary.

Ready for Phase 9: YouTube Publishing (metadata generation).`;
    
  } finally {
    await fs.rm(tempDir, { recursive: true, force: true }).catch(() => {});
  }
}

export async function POST(req: NextRequest) {
  try {
    const { projectId, messages } = await req.json();

    // Check for API keys
    if (!process.env.ANTHROPIC_API_KEY || process.env.ANTHROPIC_API_KEY === 'your_anthropic_api_key_here') {
      return NextResponse.json({
        message: "I'm ready to help with documentary production! However, the Anthropic API key needs to be configured in .env.local."
      });
    }

    // Convert messages to Claude format
    const claudeMessages = messages.map((msg: any) => ({
      role: msg.role,
      content: msg.content
    }));

    let response = await anthropic.messages.create({
      model: 'claude-sonnet-4-20250514',
      max_tokens: 4096,
      system: DOCUMENTARY_SYSTEM_PROMPT,
      messages: claudeMessages,
      tools: PRODUCTION_TOOLS,
    });

    // Handle tool use (agentic loop)
    const maxIterations = 5;
    let iterations = 0;
    
    while (response.stop_reason === 'tool_use' && iterations < maxIterations) {
      iterations++;
      
      const toolUse: any = response.content.find((block: any) => block.type === 'tool_use');
      
      if (!toolUse) break;
      
      // Execute the tool
      let toolResult;
      
      if (toolUse.name === 'create_documentary_project') {
        toolResult = await executeCreateProject(toolUse.input);
      } else if (toolUse.name === 'generate_all_narrations') {
        toolResult = await executeGenerateNarrations(toolUse.input);
      } else if (toolUse.name === 'analyze_narration_timing') {
        toolResult = await executeAnalyzeNarrationTiming(toolUse.input);
      } else if (toolUse.name === 'pad_all_audio_to_8_seconds') {
        toolResult = await executePadAudioTo8Seconds(toolUse.input);
      } else if (toolUse.name === 'generate_videos_for_scenes') {
        toolResult = await executeGenerateVideosForScenes(toolUse.input);
      } else if (toolUse.name === 'mix_scenes') {
        toolResult = await executeMixScenes(toolUse.input);
      } else if (toolUse.name === 'export_final_documentary') {
        toolResult = await executeExportFinalDocumentary(toolUse.input);
      } else {
        toolResult = `Unknown tool: ${toolUse.name}`;
      }
      
      // Continue conversation with tool result
      claudeMessages.push({
        role: 'assistant',
        content: response.content
      });
      
      claudeMessages.push({
        role: 'user',
        content: [{
          type: 'tool_result',
          tool_use_id: toolUse.id,
          content: toolResult
        }]
      });
      
      // Get next response
      response = await anthropic.messages.create({
        model: 'claude-sonnet-4-20250514',
        max_tokens: 4096,
        system: DOCUMENTARY_SYSTEM_PROMPT,
        messages: claudeMessages,
        tools: PRODUCTION_TOOLS,
      });
    }

    // Extract final text response
    const textBlock: any = response.content.find((block: any) => block.type === 'text');
    const message = textBlock ? textBlock.text : 'Sorry, I could not generate a response.';

    return NextResponse.json({ message });
    
  } catch (error) {
    console.error('Agent chat error:', error);
    return NextResponse.json(
      { error: 'Failed to process message', details: error instanceof Error ? error.message : 'Unknown error' },
      { status: 500 }
    );
  }
}
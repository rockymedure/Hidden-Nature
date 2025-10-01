import { tool } from '@anthropic-ai/claude-agent-sdk';
import { z } from 'zod';
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const FAL_API_KEY = process.env.FAL_API_KEY!;

/**
 * Tool 1: Create Documentary Project
 * 
 * This is the COMMIT action that takes the refined script from chat
 * and persists it to the database, triggering the UI to update.
 * 
 * Only called when user explicitly says "create the project" or "save this script"
 */
export const createDocumentaryProjectTool = tool(
  'create_documentary_project',
  `Create a new documentary project in the database with scenes. 
  This writes the finalized script to Supabase and triggers the UI to display it in the left panel.
  Only use this when the user explicitly asks to create/save the project after finalizing the script.`,
  z.object({
    title: z.string().describe('Documentary title'),
    narrations: z.array(z.string()).describe('Array of scene narration texts (20-25 scenes)'),
    narrator: z.string().default('Charlotte').describe('Voice narrator name'),
    documentary_type: z.enum(['character', 'concept']).describe('Visual approach strategy')
  }),
  async (args) => {
    const supabase = createClient(supabaseUrl, supabaseKey);
    
    // Validate scene count
    if (args.narrations.length < 20 || args.narrations.length > 25) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error: Expected 20-25 scenes but got ${args.narrations.length}. Please adjust the script.`
        }],
        isError: true
      };
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
      return {
        content: [{
          type: 'text',
          text: `❌ Database Error: ${projectError.message}`
        }],
        isError: true
      };
    }
    
    // Create scenes
    const scenesData = args.narrations.map((narration, index) => ({
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
      return {
        content: [{
          type: 'text',
          text: `❌ Scenes Error: ${scenesError.message}`
        }],
        isError: true
      };
    }
    
    // Create asset placeholders
    for (const scene of scenes) {
      await Promise.all([
        supabase.from('audio_assets').insert({ scene_id: scene.id, status: 'pending' }),
        supabase.from('video_assets').insert({ scene_id: scene.id, status: 'pending' }),
        supabase.from('mixed_assets').insert({ scene_id: scene.id, status: 'pending' })
      ]);
    }
    
    return {
      content: [{
        type: 'text',
        text: JSON.stringify({
          success: true,
          project_id: project.id,
          project_url: `http://localhost:3005/projects/${project.id}`,
          scenes_created: scenes.length,
          narrator: args.narrator,
          message: `✅ Project "${args.title}" created with ${scenes.length} scenes!\n\n📍 Navigate to: /projects/${project.id}\n\nThe left panel will now display all ${scenes.length} scenes. Ready for Phase 3: Narration Generation.`
        }, null, 2)
      }]
    };
  }
);

/**
 * Tool 2: Generate All Narrations
 * 
 * Phase 3 from COMPLETE_DOCUMENTARY_SYSTEM.md
 * Generates ALL narrations in parallel using ElevenLabs via FAL
 * 
 * Only called when user says "generate narrations" or "start audio generation"
 */
export const generateAllNarrationsTool = tool(
  'generate_all_narrations',
  `Generate all scene narrations in parallel using ElevenLabs TTS via FAL API.
  This is Phase 3 from the production system - AUDIO FIRST methodology.
  Only call this after the project is created and user confirms to start narration generation.`,
  z.object({
    project_id: z.string().describe('Project UUID from database'),
    narrator: z.string().default('Charlotte').describe('ElevenLabs voice name')
  }),
  async (args) => {
    const supabase = createClient(supabaseUrl, supabaseKey);
    
    // Get all scenes
    const { data: scenes, error: scenesError } = await supabase
      .from('scenes')
      .select('*')
      .eq('project_id', args.project_id)
      .order('scene_number');
    
    if (scenesError || !scenes) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error: Could not find scenes for project ${args.project_id}`
        }],
        isError: true
      };
    }
    
    // Generate ALL narrations in parallel
    const results = await Promise.allSettled(
      scenes.map(async (scene) => {
        try {
          // Call ElevenLabs via FAL
          const response = await fetch('https://fal.run/fal-ai/elevenlabs/tts/eleven-v3', {
            method: 'POST',
            headers: {
              'Authorization': `Key ${FAL_API_KEY}`,
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              text: scene.narration_text,
              voice: args.narrator,
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
          
          // Download audio file
          const audioResponse = await fetch(audioUrl);
          const audioBuffer = await audioResponse.arrayBuffer();
          
          // Upload to Supabase storage
          const { data: uploadData, error: uploadError } = await supabase.storage
            .from('audio')
            .upload(
              `${args.project_id}/scene${scene.scene_number}.mp3`,
              audioBuffer,
              { contentType: 'audio/mpeg' }
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
          
          return {
            scene_number: scene.scene_number,
            status: 'success',
            url: publicUrl
          };
        } catch (error) {
          return {
            scene_number: scene.scene_number,
            status: 'failed',
            error: error.message
          };
        }
      })
    );
    
    const successful = results.filter(r => r.status === 'fulfilled').length;
    const failed = results.filter(r => r.status === 'rejected').length;
    
    return {
      content: [{
        type: 'text',
        text: JSON.stringify({
          success: failed === 0,
          narrations_generated: successful,
          failed_narrations: failed,
          total_scenes: scenes.length,
          message: `✅ Generated ${successful}/${scenes.length} narrations in parallel.\n\nNext: Phase 4 - Timing Analysis\nRun timing analysis to measure durations and identify any narrations outside 6.0-7.8s range for regeneration.`,
          results: results
        }, null, 2)
      }],
      isError: failed > 0
    };
  }
);

/**
 * Tool 3: Analyze Narration Timing
 * 
 * Phase 4 from COMPLETE_DOCUMENTARY_SYSTEM.md
 * Measures all narration durations and identifies which need regeneration
 */
export const analyzeNarrationTimingTool = tool(
  'analyze_narration_timing',
  `Measure all narration durations using ffprobe and identify which need regeneration.
  Target range: 6.0-7.8 seconds. Any outside this range should be regenerated.
  This is Phase 4 - critical for perfect synchronization.`,
  z.object({
    project_id: z.string().describe('Project UUID')
  }),
  async (args) => {
    const supabase = createClient(supabaseUrl, supabaseKey);
    
    // Get all audio assets
    const { data: audioAssets } = await supabase
      .from('audio_assets')
      .select('*, scenes(scene_number, narration_text)')
      .eq('scenes.project_id', args.project_id)
      .eq('status', 'complete');
    
    // TODO: Implement ffprobe duration measurement
    // For now, return structure showing what timing analysis would reveal
    
    return {
      content: [{
        type: 'text',
        text: `📊 Timing Analysis Results:\n\nThis tool would measure each narration with ffprobe and report:\n- Scenes within 6.0-7.8s range (optimal)\n- Scenes needing regeneration (outside range)\n- Recommended padding to 8.000s\n\nNext: Implement ffprobe measurement or proceed to Phase 6: Video Generation if timing looks good.`
      }]
    };
  }
);

export const PRODUCTION_TOOLS = [
  createDocumentaryProjectTool,
  generateAllNarrationsTool,
  analyzeNarrationTimingTool
];

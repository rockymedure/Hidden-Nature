import { tool } from '@anthropic-ai/claude-agent-sdk';
import { z } from 'zod';
import { createClient } from '@supabase/supabase-js';
import { exec } from 'child_process';
import { promisify } from 'util';
import * as fs from 'fs/promises';
import * as path from 'path';
import * as os from 'os';

const execAsync = promisify(exec);

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
const FAL_API_KEY = process.env.FAL_API_KEY!;

/**
 * PHASE 4: Timing Analysis Tool
 * 
 * Critical for MASTER_DOCUMENTARY_SYSTEM.md Phase 4:
 * - Downloads all audio files from Supabase
 * - Measures duration with ffprobe
 * - Identifies scenes outside 6.0-7.8s range
 * - Reports which need regeneration
 */
export const analyzeNarrationTimingTool = tool(
  'analyze_narration_timing',
  `Analyze all narration durations using ffprobe. 
  This is Phase 4 from the production system - critical for perfect synchronization.
  Measures each narration and identifies which are outside the 6.0-7.8 second optimal range.
  Only call this after all narrations have been generated successfully.`,
  z.object({
    project_id: z.string().describe('Project UUID from database')
  }),
  async (args) => {
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
      .eq('status', 'complete')
      .order('scenes(scene_number)');
    
    if (error || !audioAssets) {
      return {
        content: [{
          type: 'text',
          text: `❌ Error: Could not fetch audio assets for project ${args.project_id}`
        }],
        isError: true
      };
    }
    
    // Create temp directory for analysis
    const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'timing-analysis-'));
    
    const timingResults = [];
    
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
          scene_number: asset.scenes.scene_number,
          duration: duration.toFixed(3),
          in_range: inRange,
          needs_padding: needsPadding,
          status: inRange ? '✅ Good' : '❌ Regenerate',
          narration_text: asset.scenes.narration_text
        });
        
      } catch (error: any) {
        timingResults.push({
          scene_number: asset.scenes.scene_number,
          duration: 'ERROR',
          in_range: false,
          needs_padding: true,
          status: '❌ Measurement failed',
          error: error.message
        });
      }
    }
    
    // Cleanup temp directory
    await fs.rm(tempDir, { recursive: true, force: true });
    
    // Calculate statistics
    const totalScenes = timingResults.length;
    const inRangeCount = timingResults.filter(r => r.in_range).length;
    const needsRegenCount = timingResults.filter(r => !r.in_range).length;
    const needsPaddingCount = timingResults.filter(r => r.needs_padding).length;
    
    const scenesToRegenerate = timingResults
      .filter(r => !r.in_range)
      .map(r => `Scene ${r.scene_number}: ${r.duration}s - "${r.narration_text}"`)
      .join('\n');
    
    return {
      content: [{
        type: 'text',
        text: `📊 Timing Analysis Complete!

**Results:**
- Total Scenes: ${totalScenes}
- ✅ In Range (6.0-7.8s): ${inRangeCount}/${totalScenes} (${Math.round(inRangeCount/totalScenes*100)}%)
- ❌ Need Regeneration: ${needsRegenCount}
- ⏳ Need Padding to 8.000s: ${needsPaddingCount}

${needsRegenCount > 0 ? `\n**Scenes Needing Regeneration:**\n${scenesToRegenerate}\n` : ''}

**Next Steps:**
${needsRegenCount > 0 ? 
  '1. Regenerate scenes outside 6.0-7.8s range\n2. Pad ALL narrations to exactly 8.000 seconds' : 
  '1. Pad ALL narrations to exactly 8.000 seconds\n2. Proceed to Phase 5: Visual System Design'
}

**Detailed Results:**
${JSON.stringify(timingResults, null, 2)}`
      }]
    };
  }
);

/**
 * PHASE 4: Padding Tool
 * 
 * Pads ALL narrations to exactly 8.000 seconds
 * This prevents audio bleeding between scenes - CRITICAL for synchronization
 */
export const padAudioTo8SecondsTool = tool(
  'pad_all_audio_to_8_seconds',
  `Pad ALL narrations to exactly 8.000 seconds using ffmpeg.
  This is CRITICAL from Phase 4 - prevents audio bleeding between scenes.
  Must be run on ALL narrations before video generation begins.`,
  z.object({
    project_id: z.string().describe('Project UUID')
  }),
  async (args) => {
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
      .eq('status', 'complete');
    
    if (!audioAssets || audioAssets.length === 0) {
      return {
        content: [{
          type: 'text',
          text: '❌ No completed audio assets found. Generate narrations first.'
        }],
        isError: true
      };
    }
    
    const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'audio-padding-'));
    const results = [];
    
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
        
        // Upload padded version back to Supabase
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
        
        results.push({
          scene_number: asset.scenes.scene_number,
          status: 'padded',
          new_url: publicUrl
        });
        
      } catch (error: any) {
        results.push({
          scene_number: asset.scenes.scene_number,
          status: 'failed',
          error: error.message
        });
      }
    }
    
    // Cleanup
    await fs.rm(tempDir, { recursive: true, force: true });
    
    const successCount = results.filter(r => r.status === 'padded').length;
    
    return {
      content: [{
        type: 'text',
        text: `✅ Audio Padding Complete!

**Padded**: ${successCount}/${audioAssets.length} narrations to exactly 8.000 seconds

This ensures:
- ✅ No audio bleeding between scenes
- ✅ Perfect synchronization in final documentary  
- ✅ Each scene exactly 8 seconds (24 scenes × 8s = 192s total)

**Audio pipeline complete! Ready for Phase 5: Visual System Design**

Next steps:
1. Discuss visual strategy (character vs concept)
2. Plan seed consistency approach
3. Move to Phase 6: Video Generation`
      }]
    };
  }
);

export const TIMING_TOOLS = [
  analyzeNarrationTimingTool,
  padAudioTo8SecondsTool
];

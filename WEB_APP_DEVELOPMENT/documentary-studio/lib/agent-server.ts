import { createSdkMcpServer } from '@anthropic-ai/claude-agent-sdk';
import { PRODUCTION_TOOLS } from './production-tools';

/**
 * Documentary Production MCP Server
 * 
 * Provides tools for the agent to execute production tasks:
 * - create_documentary_project: Save script to database
 * - generate_all_narrations: Generate audio for all scenes
 * - analyze_narration_timing: Check timing and identify regeneration needs
 */
export const documentaryProductionServer = createSdkMcpServer({
  name: 'documentary-production',
  version: '1.0.0',
  tools: PRODUCTION_TOOLS
});

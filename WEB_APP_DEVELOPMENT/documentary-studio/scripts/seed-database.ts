import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
import * as path from 'path';

// Load .env.local
dotenv.config({ path: path.join(__dirname, '../.env.local') });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Missing Supabase credentials in .env.local');
}

const supabase = createClient(supabaseUrl, supabaseKey);

const SAMPLE_SCRIPT = [
  "Before the first ray of sunlight touches Earth, leaves are already preparing - opening their pores, positioning for the day ahead.",
  "Four hundred million years ago, the first leaves appeared - simple green patches that would evolve into nature's most sophisticated solar panels.",
  "Every leaf breathes through millions of tiny mouths called stomata - opening and closing thirty thousand times each day.",
  "When attacked by insects, leaves instantly release chemical alarm signals - a botanical scream that warns the entire forest.",
  "Beneath our feet, fungal networks connect every leaf to every tree - a wood wide web sharing resources and information.",
  "In scorching deserts, succulent leaves have become water barrels - storing liquid treasures for months of drought.",
  "Desert leaves armor themselves with microscopic wax chimneys - tiny fortresses that guard every breathing pore.",
  "Arctic leaves rush through their entire lifecycle in just three weeks - a botanical sprint against the frozen clock.",
  "Some leaves communicate through light reflection - sending Morse code messages to their neighbors.",
  "Underwater leaves have evolved backwards - relearning to breathe dissolved oxygen like their distant ancestors.",
  "Leaves contain quantum computing systems - using quantum coherence to achieve near-perfect energy efficiency.",
  "The largest single leaf ever recorded was over ten feet wide - nature's solar panel maximizing every photon.",
  "Carnivorous plant leaves have become sophisticated traps - evolving into nature's most patient hunters.",
  "Ancient leaves created our oxygen atmosphere - a two billion year terraforming project still ongoing today.",
  "Autumn colors aren't dying - they're revelations, exposing the hidden pigments always present beneath the green.",
  "Some tree leaves live for over forty years - experiencing hundreds of seasonal cycles on a single branch.",
  "Leaves can detect the specific vibration frequency of caterpillar chewing - and chemically respond in five minutes.",
  "Desert resurrection plants' leaves can lose 95% of their water - entering suspended animation for years.",
  "Leaves angle themselves to share sunlight - avoiding shading their neighbors in what botanists call 'crown shyness'.",
  "The smallest leaves are barely visible - yet pack the same photosynthetic machinery as their giant cousins.",
  "Leaves helped animals evolve flight - the original inspiration for wing-like structures in insects and birds.",
  "Some leaves fold closed at night - entering a botanical sleep state to conserve energy and water.",
  "Every oxygen molecule you just breathed was crafted by a leaf - an act of biological alchemy repeated trillions of times per second."
];

async function seedDatabase() {
  try {
    console.log('🌱 Seeding database...');

    // Create a sample project
    const { data: project, error: projectError } = await supabase
      .from('projects')
      .insert({
        title: 'Leaf Intelligence Documentary',
        script: SAMPLE_SCRIPT.join('\n\n'),
        total_scenes: SAMPLE_SCRIPT.length,
        status: 'draft'
      })
      .select()
      .single();

    if (projectError) {
      throw projectError;
    }

    console.log(`✅ Created project: ${project.title} (${project.id})`);

    // Create scenes for each narration
    const scenesData = SAMPLE_SCRIPT.map((narration, index) => ({
      project_id: project.id,
      scene_number: index + 1,
      narration_text: narration,
      duration_seconds: 10.0
    }));

    const { data: scenes, error: scenesError } = await supabase
      .from('scenes')
      .insert(scenesData)
      .select();

    if (scenesError) {
      throw scenesError;
    }

    console.log(`✅ Created ${scenes.length} scenes`);

    // Create audio/video/mixed asset placeholders for each scene
    for (const scene of scenes) {
      await supabase.from('audio_assets').insert({
        scene_id: scene.id,
        status: 'pending'
      });

      await supabase.from('video_assets').insert({
        scene_id: scene.id,
        status: 'pending'
      });

      await supabase.from('mixed_assets').insert({
        scene_id: scene.id,
        status: 'pending'
      });
    }

    console.log(`✅ Created asset placeholders`);
    console.log(`\n🎉 Database seeded successfully!`);
    console.log(`📋 Project ID: ${project.id}`);

  } catch (error) {
    console.error('❌ Error seeding database:', error);
  }
}

seedDatabase();

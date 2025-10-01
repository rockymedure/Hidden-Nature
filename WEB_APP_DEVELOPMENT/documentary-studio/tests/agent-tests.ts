/**
 * Comprehensive Agent Test Suite
 * Tests the agent's understanding of documentary production methodology
 */

interface TestCase {
  name: string;
  userMessage: string;
  expectedTopics: string[];
  category: 'script' | 'timing' | 'visual' | 'production' | 'troubleshooting';
}

export const AGENT_TESTS: TestCase[] = [
  // Script Development Tests
  {
    name: 'Understanding Script Structure',
    userMessage: 'How should I structure my documentary script?',
    expectedTopics: [
      '20-25 scenes',
      '15-20 words per scene',
      '6.0-7.8 seconds target',
      'one concept per scene',
      'progressive complexity'
    ],
    category: 'script'
  },
  {
    name: 'Script Quality Standards',
    userMessage: 'What makes a good documentary narration?',
    expectedTopics: [
      'educational depth',
      'emotional engagement',
      'natural language flow',
      'visual specificity',
      'Sagan',
      'Attenborough'
    ],
    category: 'script'
  },

  // Timing and Synchronization Tests
  {
    name: 'Perfect Synchronization Understanding',
    userMessage: 'How do I prevent audio bleeding between scenes?',
    expectedTopics: [
      'pad to 8.000 seconds',
      'narration padding',
      'prevent bleeding',
      'exact boundaries',
      'ffmpeg'
    ],
    category: 'timing'
  },
  {
    name: 'Timing Analysis Process',
    userMessage: 'How do I check if my narration timing is correct?',
    expectedTopics: [
      'ffprobe',
      '6.0-7.8 seconds',
      'measure duration',
      'regenerate if needed',
      'padding'
    ],
    category: 'timing'
  },

  // Visual Consistency Tests
  {
    name: 'Character vs Concept Strategy',
    userMessage: 'Should I use character consistency for a science documentary about quantum physics?',
    expectedTopics: [
      'concept-focused',
      'no character system',
      'educational visualization',
      'thematic coherence',
      'science documentary'
    ],
    category: 'visual'
  },
  {
    name: 'Nature Documentary Visual Planning',
    userMessage: 'How do I maintain character consistency in a nature documentary about deer families?',
    expectedTopics: [
      'character seed',
      'same species',
      'distinctive features',
      'environment mapping',
      'seed consistency'
    ],
    category: 'visual'
  },

  // Production Pipeline Tests
  {
    name: 'Audio-First Methodology',
    userMessage: 'What should I generate first - audio or video?',
    expectedTopics: [
      'audio first',
      'script-first, audio-first',
      'perfect synchronization',
      'before video',
      'narration generation'
    ],
    category: 'production'
  },
  {
    name: 'Parallel Processing Strategy',
    userMessage: 'How should I generate all 24 scenes efficiently?',
    expectedTopics: [
      'parallel',
      'simultaneously',
      'all scenes at once',
      'maximum speed',
      'wait for completion'
    ],
    category: 'production'
  },
  {
    name: 'Production Phase Order',
    userMessage: 'What are the phases of documentary production?',
    expectedTopics: [
      'audio generation',
      'video generation',
      'mixing',
      'final export',
      'phase order'
    ],
    category: 'production'
  },

  // Troubleshooting Tests
  {
    name: 'Speech Bleeding Solution',
    userMessage: 'Some of my video scenes have unwanted dialogue. What should I do?',
    expectedTopics: [
      'narration-only',
      'drop ambient',
      'speech bleeding',
      'regenerate with different seed',
      'no speech, ambient only'
    ],
    category: 'troubleshooting'
  },
  {
    name: 'Narration Too Long',
    userMessage: 'One of my narrations is 8.5 seconds long. What should I do?',
    expectedTopics: [
      'regenerate',
      'shorten text',
      '6.0-7.8 seconds',
      'outside range',
      'needs regeneration'
    ],
    category: 'troubleshooting'
  },

  // Advanced Methodology Tests
  {
    name: 'Multi-Format Production',
    userMessage: 'Can I create both desktop and mobile versions of my documentary?',
    expectedTopics: [
      '16:9',
      '9:16',
      'mobile version',
      'aspect ratio',
      'YouTube Shorts'
    ],
    category: 'production'
  },
  {
    name: 'Narrator Selection',
    userMessage: 'Which narrator voice should I use for a cosmic wonder science documentary?',
    expectedTopics: [
      'Rachel',
      'cosmic wonder',
      'Oracle X',
      'professional',
      'science content'
    ],
    category: 'production'
  },
  {
    name: 'Audio Mixing Levels',
    userMessage: 'What are the correct audio mixing levels for cinematic quality?',
    expectedTopics: [
      '0.25x ambient',
      '1.3x narration',
      'cinematic levels',
      'balanced mix',
      'audio mixing'
    ],
    category: 'production'
  }
];

export function evaluateAgentResponse(response: string, expectedTopics: string[]): {
  score: number;
  matchedTopics: string[];
  missedTopics: string[];
  passed: boolean;
} {
  const lowerResponse = response.toLowerCase();
  const matchedTopics: string[] = [];
  const missedTopics: string[] = [];

  for (const topic of expectedTopics) {
    if (lowerResponse.includes(topic.toLowerCase())) {
      matchedTopics.push(topic);
    } else {
      missedTopics.push(topic);
    }
  }

  const score = (matchedTopics.length / expectedTopics.length) * 100;
  const passed = score >= 60; // 60% threshold for passing

  return {
    score,
    matchedTopics,
    missedTopics,
    passed
  };
}

export async function runAgentTest(
  testCase: TestCase,
  apiEndpoint: string = '/api/agent/chat'
): Promise<{
  test: string;
  passed: boolean;
  score: number;
  response: string;
  evaluation: ReturnType<typeof evaluateAgentResponse>;
}> {
  try {
    const response = await fetch(apiEndpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        projectId: 'test-project',
        messages: [
          {
            role: 'user',
            content: testCase.userMessage
          }
        ]
      })
    });

    const data = await response.json();
    const agentResponse = data.message || '';

    const evaluation = evaluateAgentResponse(agentResponse, testCase.expectedTopics);

    return {
      test: testCase.name,
      passed: evaluation.passed,
      score: evaluation.score,
      response: agentResponse,
      evaluation
    };
  } catch (error) {
    console.error(`Test failed: ${testCase.name}`, error);
    return {
      test: testCase.name,
      passed: false,
      score: 0,
      response: '',
      evaluation: {
        score: 0,
        matchedTopics: [],
        missedTopics: testCase.expectedTopics,
        passed: false
      }
    };
  }
}

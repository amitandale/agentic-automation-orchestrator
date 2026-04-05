/**
 * Warm-Up Accounts — Manages a state machine per social account.
 *
 * Each account progresses through 5 warm-up stages based on age.
 * The anti-ban-guard plugin enforces these stages automatically.
 * This script initializes and tracks the warm-up state.
 *
 * Usage: npx tsx scripts/warm-up-accounts.ts
 */

import * as fs from 'fs';
import * as path from 'path';


interface AccountConfig {
  platform: string;
  username: string;
  createdAt: string;  // ISO date when the account was first registered
  warmUpState: 'idle' | 'read_only' | 'light_engagement' | 'organic_posting' | 'soft_mention' | 'full_active';
}

interface WarmUpStage {
  name: string;
  dayRange: [number, number];
  allowedActions: string[];
  bookMentions: string;
}

const STAGES: WarmUpStage[] = [
  {
    name: 'read_only',
    dayRange: [1, 7],
    allowedActions: ['browse', 'upvote', 'follow'],
    bookMentions: 'None',
  },
  {
    name: 'light_engagement',
    dayRange: [8, 14],
    allowedActions: ['browse', 'upvote', 'follow', 'reply_generic'],
    bookMentions: 'None',
  },
  {
    name: 'organic_posting',
    dayRange: [15, 21],
    allowedActions: ['browse', 'upvote', 'follow', 'reply_generic', 'post_non_promotional'],
    bookMentions: 'None',
  },
  {
    name: 'soft_mention',
    dayRange: [22, 30],
    allowedActions: ['browse', 'upvote', 'follow', 'reply_generic', 'post_non_promotional', 'mention_contextual'],
    bookMentions: 'Soft, contextual only (1/day max)',
  },
  {
    name: 'full_active',
    dayRange: [31, Infinity],
    allowedActions: ['all'],
    bookMentions: 'Per platform limits',
  },
];

function getAccountAge(createdAt: string): number {
  const created = new Date(createdAt);
  const now = new Date();
  return Math.floor((now.getTime() - created.getTime()) / (1000 * 60 * 60 * 24));
}

function getCurrentStage(ageDays: number): WarmUpStage {
  return STAGES.find((s) => ageDays >= s.dayRange[0] && ageDays <= s.dayRange[1]) ?? STAGES[STAGES.length - 1];
}

function loadAccountConfigs(): AccountConfig[] {
  const accountsDir = path.resolve(__dirname, '..', 'config', 'openclaw', 'accounts');

  if (!fs.existsSync(accountsDir)) {
    console.log('⚠ No accounts directory found. Create config/openclaw/accounts/ with platform JSON files.');
    return [];
  }

  const configs: AccountConfig[] = [];
  const files = fs.readdirSync(accountsDir).filter((f: string) => f.endsWith('.json'));

  for (const file of files) {
    try {
      const raw = fs.readFileSync(path.join(accountsDir, file), 'utf-8');
      const config = JSON.parse(raw) as AccountConfig;
      configs.push(config);
    } catch (error) {
      console.error(`  ✗ Failed to load ${file}: ${error}`);
    }
  }

  return configs;
}

async function main(): Promise<void> {
  console.log('==> Account Warm-Up Status');
  console.log('');

  const accounts = loadAccountConfigs();

  if (accounts.length === 0) {
    console.log('No accounts configured. Add JSON files to config/openclaw/accounts/');
    console.log('');
    console.log('Example (config/openclaw/accounts/reddit.json):');
    console.log(JSON.stringify({
      platform: 'reddit',
      username: 'your_username',
      createdAt: new Date().toISOString(),
      warmUpState: 'idle',
    }, null, 2));
    return;
  }

  console.log('┌──────────┬────────────────┬──────────┬─────────────────────┬─────────────────────┐');
  console.log('│ Platform │ Username       │ Age(days)│ Stage               │ Book Mentions       │');
  console.log('├──────────┼────────────────┼──────────┼─────────────────────┼─────────────────────┤');

  for (const account of accounts) {
    const ageDays = getAccountAge(account.createdAt);
    const stage = getCurrentStage(ageDays);

    const platform = account.platform.padEnd(8);
    const username = account.username.padEnd(14);
    const age = String(ageDays).padStart(8);
    const stageName = stage.name.padEnd(19);
    const mentions = stage.bookMentions.substring(0, 19).padEnd(19);

    console.log(`│ ${platform} │ ${username} │ ${age} │ ${stageName} │ ${mentions} │`);
  }

  console.log('└──────────┴────────────────┴──────────┴─────────────────────┴─────────────────────┘');
  console.log('');
  console.log('==> Warm-up check complete.');
}

main().catch((error) => {
  console.error('ERROR:', error);
  process.exit(1);
});

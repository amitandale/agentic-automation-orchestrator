# Skills Directory

Skills are markdown instruction files that tell agents exactly how to perform specific tasks. Each agent reads the relevant SKILL.md before executing.

## Dual-Funnel Architecture

The system operates two parallel marketing funnels:

| Funnel | Books | Audience | Voice File |
|---|---|---|---|
| `religious` | 1, 2, 3 (Trilogy) | Torah study, Jewish spirituality, mysticism | `book-voice-religious/SKILL.md` |
| `secular` | 4 | Self-improvement, consciousness, mindfulness | `book-voice-secular/SKILL.md` |

Every task dispatched by Paperclip includes a `funnel` parameter. Skills use this to:
1. Load the correct voice guidelines
2. Search the correct topics/hashtags
3. Filter Qdrant queries to the correct books
4. Never cross funnels — religious content stays religious, secular stays secular

## Multilingual Support

Agents dynamically detect the language of the target thread/profile and:
1. Draft content natively in the detected language (never translate)
2. Filter Qdrant queries by both `funnel` AND `language`
3. If no content exists in the target language, use English as fallback reference but still draft natively

## Available Skills

| Skill | Agent | Purpose |
|---|---|---|
| `book-voice` | — | Router: points to the two funnel-specific voice skills |
| `book-voice-religious` | Hermes | Voice guidelines for Trilogy (Books 1–3) engagement |
| `book-voice-secular` | Hermes | Voice guidelines for Book 4 engagement |
| `dual-funnel-routing` | All | Decision logic: which platforms/communities → which funnel |
| `post-review-checklist` | All | Pre-approval self-check before submitting to WhatsApp |
| `reddit-post` | OpenClaw + Hermes | Reddit thread engagement with anti-ban rules |
| `twitter-post` | OpenClaw + Hermes | Twitter/X posting and replies with anti-ban rules |
| `discord-engage` | OpenClaw + Hermes | Discord community participation |
| `influencer-scout` | OpenClaw | Browser-based influencer discovery (funnel-specific search) |
| `dm-outreach` | OpenClaw + Hermes | Direct message outreach with funnel-specific pitch |
| `link-generator` | OpenClaw | Tracked link generation via reader app (placeholder) |

## Pre-Approval Checklist

Every content-generating skill must run the `post-review-checklist/SKILL.md` before submitting drafts to the WhatsApp approval queue. This catches voice mismatches, funnel leaks, and platform violations before they reach the operator's phone.

## Anti-Ban Rules

Platform-specific anti-ban rules are stored as companion markdown files inside each skill directory (e.g., `reddit-post/anti-ban-rules.md`). These are read by the agents alongside the SKILL.md.


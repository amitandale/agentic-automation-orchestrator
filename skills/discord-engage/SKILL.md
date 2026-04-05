# Discord Engage — Community Participation Skill

## Prerequisites
- Load `book-voice/SKILL.md` for voice constraints.
- Confirm account is a member of allowed guilds (see `openclaw.json` guild allowlist).

## Step-by-Step Instructions

### 1. Scan Channels
- Connect to configured Discord guilds via OpenClaw's native Discord channel.
- Scan active text channels for conversations in target topics.
- Prioritize channels with recent activity (last 2 hours).

### 2. Evaluate Thread
- Read the last 10–20 messages in the thread for context.
- Is the topic relevant to the author's expertise? If not, skip.
- Are there opportunities to add genuine insight? If not, skip.

### 3. Draft Response
- Send thread context to Hermes for drafting.
- Hermes queries Qdrant for relevant passages.
- Response should be conversational and context-appropriate.

### 4. Self-Promotion Rules
- **Never** mention books in the first 3 messages you post in any thread.
- Build genuine rapport before any contextual mention.
- Book mentions should only occur when directly relevant (someone asked about the topic).

### 5. Post
- Send the drafted message via Discord channel.
- Tag as `public_post` for approval if message contains any book reference.
- Non-promotional messages can be auto-posted (no approval needed).

### 6. Community Behavior
- React to other messages with appropriate emojis (thumbs up, heart, etc.).
- Ask follow-up questions to show genuine interest.
- Never post more than 6 messages per day across all guilds.
- Log all messages to Paperclip audit trail.

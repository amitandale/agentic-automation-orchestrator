# Ben Ariel Publishing Automation — GitHub Repository Plan

**Project Name:** `ben-ariel-machine`  
**Purpose:** Glue layer that installs, configures, and operates Paperclip + OpenClaw + Hermes-Agent + Qdrant on a self-hosted VPS for the autonomous digital marketing of David ben Ariel's books.

---

## Executive Summary

This repository is not a fork of any upstream repo — it is an **orchestration wrapper** that sits on top of all four components. It handles VPS provisioning, dependency installation, environment configuration, OpenClaw skill authoring, Hermes prompt engineering, book RAG indexing, and anti-ban guard logic. The entire system is operated through a single `make` command interface and monitored via Paperclip's dashboard. Approvals reach you on WhatsApp. Every action is logged in Paperclip's immutable audit trail.

---

## Final Stack

| Component | Role | How it runs |
|---|---|---|
| **Paperclip** | Company OS — governance, budgets, audit log, approval routing | Docker container, port 3100 (API) + 3101 (dashboard) |
| **OpenClaw** | Browser execution — posts to Reddit/Twitter/Discord via real sessions, reads book files | Docker container, port 18789 |
| **Hermes-Agent** | Reasoning brain — drafts content in ben Ariel's voice, queries Qdrant, self-improves skills | Docker container, port 4000 |
| **Qdrant** | Book vector store — semantic retrieval over all 4 books for every content task | Docker container, port 6333 |
| **Postgres** | Paperclip's database — audit log, tickets, company state | Docker container, port 5432 |

---

## Repository Structure

```
ben-ariel-machine/
│
├── README.md                        # Full setup and operations guide
├── Makefile                         # Single entry point for all operations
├── .env.example                     # All required environment variables documented
├── .gitignore                       # Exclude secrets, node_modules, dist
│
├── install/
│   ├── vps-bootstrap.sh             # One-shot server setup (Docker, Node, pnpm, Nginx, Fail2ban)
│   ├── install-paperclip.sh         # Clone, configure, and start Paperclip
│   ├── install-openclaw.sh          # Install openclaw daemon + browser deps
│   ├── install-hermes.sh            # Install hermes-agent daemon
│   ├── install-qdrant.sh            # Start Qdrant container + run book indexing
│   └── verify.sh                    # Health check — confirms all 4 services are running
│
├── config/
│   ├── paperclip/
│   │   ├── company.json             # "Ben Ariel Publishing Co." — mission, goals, budget caps
│   │   ├── agents.json              # Agent definitions: Hermes (API), OpenClaw (browser)
│   │   └── routines.json            # Scheduled heartbeat config per agent
│   ├── openclaw/
│   │   ├── openclaw.json            # Gateway config, channel credentials, browser settings
│   │   ├── SOUL-public.md           # Ben Ariel public persona (posts AS the author)
│   │   ├── SOUL-dm.md               # Assistant persona (private outreach on behalf of author)
│   │   └── accounts/
│   │       ├── reddit.json          # Reddit account credentials + warm-up state
│   │       ├── twitter.json         # Twitter/X account credentials
│   │       └── discord.json         # Discord bot token + guild allowlist
│   └── hermes/
│       ├── system-prompt.md         # Core Hermes identity + book knowledge injection
│       └── models.json              # Model selection via OpenRouter + failover config
│
├── skills/
│   ├── README.md                    # How to write and install skills
│   ├── reddit-post/
│   │   ├── SKILL.md                 # Step-by-step browser instructions for Reddit posting
│   │   └── anti-ban-rules.md        # Reddit-specific behavioral rules injected into skill
│   ├── twitter-post/
│   │   ├── SKILL.md                 # Twitter/X posting via browser
│   │   └── anti-ban-rules.md        # Twitter-specific behavioral rules
│   ├── discord-engage/
│   │   └── SKILL.md                 # Discord community participation instructions
│   ├── influencer-scout/
│   │   └── SKILL.md                 # Browser-based influencer discovery workflow
│   ├── dm-outreach/
│   │   └── SKILL.md                 # DM flow: first contact in assistant persona, follow-up
│   └── book-voice/
│       └── SKILL.md                 # Ben Ariel voice guidelines + book content reference
│
├── plugins/
│   ├── README.md                    # Paperclip plugin API reference
│   ├── anti-ban-guard/
│   │   ├── index.ts                 # Paperclip plugin: enforces rate limits before task dispatch
│   │   ├── platform-rules.ts        # Per-platform posting limits, timing, account age gates
│   │   ├── account-health.ts        # Monitors shadow-ban signals, karma thresholds
│   │   └── fingerprint.ts           # Browser profile rotation, IP consistency checks
│   ├── link-generator/
│   │   ├── index.ts                 # Calls web reader app API to generate tracked links
│   │   └── tracker.ts               # Records link delivery in Paperclip audit log
│   └── human-in-loop/
│       ├── index.ts                 # Intercepts public posts, queues for board approval
│       └── notify.ts                # Pushes approval request to Paperclip dashboard + WhatsApp
│
├── qdrant/
│   ├── README.md                    # How book indexing works, how to re-index
│   ├── index-books.ts               # Chunks all 4 books and upserts into Qdrant collections
│   ├── query.ts                     # Utility: test semantic search against book collections
│   └── collections.json             # Qdrant collection config per book
│
├── books/
│   ├── el-ruido-que-llamas-mente.txt
│   ├── el-rey-que-buscaba-a-dios.txt
│   ├── shaar-habitajon.txt
│   └── la-guia-de-los-que-buscan.txt
│
├── docker/
│   ├── docker-compose.yml           # Full stack: all 4 services + Postgres
│   ├── docker-compose.dev.yml       # Local dev override
│   └── nginx.conf                   # Reverse proxy + SSL termination for dashboard access
│
├── scripts/
│   ├── warm-up-accounts.ts          # Runs account warm-up sequence for new social accounts
│   ├── export-company.sh            # Exports Paperclip company config for backup/portability
│   └── backup-db.sh                 # Postgres backup script for daily cron
│
└── docs/
    ├── architecture.md              # Full system architecture diagram + data flows
    ├── anti-ban-playbook.md         # Per-platform rules, account management, recovery procedures
    ├── persona-guide.md             # Ben Ariel voice guidelines for skills and Hermes prompts
    ├── partnership-funnel.md        # Partnership lifecycle: scout → DM → follow-up → deal
    ├── budget-guide.md              # How to set and adjust Paperclip budgets per agent
    └── operations-runbook.md        # Daily monitoring, incident response, escalation paths
```

---

## Docker Compose — Single File, Everything Runs Together

```yaml
version: "3.9"
services:

  paperclip:
    image: paperclipai/paperclip:latest
    ports:
      - "3100:3100"   # API
      - "3101:3101"   # Dashboard
    environment:
      - DATABASE_URL=postgresql://postgres:${DB_PASS}@db:5432/benariel
    depends_on:
      - db
    volumes:
      - ./config/paperclip:/app/company

  openclaw:
    image: openclaw/openclaw:latest
    ports:
      - "18789:18789"
    environment:
      - PAPERCLIP_URL=http://paperclip:3100
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
    volumes:
      - ./books:/workspace/books
      - ./skills:/workspace/skills
      - ./config/openclaw:/workspace/config

  hermes:
    image: nousresearch/hermes-agent:latest
    ports:
      - "4000:4000"
    environment:
      - PAPERCLIP_URL=http://paperclip:3100
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
      - QDRANT_URL=http://qdrant:6333
    volumes:
      - ./config/hermes:/workspace/config
      - ./config/openclaw/SOUL-public.md:/workspace/soul/SOUL.md

  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
    volumes:
      - ./qdrant_storage:/qdrant/storage

  db:
    image: postgres:16
    environment:
      - POSTGRES_PASSWORD=${DB_PASS}
      - POSTGRES_DB=benariel
    volumes:
      - ./pgdata:/var/lib/postgresql/data
```

---

## Phase 1 — Infrastructure (Week 1)

### Goal
All four services running on VPS, communicating with each other. No automation active.

**1.1 VPS Bootstrap**

Run `install/vps-bootstrap.sh` on a fresh Ubuntu 24.04 Hetzner VPS (minimum CX21: 2 vCPU, 4GB RAM). Installs:
- Docker + Docker Compose
- Node.js 24 + pnpm 9.15+
- Chromium + browser dependencies for OpenClaw
- Nginx + Certbot for HTTPS on dashboard
- Fail2ban + UFW firewall baseline

**1.2 Start All Services**

```bash
cp .env.example .env       # Fill in API keys and credentials
make install               # Runs docker compose up -d for all 5 containers
make verify                # Confirms all services respond and can reach each other
```

**1.3 Book Indexing**

```bash
make index-books           # Runs qdrant/index-books.ts
                           # Chunks all 4 books, embeds via OpenRouter, upserts into Qdrant
                           # Creates one Qdrant collection per book
                           # Run once at setup; re-run if books are updated
```

This gives both OpenClaw (via Qdrant query skill) and Hermes (via QDRANT_URL env) semantic access to all four books. Every content generation task retrieves relevant passages before drafting.

**1.4 Register Agents in Paperclip**

In the Paperclip dashboard (port 3101):
- Create company: "Ben Ariel Publishing Co."
- Mission: "Build dominant online presence for David ben Ariel's books across Jewish, spiritual, and philosophy communities and convert traffic to book sales."
- Register OpenClaw as employee — task types: `browser_post`, `browser_scout`, `dm_send`, `file_read`
- Register Hermes as employee — task types: `content_draft`, `influencer_score`, `dm_draft`, `qdrant_query`
- Set daily budgets per agent (see budget section below)
- Enable human-in-loop plugin for all tasks tagged `public_post`

---

## Phase 2 — Skills & Plugins (Week 2)

### Goal
Write the skill files and build the plugins that give agents their actual capabilities. Nothing posts to social media yet.

### Skills to Write (Plain English Markdown Files)

**`skills/book-voice/SKILL.md`** — The most important file in the entire system. Written first because all other skills reference it. Defines ben Ariel's tone (scholarly, Torah-grounded, passionate but measured), vocabulary patterns drawn from the four books, topics he speaks about with authority, topics he avoids, and how he engages with critics. Hermes uses this as its primary persona constraint on every content task.

**`skills/reddit-post/SKILL.md`** — Instructs OpenClaw's browser to: navigate to a specified Reddit thread URL, read top comments for context, determine the most relevant point to engage, compose a reply in ben Ariel's voice that adds genuine value, and submit. The `anti-ban-rules.md` companion injects timing randomization, scroll behavior, character-limit awareness, and account-age gating.

**`skills/twitter-post/SKILL.md`** — Same pattern for Twitter/X. Handles both thread replies and standalone posts. Includes follower-count threshold rules (engage only accounts over 500 followers for outreach efficiency).

**`skills/discord-engage/SKILL.md`** — Instructs OpenClaw's native Discord channel to participate in server conversations: identify relevant threads in configured guilds, contribute genuine insights, never self-promote in first 3 messages of any thread.

**`skills/influencer-scout/SKILL.md`** — Instructs OpenClaw to search for accounts in target niches (Jewish spirituality, Torah study, philosophy, Spanish-language spiritual content), capture their handle, follower count, engagement signals, and return a structured list to Hermes for scoring.

**`skills/dm-outreach/SKILL.md`** — The most sensitive skill. Uses the `SOUL-dm.md` assistant persona — never ben Ariel directly. Sends first contact DM, includes the free reading link generated by the link-generator plugin, and schedules a follow-up task in Paperclip if no response after 7 days.

### Plugins to Build (TypeScript, Claude Code writes these)

**`plugins/anti-ban-guard/`** — The most critical plugin. Intercepts every task dispatch from Paperclip before it reaches OpenClaw. Checks:
- Account age (rejects promotional tasks if account under 30 days old)
- Platform rate limit (token bucket per account per platform)
- Time since last post (enforces minimum gaps per platform)
- Content pattern (flags if last 3 posts were promotional)

If any check fails, the task is **requeued for the next heartbeat**, not rejected — no actions are lost.

**`plugins/link-generator/`** — Calls the web reader app's agent API endpoint to generate a time-limited free reading link or a tracked referral link. Logs every generated link in Paperclip's audit trail before delivery. Associates link with the influencer's handle for tracking.

**`plugins/human-in-loop/`** — Intercepts all tasks tagged `public_post` and holds them in a pending queue. Pushes an approval notification to your WhatsApp number via OpenClaw's native WhatsApp channel. You receive the draft post text and approve or reject with a reply. Approved posts are dispatched to OpenClaw for execution. Rejected posts are flagged and sent back to Hermes for revision. All approval decisions are logged in Paperclip's audit trail.

---

## Phase 3 — Account Warm-Up (Week 3–4)

### Goal
Social accounts become trusted by platforms before any book-related content is posted.

Run `scripts/warm-up-accounts.ts` which manages a state machine per account. The anti-ban-guard plugin enforces these states automatically — no manual tracking required.

| Day Range | Allowed Activity | Book Mentions |
|---|---|---|
| Day 1–7 | Read only, upvote, follow | None |
| Day 8–14 | Reply to non-book threads, generic helpful comments | None |
| Day 15–21 | Post original non-promotional content in target communities | None |
| Day 22–30 | Contextual book mentions permitted (1 per day max) | Soft, contextual only |
| Day 31+ | Full posting schedule active | Per platform limits |

During this phase, Hermes generates 10–15 sample posts per week for your review. These are not posted — they are voice calibration drafts. You review them, note any voice deviations, and update `SOUL-public.md` accordingly before activation.

---

## Phase 4 — Activation (Week 5–6)

### Goal
Full autonomous operation begins. Human-in-loop approval active for all public posts.

### Posting Schedule (Enforced by Paperclip Heartbeats + Anti-Ban-Guard)

| Platform | Daily Posts | Heartbeat Interval | Agent |
|---|---|---|---|
| Reddit | 3–5 replies | Every 3 hours | OpenClaw (browser) |
| Twitter/X | 5–8 posts/replies | Every 2 hours | OpenClaw (browser) |
| Discord | 4–6 messages | Every 2 hours | OpenClaw (native channel) |
| Facebook groups | 2–3 replies | Every 4 hours | OpenClaw (browser) |

### Task Flow for Every Public Post

```
1. Paperclip schedules task: "Find and reply to relevant thread on r/Judaism"
   ↓
2. OpenClaw scans Reddit, identifies thread, sends thread URL + top comments to Paperclip as ticket
   ↓
3. Paperclip assigns ticket to Hermes: "Draft reply in ben Ariel voice"
   ↓
4. Hermes queries Qdrant: retrieves relevant passages from the 4 books
   ↓
5. Hermes drafts reply using passages + SOUL-public.md constraints
   ↓
6. Human-in-loop plugin sends draft to your WhatsApp: "Approve / Reject / Edit"
   ↓
7. You approve with a WhatsApp reply
   ↓
8. Paperclip marks ticket approved, dispatches to OpenClaw
   ↓
9. OpenClaw posts via authenticated browser session
   ↓
10. Paperclip logs full action chain in immutable audit log
    Hermes saves a self-generated skill note: what worked, what to repeat
```

### Partnership Outreach (Automated — No Approval Required for DMs)

- Hermes scores influencer list (generated by scout skill) daily
- Top 3 candidates per day receive free reading link via DM in assistant persona
- All DMs logged in Paperclip audit trail and link tracker
- Follow-up triggered automatically by Hermes 7 days after link sent (one reminder at day 14, then archived)

---

## Phase 5 — Monitoring & Long-Term Operations (Month 2+)

### Daily Operator Workflow (10–15 minutes)

1. Check WhatsApp for pending post approvals (expected 5–15 per day)
2. Open Paperclip dashboard to review overnight audit log
3. Check anti-ban-guard rejection log — any account nearing rate limits?
4. Review weekly Hermes self-improvement report (auto-generated every Monday): which skills improved, which posts got highest engagement signals

### Makefile Commands

```makefile
make install        # Full VPS setup from scratch (docker compose + all services)
make start          # Start all services
make stop           # Gracefully stop all services
make status         # Health check all four services
make logs           # Tail logs from all services
make backup         # Backup Postgres to local archive
make warm-up        # Run account warm-up sequence
make index-books    # Re-index book content into Qdrant
make export-company # Export Paperclip company template (backup/portability)
make update         # Pull latest upstream for all repos + rebuild
```

### Environment Variables (`.env.example`)

```bash
# Database
DB_PASS=your_postgres_password

# OpenRouter (single key, routes to Claude/GPT/Hermes models)
OPENROUTER_API_KEY=

# Social account credentials
OPENCLAW_REDDIT_USER=
OPENCLAW_REDDIT_PASS=
OPENCLAW_TWITTER_USER=
OPENCLAW_TWITTER_PASS=
OPENCLAW_DISCORD_TOKEN=
OPENCLAW_WHATSAPP_NUMBER=+1XXXXXXXXXX    # Your WhatsApp for approvals

# Web reader app
READER_APP_URL=https://your-reader-app.com
READER_AGENT_API_KEY=

# Budget caps (USD per day — enforced by Paperclip)
BUDGET_OPENCLAW_DAILY=1.50
BUDGET_HERMES_DAILY=4.00
```

---

## Budget Structure

| Agent | Task Type | Daily Budget | Monthly Cap |
|---|---|---|---|
| OpenClaw | Browsing + posting | $1.50 | $45 |
| Hermes | Content + reasoning | $4.00 | $120 |
| Qdrant | Self-hosted, no per-query cost | $0 | $0 |
| **Total** | | **$5.50/day** | **$165/month** |

Paperclip enforces these caps atomically. Agents stop when the cap is hit and resume the next day. A WhatsApp notification is sent when any agent hits 80% of its daily budget.

---

## Architecture Data Flow

```
YOU (board — WhatsApp + Paperclip dashboard)
    │
    │  approve/reject public posts via WhatsApp reply
    │  monitor audit log and budgets via dashboard
    ▼
PAPERCLIP (port 3100/3101)
    │  assigns tickets by task type
    │  enforces daily budgets atomically
    │  immutable audit log of all agent actions
    │  routes approvals to your WhatsApp
    │
    ├──────────────────────────────────────────┐
    │                                          │
    ▼                                          ▼
HERMES-AGENT (port 4000)              OPENCLAW (port 18789)
    │  API-based reasoning                  │  browser automation
    │  drafts content in ben Ariel voice    │  authenticated sessions
    │  queries Qdrant for book passages     │  Reddit / Twitter / Discord
    │  scores influencers                   │  DM delivery
    │  self-improves skills from tasks      │  reads book files via PDF tool
    │                                       │
    └──────────────┬────────────────────────┘
                   │
                   ▼
            QDRANT (port 6333)
            4 book collections
            semantic retrieval
                   │
                   ▼
            POSTGRES (Paperclip DB)
            audit log, tickets,
            company state
                   │
                   ▼
            WEB READER APP API
            (free links + tracked referral links)
```

---

## Critical Rules Enforced by This Repository

1. **No account under 30 days old posts promotional content** — enforced by anti-ban-guard plugin, cannot be overridden by any agent
2. **No public post goes live without your WhatsApp approval** — enforced by human-in-loop plugin at Paperclip governance layer
3. **Agents never have direct admin panel access** — all reader app interactions go through scoped `link-generator` plugin with a single restricted API key
4. **One Chrome profile per platform account, never shared** — enforced by OpenClaw browser config
5. **Daily budget caps are hard limits** — Paperclip atomic enforcement stops agents when cap is reached, no exceptions
6. **All generated links are logged before delivery** — link-generator plugin writes to audit trail before dispatching to OpenClaw
7. **DMs always use assistant persona, public posts always use author persona** — enforced by separate SOUL files loaded per task type: `SOUL-dm.md` for outreach, `SOUL-public.md` for public posts

---

## Technical Enhancements & Safety Controls

1. **E2E Testing & Staging Mode**: The `Makefile` includes a `make test-e2e` command which puts OpenClaw into a dry-run mode. Browser flows will navigate and draft, but "submit" clicks are skipped and logged instead. This ensures safe verification without risking accounts.
2. **Analytics & Conversion Feedback**: Hermes ingests a weekly analytics report from the Reader App, comparing link tracking IDs against actual reads to optimize outreach strategy towards conversions, not just engagement.
3. **Disaster Recovery**: A `make restore` command is available to recover Postgres dumps and Qdrant volume backups in case of VPS failure.
4. **Legal Compliance (Opt-outs)**: An `inbox-triage` plugin runs before following up on DMs. If a user has replied with negative sentiment or asked to opt out, the 7-day follow-up task is permanently aborted and logged.
5. **Dependency Locking**: All Docker images in `docker-compose.yml` use explicitly pinned versions instead of `:latest` to prevent upstream breaking changes from affecting the operation.
6. **Approval Timeouts**: Any WhatsApp approval request pending for more than 24 hours is automatically archived by Paperclip to prevent stale queues.

---

## Risk Register

| Risk | Probability | Mitigation |
|---|---|---|
| Platform account ban | Medium | Anti-ban-guard plugin + 30-day warm-up + rate limits per account |
| Agent voice drift from ben Ariel style | Medium | Monthly review of 5 random posts; SOUL-public.md update if drift detected |
| Runaway token spend | Low | Paperclip atomic budget caps — hard stop, no exceptions |
| LLM generates factual error about books | Low | Human-in-loop approval for all public posts before anything goes live |
| VPS goes down | Low | Systemd service auto-restart + weekly Postgres backups via `make backup` |
| Platform UI change breaks OpenClaw skill | Medium | Subscribe to OpenClaw changelog; update SKILL.md when UI changes |

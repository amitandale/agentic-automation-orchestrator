# Agentic Automation Orchestrator

Orchestration layer for multi-agent content automation on a self-hosted VPS. Coordinates a reasoning agent (Hermes), a browser-automation agent (OpenClaw), a vector store (Qdrant), and a governance layer (Paperclip) through a single `make` command interface.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Operator (WhatsApp + Dashboard)                        │
│  approve/reject posts, monitor budgets & audit log      │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────┐
│  Paperclip  (port 3100 API / 3101 Dashboard)             │
│  governance · budgets · audit log · approval routing     │
├────────────────────┬─────────────────────────────────────┤
│                    │                                     │
│    ┌───────────────▼──────────┐  ┌───────────────────┐  │
│    │  Hermes-Agent (port 4000)│  │ OpenClaw (18789)   │  │
│    │  content drafting        │  │ browser automation  │  │
│    │  influencer scoring      │  │ social posting      │  │
│    │  Qdrant queries          │  │ DM delivery         │  │
│    └───────────┬──────────────┘  └───────────┬────────┘  │
│                │                             │           │
│                └──────────┬──────────────────┘           │
│                           ▼                              │
│              ┌────────────────────────┐                  │
│              │  Qdrant (port 6333)    │                  │
│              │  semantic book search  │                  │
│              └────────────────────────┘                  │
└──────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# 1. Clone and configure
git clone <repo-url> && cd agentic-automation-orchestrator
cp .env.example .env   # Fill in your API keys

# 2. Bootstrap VPS (Ubuntu 24.04)
make bootstrap

# 3. Start all services
make start

# 4. Verify connectivity
make verify

# 5. Index content into vector store
make index-books
```

## Makefile Commands

| Command | Description |
|---|---|
| `make bootstrap` | One-shot VPS setup (Docker, Node, Nginx, firewall) |
| `make start` | Start all services via docker compose |
| `make stop` | Gracefully stop all services |
| `make restart` | Stop then start |
| `make status` | Health check all services |
| `make logs` | Tail logs from all containers |
| `make verify` | Confirm inter-service connectivity |
| `make index-books` | Index content files into Qdrant |
| `make warm-up` | Run account warm-up state machine |
| `make backup` | Backup Postgres + Qdrant to archive |
| `make restore` | Restore from backup archive |
| `make export-company` | Export governance config for portability |
| `make test-e2e` | Dry-run browser flows (no actual submissions) |
| `make update` | Pull latest images + rebuild |

## Directory Structure

```
├── install/          # VPS bootstrap & per-service installers
├── config/           # Service configuration (Paperclip, OpenClaw, Hermes)
├── skills/           # Agent skill definitions (markdown instructions)
├── qdrant/           # Vector store indexing & query utilities
├── docker/           # Compose overrides & nginx config
├── scripts/          # Operational scripts (warm-up, backup, restore)
├── docs/             # Architecture docs, playbooks, runbooks
└── books/            # Content files (git-ignored, added on server)
```

## Environment Variables

See [.env.example](.env.example) for all required configuration. Never commit `.env` — it is git-ignored.

## Key Skills

| Skill | Purpose |
|---|---|
| `book-voice` | Author persona and voice guidelines (referenced by all other skills) |
| `reddit-post` | Reddit thread engagement with anti-ban rules |
| `twitter-post` | Twitter/X posting and replies with anti-ban rules |
| `discord-engage` | Discord community participation |
| `influencer-scout` | Browser-based influencer discovery |
| `dm-outreach` | Direct message outreach with opt-out handling |
| `link-generator` | Tracked link generation via reader app (placeholder) |

## Governance

Human-in-the-loop approval, budget enforcement, and audit logging are handled natively by **Paperclip** — configured via `config/paperclip/`. No custom governance code is needed.

## License

Private — all rights reserved.

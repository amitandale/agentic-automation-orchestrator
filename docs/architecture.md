# Architecture

## System Overview

The orchestrator coordinates four independent services through a central governance layer (Paperclip). No service communicates directly with another except through Paperclip-managed tickets.

```
┌─────────────────────────────────────────────────────────┐
│  Operator (WhatsApp + Dashboard)                        │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────────────────┐
│  Paperclip  (port 3100 API / 3101 Dashboard)             │
│  • Ticket assignment by task type                        │
│  • Atomic daily budget enforcement                       │
│  • Immutable audit log                                   │
│  • WhatsApp approval routing                             │
│  • Plugin execution (anti-ban-guard, human-in-loop)      │
├────────────────────┬─────────────────────────────────────┤
│                    │                                     │
│    ┌───────────────▼──────────┐  ┌───────────────────┐  │
│    │  Hermes-Agent (port 4000)│  │ OpenClaw (18789)   │  │
│    │  • Content drafting      │  │ • Browser sessions  │  │
│    │  • Influencer scoring    │  │ • Social posting    │  │
│    │  • Qdrant queries        │  │ • DM delivery       │  │
│    │  • Self-improving skills │  │ • Link generation   │  │
│    └───────────┬──────────────┘  └───────────┬────────┘  │
│                └──────────┬──────────────────┘           │
│                           ▼                              │
│              ┌────────────────────────┐                  │
│              │  Qdrant (port 6333)    │                  │
│              │  Semantic book search  │                  │
│              └────────────────────────┘                  │
└──────────────────────────────────────────────────────────┘
           Postgres (port 5432) backs Paperclip
```

## Data Flow: Public Post

1. Paperclip heartbeat triggers a content task
2. OpenClaw scans target platform, identifies engagement opportunity
3. Paperclip routes to Hermes for content drafting
4. Hermes queries Qdrant for relevant source passages
5. Hermes drafts reply using voice constraints
6. Human-in-loop plugin sends draft to WhatsApp
7. Operator approves/rejects
8. On approval: Paperclip dispatches to OpenClaw
9. OpenClaw posts via authenticated browser session
10. Full action chain logged in Paperclip audit trail

## Data Flow: DM Outreach

1. OpenClaw runs influencer scout skill (daily)
2. Hermes scores candidates
3. OpenClaw generates tracked link via reader app skill
4. OpenClaw sends DM using assistant persona
5. inbox-triage plugin checks for opt-outs before follow-ups
6. Positive responses escalated to operator

## Network Topology

All services run on a single Docker bridge network (`orchestrator-net`). External access is restricted to:
- Port 443 (Nginx → Paperclip dashboard)
- Port 80 (HTTP redirect to HTTPS)

All other ports are internal-only.

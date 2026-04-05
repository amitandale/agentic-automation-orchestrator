# Budget Guide

## Budget Structure

| Agent | Task Type | Daily Budget | Monthly Cap |
|---|---|---|---|
| OpenClaw | Browsing + posting | $1.50 | $45 |
| Hermes | Content + reasoning | $4.00 | $120 |
| Qdrant | Self-hosted (no cost) | $0 | $0 |
| **Total** | | **$5.50/day** | **$165/month** |

## How Budget Enforcement Works

Paperclip enforces budgets **atomically**:
1. Before dispatching any task, Paperclip checks the agent's remaining daily budget.
2. If the task's estimated cost exceeds the remaining budget, the task is **requeued** for the next day.
3. Agents stop when the cap is hit and resume the next day.
4. A WhatsApp notification is sent when any agent hits **80%** of its daily budget.

## Adjusting Budgets

Budgets are configured in two places:
1. **`.env`**: `BUDGET_OPENCLAW_DAILY` and `BUDGET_HERMES_DAILY` — used by docker compose
2. **`config/paperclip/agents.json`**: Per-agent budget objects — used by Paperclip internally

Both must be updated together when changing budgets.

## Cost Estimation

| Task Type | Estimated Cost |
|---|---|
| Content draft (Claude Sonnet) | ~$0.05–0.15 per draft |
| Influencer scoring (Haiku) | ~$0.01 per candidate |
| Qdrant query (embedding) | ~$0.001 per query |
| Browser session (OpenClaw) | ~$0.10 per session |
| DM draft (Claude Sonnet) | ~$0.03 per message |

## Budget Alerts

- **80% threshold**: WhatsApp notification sent
- **100% cap**: Agent stops, tasks requeued for next day
- **Monthly cap**: Hard stop for the rest of the calendar month

## Scaling Up

To increase throughput:
1. Increase daily budgets in `.env` and `agents.json`
2. Adjust heartbeat intervals in `config/paperclip/routines.json`
3. The anti-ban-guard plugin's rate limits are the real ceiling — increasing budget without relaxing platform rules will just cause more requeues

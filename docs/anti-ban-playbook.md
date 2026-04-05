# Anti-Ban Playbook

## General Principles

1. **Patience over speed** — Warm-up periods are non-negotiable.
2. **Quality over quantity** — A single valuable reply outweighs 10 generic ones.
3. **Consistency over bursts** — Steady daily activity, never post-and-disappear.
4. **One profile per platform per account** — Never share browser profiles.

## Per-Platform Rules

### Reddit

| Metric | Limit |
|---|---|
| Min gap between posts | 15 minutes |
| Max posts per hour | 3 |
| Max posts per day | 5 |
| Max same-subreddit per day | 2 |
| Account age for promo content | 30 days |

**Shadow-ban detection**: After posting, check comment visibility in incognito. If invisible, halt all activity for 72 hours.

### Twitter/X

| Metric | Limit |
|---|---|
| Min gap between tweets | 10 minutes |
| Max tweets per hour | 5 |
| Max tweets per day | 8 |
| Min follower count for engagement | 500 |
| Account age for promo content | 30 days |

**Rate limit detection**: If Twitter returns a rate limit warning, halt for 1 hour. If account is locked, do NOT attempt automated unlock.

### Discord

| Metric | Limit |
|---|---|
| Min gap between messages | 10 minutes |
| Max messages per day | 6 |
| No self-promo in first N messages | 3 per thread |
| Account age for book mentions | 21 days |

### Facebook Groups

| Metric | Limit |
|---|---|
| Min gap between posts | 20 minutes |
| Max posts per hour | 2 |
| Max posts per day | 3 |
| Account age for promo content | 30 days |

## Account Recovery

If an account is suspended:
1. Do NOT create a new account immediately (IP linking risk)
2. Log the suspension in Paperclip audit trail
3. Wait 7 days before any action
4. If platform offers an appeal, submit manually (never automated)
5. Update the warm-up state to reset the clock

## Content Pattern Rules

- If last 3 posts were promotional → next 2 must be purely value-adding
- Never use the same opening phrase twice within 24 hours
- Vary reply length across the distribution: short/medium/long

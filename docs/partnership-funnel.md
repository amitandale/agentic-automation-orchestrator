# Partnership Funnel

## Lifecycle Stages

```
Scout → Score → DM → Follow-Up → Archive/Deal
```

### 1. Scout (Daily — OpenClaw)
- OpenClaw runs `influencer-scout` skill daily at 09:00
- Scans target platforms for accounts in relevant niches
- Returns structured candidate list to Paperclip

### 2. Score (Daily — Hermes)
- Hermes evaluates candidates at 10:00
- Scoring criteria:
  - Topic alignment (0-10)
  - Follower count (weighted by platform)
  - Engagement quality (not just quantity)
  - Language match
  - Prior contact history
- Top 3 candidates per day selected for outreach

### 3. DM (Daily — OpenClaw)
- OpenClaw runs `dm-outreach` skill at 14:00
- Uses assistant persona (SOUL-dm.md)
- Generates tracked free reading link via reader app skill
- Sends personalized first-contact DM
- All messages logged in Paperclip audit trail

### 4. Follow-Up
- **Day 7**: If no response, send ONE follow-up (lighter, shorter)
- **Day 14**: If still no response, archive. Do not contact again.
- **inbox-triage plugin**: Checks for opt-out signals before every follow-up
- **Positive response**: Escalate to operator via WhatsApp

### 5. Archive/Deal
- Unresponsive contacts are archived after 14 days
- Positive contacts are escalated for manual operator handling
- All outcomes logged for analytics

## Metrics

| KPI | Target |
|---|---|
| Candidates scouted per week | 50-100 |
| DMs sent per week | 15-21 |
| Response rate | >15% |
| Positive response rate | >5% |
| Partnerships closed per month | 2-5 |

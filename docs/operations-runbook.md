# Operations Runbook

## Daily Operator Workflow (10–15 minutes)

### Morning Check
1. **WhatsApp**: Review and approve/reject pending post drafts (expect 5–15 per day)
2. **Dashboard**: Open Paperclip dashboard at `https://your-domain.com`
   - Review overnight audit log
   - Check budget consumption (should be <80% by midday)
3. **Anti-ban log**: Check for any requeued tasks or account warnings

### Weekly Review (Monday)
1. Review Hermes self-improvement report (auto-generated)
2. Check link tracking analytics from reader app
3. Review 5 random posts for voice consistency
4. Update `SOUL-public.md` if voice drift detected
5. Run `make backup` if not on daily cron

## Common Operations

### Restart All Services
```bash
make restart
```

### View Logs
```bash
make logs                              # All services
docker logs orchestrator-hermes -f     # Single service
```

### Re-Index Books
```bash
make index-books   # After updating any book file
```

### Add a New Social Account
1. Create account manually on the platform
2. Add config file to `config/openclaw/accounts/<platform>.json`
3. Run `make warm-up` to register in the state machine
4. Wait 30 days before enabling promotional content

### Emergency: Stop All Posting
```bash
make stop   # Stops all containers immediately
```

## Incident Response

### Account Suspended
1. Stop all tasks for that platform: update `config/openclaw/accounts/<platform>.json`
2. Log the suspension in Paperclip
3. Wait 7 days
4. If appeal is available, submit manually
5. See `docs/anti-ban-playbook.md` for full recovery procedure

### Budget Exceeded
- Paperclip handles this automatically — agent stops and resumes next day
- If systemic, review cost estimates in `docs/budget-guide.md`

### VPS Down
1. Check Hetzner status page
2. If hardware failure: provision new VPS, run `make bootstrap`
3. Clone this repo
4. Restore from backup: `make restore`
5. Verify: `make verify`

### Voice Drift Detected
1. Review sample posts
2. Update `config/openclaw/SOUL-public.md` with corrections
3. Hermes will use updated guidelines on next task

## Monitoring Endpoints

| Service | Health Check URL |
|---|---|
| Paperclip API | `http://localhost:3100/health` |
| Paperclip Dashboard | `http://localhost:3101` |
| OpenClaw | `http://localhost:18789/health` |
| Hermes-Agent | `http://localhost:4000/health` |
| Qdrant | `http://localhost:6333/healthz` |

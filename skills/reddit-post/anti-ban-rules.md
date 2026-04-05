# Reddit Anti-Ban Rules

These rules are injected as behavioral constraints into every Reddit browser session.

## Timing Controls

- **Minimum gap between posts**: 15 minutes
- **Maximum posts per hour**: 3
- **Maximum posts per day**: 5
- **Session duration**: 20–45 minutes (randomized)
- **Scroll before engaging**: At least 60 seconds of natural browsing before first action

## Typing Behavior

- Type at 40–80 WPM (randomized per session)
- Include natural pauses (200–800ms between words)
- Occasionally use backspace (simulate typo correction, ~5% of characters)
- Never paste large blocks of text

## Account Age Gates

| Account Age | Allowed Actions |
|---|---|
| 0–7 days | Browse, upvote only |
| 8–14 days | Reply to non-book threads only |
| 15–21 days | Post original non-promotional content |
| 22–30 days | Contextual mentions (1/day max) |
| 31+ days | Full posting schedule |

## Content Pattern Rules

- Never post to the same subreddit more than twice per day
- If last 3 posts were in any way promotional, next 2 must be purely value-adding
- Never use the same opening phrase twice in 24 hours
- Vary reply length: short (1–2 sentences), medium (3–5 sentences), long (6+ sentences) in roughly equal distribution

## Shadow-Ban Detection

- After posting, check if your comment appears when logged out (use incognito check)
- If comment is invisible: STOP all posting, flag account to anti-ban-guard, wait 72 hours
- Log all shadow-ban signals to Paperclip audit trail

## Browser Fingerprint

- Use dedicated Chrome profile for Reddit (never shared with other platforms)
- Maintain consistent IP address per session
- Do not change viewport size mid-session

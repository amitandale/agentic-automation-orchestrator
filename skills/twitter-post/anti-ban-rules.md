# Twitter/X Anti-Ban Rules

## Timing Controls

- **Minimum gap between tweets**: 10 minutes
- **Maximum tweets per hour**: 5
- **Maximum tweets per day**: 8
- **Session duration**: 15–40 minutes (randomized)
- **Scroll before engaging**: At least 45 seconds of natural browsing

## Account Age Gates

| Account Age | Allowed Actions |
|---|---|
| 0–7 days | Browse, like, retweet only |
| 8–14 days | Reply to trending/popular threads only |
| 15–21 days | Post original non-promotional tweets |
| 22–30 days | Contextual mentions (1/day max) |
| 31+ days | Full posting schedule |

## Content Pattern Rules

- Never tweet the same topic more than twice per day
- Alternate between replies and original tweets
- If last 3 tweets mentioned books, next 3 must be purely value-adding
- Include media (images, polls) in ~20% of tweets for engagement variety
- Engage only accounts with 500+ followers for outreach efficiency

## Rate Limit Detection

- If Twitter shows a rate limit warning: STOP all activity for 1 hour
- If account is locked: flag to anti-ban-guard, do not attempt unlock programmatically
- Log all warnings and locks to Paperclip audit trail

## Browser Fingerprint

- Dedicated Chrome profile for Twitter (never shared)
- Consistent resolution and language settings
- Accept cookies naturally on first visit

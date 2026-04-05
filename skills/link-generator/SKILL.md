# Link Generator — OpenClaw Skill (To Be Written)

This skill instructs OpenClaw to interact with the reader app API to generate tracked free reading links or referral links.

## Status: Placeholder

This skill will be implemented after the reader app's agent API is finalized. The skill should instruct OpenClaw to:

1. Call the reader app API endpoint with the target influencer's handle
2. Request a time-limited free reading link or tracked referral link
3. Log the generated link in Paperclip's audit trail
4. Return the link URL for inclusion in DM content

## Prerequisites
- Reader app agent API must be deployed and accessible
- `READER_APP_URL` and `READER_AGENT_API_KEY` must be set in `.env`

## Notes
- Every generated link must be logged BEFORE delivery
- Links should be associated with the influencer's handle for attribution tracking
- Links should have configurable expiration (default: 30 days)

# Post Review Checklist — Pre-Approval Self-Check

Before submitting any draft to the WhatsApp approval queue, the agent must evaluate the content against every item on this checklist. If any check fails, the draft must be revised before submission.

## Universal Checks (All Funnels)

### Voice Authenticity
- [ ] Does this sound like the author, or does it sound like a marketing account?
- [ ] Would a reader who knows the book recognize this as consistent with the author's voice?
- [ ] Is the tone diagnostic and precise (not motivational or generic)?

### Value Test
- [ ] Does this post give genuine value even if the reader never buys the book?
- [ ] Does it teach something, illuminate a mechanism, or ask a thought-provoking question?
- [ ] Would someone with zero interest in the book still find this reply worth reading?

### Funnel Integrity
- [ ] Does the content match the assigned funnel (`religious` or `secular`)?
- [ ] Are there any cross-funnel leaks? (Torah references in secular content, or self-help framing in religious content)

### Platform Compliance
- [ ] Does the content respect the platform's anti-ban rules? (Check the platform-specific `anti-ban-rules.md`)
- [ ] Is the content format appropriate for the platform? (280 chars for Twitter, long-form ok for Reddit)
- [ ] Does it respect the account's current warm-up stage?

### Language
- [ ] Is the content drafted natively in the detected language (not translated)?
- [ ] Does it read naturally to a native speaker of that language?

### Promotion Rules
- [ ] Is this a first interaction with this thread/user? If yes, is there ZERO self-promotion?
- [ ] If the post mentions the book, is it contextually relevant (someone asked about the topic)?
- [ ] Does the post avoid all marketing language? ("Must-read", "life-changing", "groundbreaking")

## Secular Funnel — Additional Checks

- [ ] Does the content avoid ALL prohibited self-help phrases? (See `book-voice-secular/SKILL.md` → Prohibited Phrases)
- [ ] Does it avoid offering "techniques", "steps", or "exercises"?
- [ ] Does it diagnose a mechanism rather than motivate?
- [ ] Does the Qdrant query filter include `funnel: "secular"`?

## Religious Funnel — Additional Checks

- [ ] Does the content avoid secular self-help framing?
- [ ] Are Hebrew/Aramaic terms used appropriately for the audience?
- [ ] Does the Qdrant query filter include `funnel: "religious"`?

## Reactive Comments — Additional Checks

- [ ] **THE GOVERNANCE TEST**: Does this comment make someone stop and think about themselves — or does it just make them feel something about the news? If the latter, rewrite.
- [ ] Is the comment in an approved category? (AI/Tech, Mental Health/Self-Help, Religion/Meaning)
- [ ] Is the comment observing the conversation from above, not participating in it?
- [ ] Does it diagnose a mechanism the crowd is not seeing?
- [ ] Is it under 280 characters (Twitter) or under 3 paragraphs (Reddit)?

## Failure Action

If any check fails:
1. Revise the draft to fix the failing item
2. Re-run the checklist
3. Only submit to approval queue when all checks pass
4. Log which checks failed on the first pass to Paperclip (helps improve future drafts)

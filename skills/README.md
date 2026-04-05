# Skills Directory

Skills are plain-English markdown instruction files that tell agents how to perform specific tasks. Each skill lives in its own subdirectory.

## Structure

```
skills/
├── book-voice/          # Author voice guidelines (referenced by all other skills)
├── reddit-post/         # Reddit thread engagement
├── twitter-post/        # Twitter/X posting and replies
├── discord-engage/      # Discord community participation
├── influencer-scout/    # Browser-based influencer discovery
└── dm-outreach/         # Direct message outreach flow
```

## How Skills Work

1. Paperclip schedules a task and assigns it to an agent.
2. The agent loads the relevant SKILL.md file for the task type.
3. The agent follows the step-by-step instructions in the SKILL.md.
4. Anti-ban rules (where present) are injected as behavioral constraints.

## Writing New Skills

1. Create a new directory under `skills/`.
2. Add a `SKILL.md` with clear, numbered step-by-step instructions.
3. Optionally add `anti-ban-rules.md` for platform-specific behavioral constraints.
4. Reference `book-voice/SKILL.md` for voice/tone consistency.

## Important

- Skills should read like instructions for a careful, intelligent assistant.
- Never include hardcoded credentials in skill files.
- Platform-specific timing and rate limits belong in `anti-ban-rules.md`, not in the SKILL.md itself.

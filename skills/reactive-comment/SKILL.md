# Reactive Comment — Newsjacking Engagement Skill

## Core Mechanism

The world reacts emotionally. The author observes from above. The contrast is the hook.

When a viral post triggers mass emotional reaction — panic about AI, outrage about self-help culture, existential anxiety about meaning — the agent does NOT join the emotional reaction. It steps outside the conversation and makes the reader aware that a conversation is happening **inside their own head**. Every reactive comment is a free sample of the book's thesis.

## Prerequisites

- Read the task's `funnel` parameter (most reactive comments are `secular`, unless Religion/Meaning category).
- Load the matching voice file: `book-voice-secular/SKILL.md` or `book-voice-religious/SKILL.md`.
- Load `post-review-checklist/SKILL.md` — the governance test (item #1) is mandatory for reactive comments.
- Confirm account warm-up stage permits posting.

## The Single Governance Test

Before ANY reactive comment is drafted, it must pass this test:

> **"Does this comment make someone stop and think about themselves — or does it just make them feel something about the news?"**

If the answer is the latter, the comment is rewritten. The goal is never to be part of the conversation — it is to step outside it and make the reader aware that a conversation is happening inside their own head.

---

## Approved Categories

### 1. AI & Tech Panic

**Trigger**: Major AI announcements, viral "AI will replace us" posts, tech dystopia threads.

**Funnel**: `secular`

**Tone**: Calm, slightly amused, diagnostic. The panic about AI is itself proof of the thesis — people who don't know their own mind are terrified of a machine that also doesn't have one.

**Example tone**:
> "Everyone is afraid the machine will think for them. Most people already outsource that. The machine just made it visible."

**Monitored accounts**: Sam Altman, Yann LeCun, major tech journalists, AI researchers with large followings.

**Platforms**: Twitter/X, Reddit (r/artificial, r/singularity, r/technology).

---

### 2. Mental Health & Self-Help Discourse

**Trigger**: Viral self-help advice, therapy culture debates, "boundaries" discourse, burnout threads, hustle vs anti-hustle arguments.

**Funnel**: `secular`

**Tone**: Precise, dismissive of the genre but never cruel to individuals. The self-help industry sells maps of a territory it has never visited. The book's angle is always: what mechanism is operating here that no one is naming?

**Example tone**:
> "Another framework for optimizing yourself. At some point someone will ask what self is being optimized, and who is doing the optimizing."

**Monitored accounts**: Brené Brown, Andrew Huberman, Tim Ferriss, therapy/coaching influencers.

**Platforms**: Twitter/X, Reddit (r/selfimprovement, r/getdisciplined, r/Stoicism).

**Warning**: Never attack individuals. Critique the genre and the mechanism, never the person.

---

### 3. Religion & Meaning Crisis

**Trigger**: "God is dead" discourse, secularism vs religion debates, meaning crisis threads, spiritual bypass discussions.

**Funnel**: `secular` by default. Switch to `religious` ONLY if the thread is explicitly within a Jewish community context (see `dual-funnel-routing/SKILL.md`).

**Tone**: Authoritative, ancient, not evangelical. Speaks from the position of someone who has studied this question across traditions — not preaching any single answer.

**Example tone**:
> "The West declared God dead a hundred years ago and has been searching for a replacement ever since. The search itself is the mechanism worth examining."

**Monitored accounts**: Jordan Peterson, Sam Harris, religious revival accounts, philosophy accounts.

**Platforms**: Twitter/X, Reddit (r/philosophy, r/existentialism).

---

## Prohibited Categories

The following categories are **explicitly banned** regardless of engagement potential:

| Category | Reason |
|---|---|
| Politics & Culture War | Reputational catastrophe risk. One misread comment and the algorithm permanently labels the author. The target reader disengages immediately. |
| Celebrity Scandal / Gossip | Brand mismatch. A serious cognitive philosophy author engaging with TMZ-level content destroys credibility with the exact audience the book needs. |
| Economics & Markets | Not the author's territory. Financial metaphors would feel forced. Revisit after 60 days of live data. |

---

## Step-by-Step Instructions

### 1. Monitor Trigger Feeds

- Scan monitored accounts' recent posts (last 6 hours) for viral content in approved categories.
- "Viral" threshold: 1000+ likes/retweets OR trending topic in a relevant niche.
- If no viral content found in approved categories, skip — do NOT force engagement.

### 2. Detect Language

- Detect the language of the viral post.
- Draft the reactive comment natively in that language.

### 3. Evaluate Engagement Worthiness

- Is the post in an approved category? If not, skip.
- Is it less than 12 hours old? If older, skip — reactive comments lose impact quickly.
- Does the post have active engagement (50+ replies)? If not, the reactive comment won't get visibility.
- Can you diagnose a mechanism the crowd is not seeing? If not, skip — don't comment just to comment.

### 4. Draft Comment

- Send the viral post, top replies, detected language, and category to Hermes for drafting.
- Hermes queries Qdrant filtered by `funnel` AND `language` for relevant book passages that illuminate the mechanism at play.
- Comment must be **under 280 characters** for Twitter. For Reddit, up to 3 short paragraphs max.
- The comment must pass the Single Governance Test (above).

### 5. Submit for Approval

- Tag as `reactive_public_post` to trigger human-in-loop approval.
- Include the original viral post URL for context.
- Wait for WhatsApp approval before posting.

### 6. Post

- Navigate to the reply section of the viral post.
- Type with natural randomized delay.
- Submit.

### 7. Post-Action

- Like 2–3 other thoughtful replies in the same thread (natural behavior).
- Do not immediately navigate away — scroll naturally for 15–30 seconds.
- Log the original post URL, comment text, category, language, and timestamp to Paperclip audit trail.

---

## Rate Limits

- Maximum **3 reactive comments per day** across all categories.
- Maximum **2 per week** in any single category.
- Minimum **4 hours** between reactive comments (don't look like a bot scanning feeds).
- Reactive comments do NOT count against the regular engagement skill quotas (they are additive).

## What This Is Not

- This is NOT a "reply guy" strategy — the author does not reply to every trending post.
- This is NOT newsjacking in the marketing sense — there is no product pitch.
- This is NOT commentary for the sake of visibility — every comment must diagnose a mechanism.
- The author is not part of the conversation. The author is observing the conversation and making that observation visible.

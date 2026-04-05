# Twitter/X Post — Browser Engagement Skill

## Prerequisites
- Read the task's `funnel` parameter (`religious` or `secular`).
- Load the matching voice file: `book-voice-religious/SKILL.md` or `book-voice-secular/SKILL.md`.
- Load `twitter-post/anti-ban-rules.md` for behavioral rules.
- Confirm account warm-up stage permits posting.

## Step-by-Step Instructions

### 1. Navigate to Feed
- Open Twitter/X home feed or specified search query.
- Scroll naturally for 30–60 seconds, engaging with the feed like a human.

### 2. Find Engagement Targets
- If `funnel = religious`: Search for tweets about Torah, Jewish spirituality, philosophy, mysticism.
- If `funnel = secular`: Search for tweets about mindfulness, consciousness, self-improvement, personal growth.
- Prioritize tweets from accounts with 500+ followers for maximum reach.
- Look for tweets with active quote-tweet or reply threads.

### 3. Evaluate & Detect Language
- Is the tweet relevant to the task's funnel topics? If not, skip.
- Is it less than 24 hours old? Prefer fresh content.
- Would a reply add genuine value? If not, skip.
- **Detect the language** of the tweet — you will draft your reply in the same language.

### 4. Draft Content
- **For replies**: Send the original tweet, **detected language**, and **funnel** to Hermes for drafting.
- **For original posts**: Hermes drafts a standalone thought piece (queries Qdrant filtered by `funnel` + `language` first).
- All content must be under 280 characters OR use thread format (max 4 tweets).
- **Draft must be written natively in the detected language** — never translate.

### 5. Submit for Approval
- Tag as `public_post` to trigger human-in-loop.
- Wait for WhatsApp approval.

### 6. Post
- Navigate to the reply box or compose button.
- Type with natural randomized delay.
- Submit.
- If thread format: post each tweet sequentially with 5–10 second gaps.

### 7. Engagement Follow-Up
- Like 2–3 other replies in the same thread (natural behavior).
- Do not immediately navigate away.
- Log all actions (including language + funnel) to Paperclip audit trail.

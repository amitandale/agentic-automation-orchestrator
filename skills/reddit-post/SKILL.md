# Reddit Post — Browser Engagement Skill

## Prerequisites
- Read the task's `funnel` parameter (`religious` or `secular`).
- Load the matching voice file: `book-voice-religious/SKILL.md` or `book-voice-secular/SKILL.md`.
- Load `reddit-post/anti-ban-rules.md` for behavioral rules.
- Confirm account warm-up stage permits posting.

## Step-by-Step Instructions

### 1. Navigate to Target
- Open the specified subreddit URL or thread URL provided in the task.
- If no specific thread is given, browse the subreddit's "Hot" and "New" tabs for relevant threads.

### 2. Read Context & Detect Language
- Read the original post in full.
- Read the top 5–10 comments to understand the conversation flow.
- **Detect the primary language** of the thread (e.g., English, Spanish, Portuguese, etc.).
- Identify the most relevant point of engagement (a question, a misconception, or a topic you can add value to).

### 3. Evaluate Engagement Worthiness
- Is this thread relevant to the task's funnel topics? If `religious`: Torah, spirituality, mysticism. If `secular`: consciousness, mindfulness, self-improvement. If neither, skip.
- Is the thread less than 48 hours old? If not, skip (stale threads get less visibility).
- Does the thread have active engagement (3+ comments)? If not, consider skipping.
- Would a reply genuinely add value? If not, skip.

### 4. Draft Reply
- Send the thread URL, original post, top comments, **detected language**, and **funnel** to Hermes for drafting.
- Hermes queries Qdrant filtered by `funnel` AND `language` for relevant book passages.
- Reply must follow all voice constraints from the funnel-specific `book-voice-*` skill.
- **Reply must be drafted natively in the detected language** — never translate.

### 5. Submit for Approval
- Tag the draft as `public_post` to trigger human-in-loop approval.
- Wait for WhatsApp approval before posting.

### 6. Post
- After approval, navigate to the reply box in the thread.
- Type the approved reply (character by character with randomized delay).
- Submit the reply.
- Log the thread URL, reply content, language, funnel, and timestamp to Paperclip audit trail.

### 7. Post-Action
- Do not immediately navigate away — scroll naturally for 15–30 seconds.
- Log whether the post was successful or if any error occurred.

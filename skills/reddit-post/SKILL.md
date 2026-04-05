# Reddit Post — Browser Engagement Skill

## Prerequisites
- Load `book-voice/SKILL.md` for voice constraints.
- Load `reddit-post/anti-ban-rules.md` for behavioral rules.
- Confirm account warm-up stage permits posting (check with anti-ban-guard plugin).

## Step-by-Step Instructions

### 1. Navigate to Target
- Open the specified subreddit URL or thread URL provided in the task.
- If no specific thread is given, browse the subreddit's "Hot" and "New" tabs for relevant threads.

### 2. Read Context
- Read the original post in full.
- Read the top 5–10 comments to understand the conversation flow.
- Identify the most relevant point of engagement (a question, a misconception, or a topic you can add value to).

### 3. Evaluate Engagement Worthiness
- Is this thread relevant to the author's core topics? If not, skip.
- Is the thread less than 48 hours old? If not, skip (stale threads get less visibility).
- Does the thread have active engagement (3+ comments)? If not, consider skipping.
- Would a reply genuinely add value? If not, skip.

### 4. Draft Reply
- Send the thread URL, original post, and top comments to Hermes for drafting.
- Hermes queries Qdrant for relevant book passages before writing.
- Reply must follow all `book-voice/SKILL.md` constraints.

### 5. Submit for Approval
- Tag the draft as `public_post` to trigger human-in-loop approval.
- Wait for WhatsApp approval before posting.

### 6. Post
- After approval, navigate to the reply box in the thread.
- Type the approved reply (character by character with randomized delay).
- Submit the reply.
- Log the thread URL, reply content, and timestamp to Paperclip audit trail.

### 7. Post-Action
- Do not immediately navigate away — scroll naturally for 15–30 seconds.
- Log whether the post was successful or if any error occurred.

# Influencer Scout — Browser Discovery Skill

## Prerequisites
- Load target niche definitions from task parameters.
- No voice constraints needed (this is data collection, not content creation).

## Step-by-Step Instructions

### 1. Define Search Parameters
- Target niches: Jewish spirituality, Torah study, philosophy, consciousness, Spanish-language spiritual content.
- Platforms to scan: Twitter/X, Instagram (public profiles), YouTube, Reddit (active posters).

### 2. Search Execution
For each platform:
- Navigate to the platform's search function.
- Search for target keywords and hashtags.
- Identify accounts that post regularly about target topics.

### 3. Data Collection
For each discovered account, capture:
- **Handle/Username**: Platform-specific identifier
- **Display Name**: Public name
- **Follower Count**: Raw number
- **Engagement Rate**: (likes + comments) / followers on last 5 posts (approximate)
- **Posting Frequency**: Active daily, weekly, or monthly
- **Language**: Primary language of content
- **Topic Alignment**: How closely their content matches target niches (1–10 scale)
- **Platform**: Which platform they were found on

### 4. Output Format
Return a structured JSON list to Hermes for scoring:
```json
[
  {
    "handle": "@example",
    "platform": "twitter",
    "followers": 12500,
    "engagement_rate": 0.04,
    "posting_frequency": "daily",
    "language": "es",
    "topic_alignment": 8,
    "sample_post_url": "https://..."
  }
]
```

### 5. Filtering
- Exclude accounts with fewer than 500 followers.
- Exclude accounts that haven't posted in the last 30 days.
- Exclude accounts that are clearly bots or spam.
- Maximum 20 candidates per daily scan.

### 6. Logging
- Log all discovered candidates to Paperclip audit trail.
- Flag any accounts that were previously contacted (cross-reference with DM history).

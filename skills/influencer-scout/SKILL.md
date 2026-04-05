# Influencer Scout — Browser Discovery Skill

## Prerequisites
- Read the task's `funnel` parameter (`religious` or `secular`).
- No voice constraints needed (this is data collection, not content creation).

## Step-by-Step Instructions

### 1. Define Search Parameters

Based on the `funnel` parameter, search for different target audiences:

**If `funnel = religious`:**
- Target niches: Jewish spirituality, Torah study, Kabbalah, Chassidut, Mussar, Jewish philosophy, religious contemplative practice.
- Keywords/hashtags: `#TorahStudy`, `#Kabbalah`, `#JewishWisdom`, `#Chassidut`, `#JewishMysticism`, `#Torah`, `#Mussar`.
- Platforms to scan: Twitter/X, Instagram (public profiles), YouTube, Reddit (active posters in r/Judaism, r/Torah, r/JewishPhilosophy, etc.).

**If `funnel = secular`:**
- Target niches: Mindfulness, consciousness studies, self-improvement, personal growth, philosophy of mind, secular spirituality, inner work.
- Keywords/hashtags: `#Mindfulness`, `#SelfImprovement`, `#Consciousness`, `#InnerWork`, `#PersonalGrowth`, `#Philosophy`, `#Meditation`.
- Platforms to scan: Twitter/X, Instagram (public profiles), YouTube, Reddit (active posters in r/Meditation, r/SelfImprovement, r/Stoicism, r/Philosophy, etc.).

### 2. Search Execution
For each platform:
- Navigate to the platform's search function.
- Search for target keywords and hashtags (based on funnel above).
- Identify accounts that post regularly about target topics.

### 3. Data Collection
For each discovered account, capture:
- **Handle/Username**: Platform-specific identifier
- **Display Name**: Public name
- **Follower Count**: Raw number
- **Engagement Rate**: (likes + comments) / followers on last 5 posts (approximate)
- **Posting Frequency**: Active daily, weekly, or monthly
- **Language**: Primary language of content (ISO 639-1 code)
- **Topic Alignment**: How closely their content matches the funnel's target niches (1–10 scale)
- **Platform**: Which platform they were found on
- **Funnel**: The funnel this scout run is targeting (`religious` or `secular`)

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
    "funnel": "religious",
    "sample_post_url": "https://..."
  }
]
```

### 5. Filtering
- Exclude accounts with fewer than 500 followers.
- Exclude accounts that haven't posted in the last 30 days.
- Exclude accounts that are clearly bots or spam.
- Maximum 20 candidates per daily scan per funnel.

### 6. Logging
- Log all discovered candidates to Paperclip audit trail (tagged with funnel).
- Flag any accounts that were previously contacted (cross-reference with DM history).

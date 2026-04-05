# Dual-Funnel Routing — Decision Logic

This skill defines how the system determines which funnel (`religious` or `secular`) to assign to a task. Every engagement, scouting, and outreach task must have an explicit funnel before execution begins.

## Default Rule

**When ambiguous, always default to `secular`.** The secular voice is safer — it works universally without alienating anyone. The religious voice should only activate when there is a clear, unambiguous signal.

## Platform → Funnel Mapping

### Reddit

| Subreddit / Category | Funnel |
|---|---|
| r/Judaism, r/Torah, r/JewishPhilosophy, r/Kabbalah, r/Mussar | `religious` |
| r/Meditation, r/Mindfulness, r/Stoicism, r/Philosophy, r/getdisciplined, r/selfimprovement, r/DecidingToBeBetter | `secular` |
| r/books, r/nonfiction, r/suggestmeabook | `secular` (default) |
| Any subreddit not listed above | `secular` (default) |

### Twitter / X

| Signal | Funnel |
|---|---|
| Hashtags: #TorahStudy, #Kabbalah, #JewishWisdom, #Chassidut, #JewishMysticism | `religious` |
| Hashtags: #Mindfulness, #SelfImprovement, #Consciousness, #InnerWork, #PersonalGrowth, #Stoicism | `secular` |
| Account bio mentions Judaism, Torah, or Jewish practice | `religious` |
| Account bio mentions coaching, productivity, psychology, philosophy | `secular` |
| No clear signal | `secular` (default) |

### Discord

| Server Type | Funnel |
|---|---|
| Jewish learning, Torah study groups, synagogue community servers | `religious` |
| Philosophy, book clubs, self-improvement, meditation, psychology | `secular` |
| General interest / mixed | `secular` (default) |

### LinkedIn

Always `secular`. LinkedIn's professional context makes religious content inappropriate.

### WhatsApp

Funnel is determined by the contact list the message is sent to — operator configures this in Paperclip.

## Edge Case Rules

1. **Secular thread mentions Kabbalah or Torah**: Stay `secular`. The reader discovered the topic through a secular lens — respond in kind. Reference the concept using universal framing (e.g., "ancient contemplative traditions" rather than "Kabbalistic teaching").

2. **Religious community discusses mindfulness**: Stay `religious`. The reader is framing mindfulness through a Jewish lens — match their framing. Reference the concept using traditional terms (e.g., "hitbonenut" rather than "mindfulness meditation").

3. **Bilingual thread**: Match the language of the specific comment you are replying to, not the language of the original post.

4. **Cross-funnel content request**: If someone in a secular thread asks you to recommend Torah-related material, you may acknowledge the connection but do NOT switch voices. Say something like "That's a deep tradition worth exploring — there are excellent resources in that space" without adopting the religious persona.

5. **Influencer tagged with wrong funnel**: If an influencer's actual content contradicts their tagged funnel (e.g., tagged `religious` but posts primarily about generic productivity), re-tag them and use the correct funnel for outreach.

## How Paperclip Uses This

Paperclip routines already include a `funnel` parameter in every dispatched task. This document governs:
1. How the **operator** configures routines (which subreddits go in which routine)
2. How the **agent** should override if it encounters content that doesn't match the assigned funnel
3. The agent should log a `funnel_mismatch` event to Paperclip whenever it detects the assigned funnel doesn't match the actual content — this helps the operator refine the routine configuration.

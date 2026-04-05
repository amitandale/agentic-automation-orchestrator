# Book Voice — Persona Router

This is a routing file. The actual voice guidelines are split by funnel:

- **Religious Trilogy (Books 1–3)**: Load `book-voice-religious/SKILL.md`
- **Secular Self-Improvement (Book 4)**: Load `book-voice-secular/SKILL.md`

## How to Choose

Every task dispatched by Paperclip includes a `funnel` parameter:

| Funnel Value | Voice File to Load | Qdrant Filter | Books |
|---|---|---|---|
| `religious` | `book-voice-religious/SKILL.md` | `funnel: "religious"` | 1, 2, 3 |
| `secular` | `book-voice-secular/SKILL.md` | `funnel: "secular"` | 4 |

**Critical Rule**: Never mix content from different funnels. A secular audience must never receive Torah-specific framing, and a religious audience must never receive generic self-help framing.

## Language

Both funnels support all languages. The agent must:
1. Detect the language of the target thread/profile/conversation.
2. Filter Qdrant queries by both `funnel` AND `language`.
3. Draft content natively in the detected language.

# Vault Structure & Classification Rules

Reference for `/gtd-inbox-sweep`. The skill embeds these rules directly — this file is for human reference.

## Vault Layout

```
~/Documents/Obsidian Vault/
├── Tasks/
│   ├── Capture.md        # inbox
│   └── Classified.md     # sweep output
├── Projects/
│   └── *.md              # one per project
├── Daily/
├── Archive/
└── Templates/
    └── Daily note.md
```

## Task Output Format

```
- [ ] [[Projects/PROJEKT]] <actionable description> <priority> 📅 YYYY-MM-DD
  > oryginał: "<original text>"
```

Omit `📅` if no due date. Use `[[Projects/?]]` if project unknown.

## Project Assignment (priority order)

1. Manual heuristics (see below)
2. `## 🤖 Classifier hints` in project file
3. Context inference
4. Fallback: `[[Projects/?]]`

### Manual Heuristics

Configure these in `CLAUDE.md` for your actual projects. Example placeholders:

- **Cyberdyne** — config, env support, debug, logs for client Cyberdyne or its envs (DEV, UAT)
- **Initech-Internal** — internal eng: Presales, QA, DEV, sprint, gitlab, keycloak, jira (no external client named)
- **Initech** — platform dev: hazelcast, kafka, rabbitmq, spring boot, architecture, code review
- **Personal** — calls, appointments, purchases, private matters

## Actionable Description Rules

- Convert noun to verb: "whitelist IP" → "Skonfigurować IP whitelisting"
- Expand clear abbreviations/typos
- Preserve source language (PL/EN)
- Max 1 sentence

## Due Date Rules

| Hint | Resolves to |
|------|-------------|
| "dziś", "today", "asap" | capture date |
| "jutro", "tomorrow" | capture date + 1 |
| "w piątek", "this friday" | next Friday |
| "do końca tygodnia" | next Friday |
| "do końca miesiąca" | last day of month |
| explicit date | normalize to YYYY-MM-DD |
| no hint | omit field |

## Priority Emoji

| Emoji | Trigger words |
|-------|---------------|
| ⏫ | pilne, urgent, asap, krytyczne, blocker, must |
| 🔼 | ważne, important, should, or **no hint** (default) |
| 🔽 | kiedyś, nice to have, could, przy okazji |
| ⬇️ | nie teraz, wont, odłóż, skip |

## Edge Cases

- Multiple tasks on one line → split into separate output lines
- Unintelligible → keep verbatim, `[[Projects/?]]`, add `> ⚠️ wymaga ręcznej klasyfikacji`
- Empty line or starts with `%%` → skip

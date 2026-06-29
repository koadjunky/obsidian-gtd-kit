---
description: Classify Obsidian inbox items from Tasks/Capture.md into Tasks/Classified.md
---

# GTD Inbox Sweep

Classify all items in the Obsidian inbox and write structured tasks to `Classified.md`.

## Steps

1. Read `~/Documents/Obsidian Vault/Tasks/Capture.md`. If file is empty or missing, report and stop.
2. Read all `~/Documents/Obsidian Vault/Projects/*.md`. For each file, extract the content of any `## 🤖 Classifier hints` section.
3. Classify each line using the rules below. Skip lines that are empty or start with `%%`.
4. Before writing, check if `~/Documents/Obsidian Vault/Tasks/Classified.md` already exists and is non-empty. If it does, warn the user: "Classified.md already exists and has unprocessed items — run `/gtd-inbox-apply` first, or confirm you want to overwrite." Stop unless the user confirms overwrite.

   Write output to `~/Documents/Obsidian Vault/Tasks/Classified.md` with this header:

```
# Classified YYYY-MM-DD

```

5. Report: total items classified, how many have `[[Projects/?]]` (need manual review).
6. Tell user to review `Tasks/Classified.md` and then run `/gtd-inbox-apply`.

## Output Format

For each classified item, preserve everything after 🔗 verbatim (source, ⏰ time, ➕ created date). Append the original task text at the end with 💬.

```
- [ ] [[Projects/PROJEKT|PROJEKT]] <actionable description> <priority emoji> 🔗 <source> ⏰ <time> ➕ <date> 💬 <original task text>
```

With optional due date (inserted before 🔗):
```
- [ ] [[Projects/PROJEKT|PROJEKT]] <actionable description> <priority emoji> 📅 YYYY-MM-DD 🔗 <source> ⏰ <time> ➕ <date> 💬 <original task text>
```

If the original line has no 🔗 metadata, omit that section entirely:
```
- [ ] [[Projects/PROJEKT|PROJEKT]] <actionable description> <priority emoji> 💬 <original task text>
```

If multiple tasks were found in one original line, emit one output line per task.

## Classification Rules

### Project Assignment (apply in this order — stop at first match)

**1. Manual heuristics** (configure for your actual projects in CLAUDE.md):

Replace placeholder names below with your real project names and keywords:

- **Cyberdyne** — items about config, env support, debug, logs, or conferences where client "Cyberdyne" or its environments (DEV, UAT) are mentioned
- **Initech-Internal** — items about internal engineering (Presales, QA, DEV, Product, sprint, gitlab, keycloak, jira) where no external client is named
- **Initech** — platform development: hazelcast, kafka, rabbitmq, spring boot, risk-engine, broker-config, new features, architecture, code review
- **Personal** — no professional context: calls, appointments, purchases, private matters

**2. `## 🤖 Classifier hints` from project file** — if any project's hints match the item content, use that project.

**3. Context inference** — infer from description, keywords, and surrounding items.

**4. Fallback** — use `[[Projects/?]]`.

### Actionable Description

- Convert noun phrase to verb: "whitelist IP" → "Skonfigurować IP whitelisting"
- Expand clear abbreviations/typos
- Preserve source language (PL or EN, whichever the original uses)
- Maximum 1 sentence

### Due Date (`📅 YYYY-MM-DD`)

**CRITICAL: Never guess weekday→date mapping. Always count days explicitly from today's date (available in context as `currentDate`). Off-by-one errors are common — verify before writing.**

Example (today = 2026-06-29 Monday): wtorek = 2026-06-30, środa = 2026-07-01, czwartek = 2026-07-02, piątek = 2026-07-03.

| Hint in original | Resolves to |
|------------------|-------------|
| "dziś", "today", "asap" | today's date |
| "jutro", "tomorrow" | today + 1 day |
| weekday name ("w piątek", "czwartek" etc.) | count forward from today to that weekday |
| "do końca tygodnia" | next Friday from today |
| "do końca miesiąca" | last day of current month |
| explicit date in any format | normalize to YYYY-MM-DD |
| no hint | omit `📅` field entirely |

### Priority Emoji

| Emoji | Use when original contains |
|-------|---------------------------|
| ⏫ | pilne, urgent, asap, krytyczne, blocker, must |
| 🔼 | ważne, important, should — **or no hint (default)** |
| 🔽 | kiedyś, nice to have, could, przy okazji |
| ⬇️ | nie teraz, wont, odłóż, skip |

### Edge Cases

- **Multiple tasks in one line** — emit one output line per task
- **Unintelligible text** — use verbatim text as description, omit 💬 suffix (description IS the original), use `[[Projects/?]]`, append `⚠️` at end of line
- **Empty line or starts with `%%`** — skip entirely

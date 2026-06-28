# obsidian-gtd-kit — Design Spec

Date: 2026-06-28

## Goal

Claude Code skill kit for GTD task management in Obsidian. Phase 1 covers capture (via existing shell script) and inbox sweep (classify + apply). Later phases will add weekly review, daily prioritization, etc.

## Vault Structure

```
~/Documents/Obsidian Vault/
├── Tasks/
│   ├── Capture.md        # inbox — items land here via capture script
│   └── Classified.md     # output of /gtd-inbox-sweep, input of /gtd-inbox-apply
├── Projects/
│   └── *.md              # one file per project, may contain ## 🤖 Classifier hints
├── Daily/                # daily notes
├── Archive/              # archival destination for completed projects and processed files
└── Templates/
    └── Daily note.md
```

## Repo Structure

```
obsidian-gtd-kit/
├── README.md             # setup, MATE hotkey instructions, vault structure overview
├── CLAUDE.md             # Claude Code context: vault paths, skill naming conventions
├── LICENSE
├── skills/
│   ├── gtd-inbox-sweep.md
│   └── gtd-inbox-apply.md
├── scripts/
│   └── obsidian-capture.sh   # symlink to ~/bin/obsidian-capture.sh
└── docs/
    ├── vault-structure.md    # detailed vault map and classification rules reference
    └── superpowers/specs/
        └── 2026-06-28-obsidian-gtd-kit-design.md
```

## Skill Naming Convention

All skills in this repo use the `/gtd-` prefix: `/gtd-inbox-sweep`, `/gtd-inbox-apply`, etc.

## Skills

### `/gtd-inbox-sweep`

**Purpose:** Classify raw lines from `Tasks/Capture.md` into structured tasks.

**Flow:**

1. Read `~/Documents/Obsidian Vault/Tasks/Capture.md`
2. Read `~/Documents/Obsidian Vault/Projects/*.md` — extract `## 🤖 Classifier hints` sections from each
3. Classify each non-empty, non-comment line using classification rules (see below)
4. Write result to `~/Documents/Obsidian Vault/Tasks/Classified.md` with date header
5. Report count and ask user to review before running `/gtd-inbox-apply`

**Skip lines** that are empty or start with `%%`.

**Output format per task:**

```
- [ ] [[Projects/PROJEKT]] <actionable description> <priority emoji> 📅 YYYY-MM-DD 🔗 <source> ⏰ <time>
  > oryginał: "<original text>"
```

Omit `📅` if no due date hint. Use `[[Projects/?]]` if project cannot be determined.

---

### `/gtd-inbox-apply`

**Purpose:** Move classified tasks from `Tasks/Classified.md` to their project files.

**Flow:**

1. Read `~/Documents/Obsidian Vault/Tasks/Classified.md`
2. For each task with a resolved project: append to `## Tasks` section in the corresponding `Projects/PROJEKT.md`
3. Tasks with `[[Projects/?]]`: list them separately, ask user to assign manually
4. Clear `Tasks/Capture.md` (leave empty)
5. Archive `Tasks/Classified.md` → `Archive/Classified-YYYY-MM-DD.md`

---

## Classification Rules

### Project assignment (priority order)

1. **Manual heuristics** (highest priority):
   - **Cyberdyne** — config, env support, debug, logs, conferences where Cyberdyne or its envs (DEV, UAT) are mentioned
   - **Initech-Internal** — config, env support, debug, logs where no external company is named, or Presales/QA/DEV/Product/sprint/gitlab/keycloak/jira are explicitly mentioned
   - **Initech** — Initech/atcloud platform dev: hazelcast, kafka, rabbitmq, spring boot, risk-engine, broker-config, new features, architecture, code review
   - **Personal** — no professional context: calls, appointments, purchases, private matters

2. `## 🤖 Classifier hints` section from project file
3. Inference from context (description, source, other tasks)
4. Fallback: `[[Projects/?]]`

### Actionable description

- Noun → verb: "whitelist IP" → "Skonfigurować IP whitelisting"
- Expand abbreviations/typos when intent is clear
- Preserve source language (PL/EN)
- Max 1 sentence

### Due date (`📅 YYYY-MM-DD`)

| Hint | Resolution |
|------|------------|
| "dziś", "today", "asap" | capture date |
| "jutro", "tomorrow" | capture date + 1 |
| "w piątek", "this friday" | next Friday from capture date |
| "do końca tygodnia" | next Friday |
| "do końca miesiąca" | last day of month |
| explicit date (any format) | normalize to YYYY-MM-DD |
| no hint | omit field |

### Priority (Obsidian Tasks emoji)

| Emoji | When |
|-------|------|
| ⏫ | "pilne", "urgent", "asap", "krytyczne", "blocker", "must" |
| 🔼 | "ważne", "important", "should", or no hint (default) |
| 🔽 | "kiedyś", "nice to have", "could", "przy okazji" |
| ⬇️ | "nie teraz", "wont", "odłóż", "skip", explicit deferral |

### Edge cases

- Multiple tasks on one line → split into separate lines
- Unintelligible description → keep verbatim, project `[[Projects/?]]`, add `> ⚠️ wymaga ręcznej klasyfikacji`

---

## Capture Script

`~/bin/obsidian-capture.sh` (already exists) — called via `Windows-C` hotkey in Debian MATE. The `scripts/obsidian-capture.sh` in this repo is a symlink to it. Setup instructions in `README.md`.

---

## Out of Scope (Phase 1)

- Weekly review skill
- Daily prioritization skill
- Daily note automation
- Mobile capture

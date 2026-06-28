# obsidian-gtd-kit Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build repo scaffold and two Claude Code skills (`/gtd-inbox-sweep`, `/gtd-inbox-apply`) for GTD inbox processing in Obsidian.

**Architecture:** Pure markdown repo — no runtime code. Each skill is a `.md` file loaded by Claude Code when the user invokes the slash command. Claude reads/writes Obsidian vault files directly using its file tools. Supporting shell script lives in `scripts/` as a symlink to `~/bin/`.

**Tech Stack:** Markdown (Claude Code skills), Bash (capture script symlink), Obsidian Tasks plugin emoji format.

## Global Constraints

- All skills use `/gtd-` prefix (e.g. `/gtd-inbox-sweep`)
- Never use real company/client names — use Initech, Cyberdyne, Weyland, Umbrella, Tyrell as placeholders
- Vault root: `~/Documents/Obsidian Vault/`
- Skill files live in `skills/` with `.md` extension
- Obsidian Tasks format: `- [ ] [[Projects/X]] description <priority> 📅 YYYY-MM-DD`

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `README.md` | Modify | Setup guide, MATE hotkey, vault overview |
| `CLAUDE.md` | Create | Claude Code context: vault paths, conventions |
| `docs/vault-structure.md` | Create | Vault map and classification rules reference |
| `scripts/obsidian-capture.sh` | Create (symlink) | Points to `~/bin/obsidian-capture.sh` |
| `skills/gtd-inbox-sweep.md` | Create | Classify Capture.md → Classified.md |
| `skills/gtd-inbox-apply.md` | Create | Apply Classified.md → project files + archive |

---

## Task 1: Repo scaffold — CLAUDE.md + directory structure

**Files:**
- Create: `CLAUDE.md`
- Create: `skills/` (directory)
- Create: `scripts/` (directory)

**Interfaces:**
- Produces: `CLAUDE.md` referenced by all future skill files and contributors

- [ ] **Step 1: Create `skills/` and `scripts/` directories with `.gitkeep`**

```bash
mkdir -p skills scripts
touch skills/.gitkeep scripts/.gitkeep
```

- [ ] **Step 2: Create `CLAUDE.md`**

```markdown
# obsidian-gtd-kit — Claude Code Context

## Vault

Obsidian vault root: `~/Documents/Obsidian Vault/`

Key paths:
- `Tasks/Capture.md` — inbox, items land here via capture script
- `Tasks/Classified.md` — output of /gtd-inbox-sweep
- `Projects/*.md` — one file per project; may contain `## 🤖 Classifier hints`
- `Archive/` — processed files land here
- `Daily/` — daily notes
- `Templates/Daily note.md` — daily note template

## Skills

All skills in this repo use the `/gtd-` prefix.

| Skill | File | Purpose |
|-------|------|---------|
| `/gtd-inbox-sweep` | `skills/gtd-inbox-sweep.md` | Classify Capture.md → Classified.md |
| `/gtd-inbox-apply` | `skills/gtd-inbox-apply.md` | Apply Classified.md to project files |

## Naming Rules

- Never use real company or client names in this repo (docs, examples, skill prompts)
- Placeholder companies: Initech, Cyberdyne, Weyland, Umbrella, Tyrell
- See `~/Work/Claude/CLAUDE.md` for the global rule

## Project File Format

Each `Projects/PROJEKT.md` may contain:
```
## 🤖 Classifier hints
Keywords or rules that help /gtd-inbox-sweep route items to this project.
```

And a tasks section:
```
## Tasks
- [ ] [[Projects/PROJEKT]] Do something 🔼
```
```

- [ ] **Step 3: Verify files exist**

```bash
ls CLAUDE.md skills/ scripts/
```

Expected output:
```
CLAUDE.md  scripts/  skills/
```

- [ ] **Step 4: Commit**

```bash
git add CLAUDE.md skills/.gitkeep scripts/.gitkeep
git commit -m "feat: add repo scaffold and CLAUDE.md"
```

---

## Task 2: README.md

**Files:**
- Modify: `README.md`

**Interfaces:**
- Consumes: nothing
- Produces: user-facing setup guide

- [ ] **Step 1: Overwrite `README.md`**

```markdown
# obsidian-gtd-kit

Claude Code skill kit for GTD task management in Obsidian.

## What's included

| Skill | Purpose |
|-------|---------|
| `/gtd-inbox-sweep` | Classify items from inbox → `Tasks/Classified.md` |
| `/gtd-inbox-apply` | Move classified tasks to project files, archive inbox |

## Prerequisites

- [Claude Code](https://claude.ai/code) CLI installed
- Obsidian vault at `~/Documents/Obsidian Vault/`
- [Obsidian Tasks](https://github.com/obsidian-tasks-group/obsidian-tasks) plugin (for task emoji format)

## Setup

### 1. Install skills

Clone this repo into your Claude Code plugins or skills directory:

```bash
git clone <repo-url> ~/.claude/skills/obsidian-gtd-kit
```

Or symlink `skills/` into whichever directory Claude Code loads skills from.

### 2. Capture script (hotkey)

`scripts/obsidian-capture.sh` is a symlink to `~/bin/obsidian-capture.sh`.
Copy or symlink it to your `~/bin/`:

```bash
cp scripts/obsidian-capture.sh ~/bin/obsidian-capture.sh
chmod +x ~/bin/obsidian-capture.sh
```

#### Bind to Windows-C in Debian MATE

1. Open **System → Preferences → Keyboard Shortcuts**
2. Click **Add**
3. Name: `Obsidian Capture`
4. Command: `/home/<your-user>/bin/obsidian-capture.sh`
5. Click the shortcut field and press `Super+C`

### 3. Vault structure

Skills expect this layout under `~/Documents/Obsidian Vault/`:

```
Tasks/
  Capture.md      ← inbox
  Classified.md   ← created by /gtd-inbox-sweep
Projects/
  *.md            ← one file per project
Archive/          ← processed files
Daily/            ← daily notes
Templates/
  Daily note.md
```

### 4. Project classifier hints (optional)

Add a `## 🤖 Classifier hints` section to any project file to help the classifier route items:

```markdown
## 🤖 Classifier hints
Items about deployment, CI/CD, Jenkins, pipeline fixes.
```

## Workflow

```
Windows-C  →  obsidian-capture.sh  →  Tasks/Capture.md
                                              ↓
                                   /gtd-inbox-sweep
                                              ↓
                                   Tasks/Classified.md  (review here)
                                              ↓
                                   /gtd-inbox-apply
                                              ↓
                              Projects/*.md  +  Archive/
```

## License

MIT
```

- [ ] **Step 2: Verify**

```bash
head -5 README.md
```

Expected: `# obsidian-gtd-kit`

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "feat: write README with setup and MATE hotkey instructions"
```

---

## Task 3: docs/vault-structure.md

**Files:**
- Create: `docs/vault-structure.md`

**Interfaces:**
- Produces: classification rules reference used by Task 5 (gtd-inbox-sweep skill)

- [ ] **Step 1: Create `docs/vault-structure.md`**

```markdown
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
```

- [ ] **Step 2: Verify**

```bash
ls docs/vault-structure.md
```

- [ ] **Step 3: Commit**

```bash
git add docs/vault-structure.md
git commit -m "docs: add vault structure and classification rules reference"
```

---

## Task 4: scripts/obsidian-capture.sh symlink

**Files:**
- Create: `scripts/obsidian-capture.sh` (symlink)
- Modify: `scripts/.gitkeep` (remove)

**Interfaces:**
- Produces: versioned capture script source, documented in README

- [ ] **Step 1: Remove .gitkeep and create symlink**

```bash
rm scripts/.gitkeep
ln -s ~/bin/obsidian-capture.sh scripts/obsidian-capture.sh
```

- [ ] **Step 2: Verify symlink**

```bash
ls -la scripts/obsidian-capture.sh
```

Expected: `scripts/obsidian-capture.sh -> /home/<user>/bin/obsidian-capture.sh`

- [ ] **Step 3: Commit**

Git tracks symlinks. Stage the symlink itself:

```bash
git add scripts/obsidian-capture.sh scripts/.gitkeep
git rm --cached scripts/.gitkeep
git commit -m "feat: add symlink to obsidian-capture.sh"
```

---

## Task 5: skills/gtd-inbox-sweep.md

**Files:**
- Create: `skills/gtd-inbox-sweep.md`
- Modify: `skills/.gitkeep` (remove)

**Interfaces:**
- Consumes: `Tasks/Capture.md`, `Projects/*.md` (classifier hints)
- Produces: `Tasks/Classified.md`

- [ ] **Step 1: Create `skills/gtd-inbox-sweep.md`**

```markdown
---
description: Classify Obsidian inbox items from Tasks/Capture.md into Tasks/Classified.md
---

# GTD Inbox Sweep

Classify all items in the Obsidian inbox and write structured tasks to `Classified.md`.

## Steps

1. Read `~/Documents/Obsidian Vault/Tasks/Capture.md`. If file is empty or missing, report and stop.
2. Read all `~/Documents/Obsidian Vault/Projects/*.md`. For each file, extract the content of any `## 🤖 Classifier hints` section.
3. Classify each line using the rules below. Skip lines that are empty or start with `%%`.
4. Write output to `~/Documents/Obsidian Vault/Tasks/Classified.md` with this header:

```
# Classified YYYY-MM-DD

```

5. Report: total items classified, how many have `[[Projects/?]]` (need manual review).
6. Tell user to review `Tasks/Classified.md` and then run `/gtd-inbox-apply`.

## Output Format

For each classified item:
```
- [ ] [[Projects/PROJEKT]] <actionable description> <priority emoji>
  > oryginał: "<original text>"
```

With optional fields:
```
- [ ] [[Projects/PROJEKT]] <actionable description> <priority emoji> 📅 YYYY-MM-DD
  > oryginał: "<original text>"
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

| Hint in original | Resolves to |
|------------------|-------------|
| "dziś", "today", "asap" | today's date |
| "jutro", "tomorrow" | today + 1 day |
| "w piątek", "this friday" | next Friday from today |
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
- **Unintelligible text** — keep verbatim as description, use `[[Projects/?]]`, add `> ⚠️ wymaga ręcznej klasyfikacji`
- **Empty line or starts with `%%`** — skip entirely
```

- [ ] **Step 2: Remove .gitkeep**

```bash
git rm skills/.gitkeep
```

- [ ] **Step 3: Verify skill file structure**

```bash
head -5 skills/gtd-inbox-sweep.md
```

Expected: `---` (frontmatter start)

- [ ] **Step 4: Smoke test**

Create a test inbox:

```bash
cat > "/tmp/capture-test.md" << 'EOF'
whitelist IP dla Cyberdyne DEV dziś pilne
zadzwoń do dentysty
refactor risk-engine hazelcast
EOF
```

Copy to vault inbox, invoke `/gtd-inbox-sweep` in Claude Code, verify:
- `Tasks/Classified.md` created with date header
- 3 items classified
- First item: project `Cyberdyne`, priority `⏫`, due date = today
- Second item: project `Personal`
- Third item: project `Initech`

Restore original `Capture.md` after test.

- [ ] **Step 5: Commit**

```bash
git add skills/gtd-inbox-sweep.md
git commit -m "feat: add /gtd-inbox-sweep skill"
```

---

## Task 6: skills/gtd-inbox-apply.md

**Files:**
- Create: `skills/gtd-inbox-apply.md`

**Interfaces:**
- Consumes: `Tasks/Classified.md` (output of Task 5 skill)
- Produces: updated `Projects/*.md`, cleared `Tasks/Capture.md`, `Archive/Classified-YYYY-MM-DD.md`

- [ ] **Step 1: Create `skills/gtd-inbox-apply.md`**

```markdown
---
description: Apply Tasks/Classified.md to project files, clear inbox, archive
---

# GTD Inbox Apply

Apply classified tasks from `Tasks/Classified.md` to their project files, then archive.

**Run this after reviewing `/gtd-inbox-sweep` output.**

## Steps

1. Read `~/Documents/Obsidian Vault/Tasks/Classified.md`. If missing or empty, report and stop.

2. Parse all task lines (lines starting with `- [ ]`).

3. For each task with a resolved project (not `[[Projects/?]]`):
   - Open `~/Documents/Obsidian Vault/Projects/PROJEKT.md`
   - If file has a `## Tasks` section, append the task line there
   - If no `## Tasks` section exists, append one at the end of the file and then add the task line
   - Strip the `> oryginał:` line before appending (keep only the `- [ ]` line)

4. Collect all tasks with `[[Projects/?]]` and print them as a list for manual assignment. Do not write these anywhere — ask the user to assign them manually.

5. Clear `~/Documents/Obsidian Vault/Tasks/Capture.md` — write an empty file (or just a blank line).

6. Move `Tasks/Classified.md` to `Archive/Classified-YYYY-MM-DD.md` (use today's date).

7. Report:
   - How many tasks appended to project files (list: project name → count)
   - How many tasks need manual assignment (`[[Projects/?]]`)
   - Confirm Capture.md cleared and Classified.md archived

## Notes

- Do not create new project files — only append to existing ones. If a referenced project file does not exist, add it to the manual assignment list with a note.
- Preserve existing content in project files exactly — only append to `## Tasks`.
- The `> oryginał:` lines are for human review in Classified.md only; do not copy them to project files.
```

- [ ] **Step 2: Verify**

```bash
head -5 skills/gtd-inbox-apply.md
```

Expected: `---` (frontmatter start)

- [ ] **Step 3: Smoke test**

With a populated `Tasks/Classified.md` from the Task 5 smoke test, invoke `/gtd-inbox-apply` in Claude Code. Verify:
- Task lines appended to correct `Projects/*.md` files under `## Tasks`
- `Tasks/Capture.md` is empty
- `Archive/Classified-YYYY-MM-DD.md` exists with the old classified content
- `Tasks/Classified.md` no longer exists (moved)
- `[[Projects/?]]` items listed in terminal output, not written to files

- [ ] **Step 4: Commit**

```bash
git add skills/gtd-inbox-apply.md
git commit -m "feat: add /gtd-inbox-apply skill"
```

---

## Self-Review

**Spec coverage:**

| Spec requirement | Task |
|-----------------|------|
| Repo scaffold (skills/, scripts/, docs/) | Task 1 |
| CLAUDE.md with vault paths + naming convention | Task 1 |
| README with MATE hotkey instructions | Task 2 |
| docs/vault-structure.md | Task 3 |
| scripts/obsidian-capture.sh symlink | Task 4 |
| /gtd-inbox-sweep skill | Task 5 |
| /gtd-inbox-apply skill | Task 6 |
| Classification rules (project, priority, due date, edge cases) | Task 5 (embedded in skill) + Task 3 (reference) |
| Archive Classified.md after apply | Task 6 |
| Clear Capture.md after apply | Task 6 |
| [[Projects/?]] manual handling | Task 6 |
| /gtd- prefix convention | All tasks, CLAUDE.md |
| No real company names | All tasks (Initech/Cyberdyne placeholders) |

**Placeholder scan:** No TBDs or TODOs. All steps have complete content.

**Type consistency:** No code types — skill files are prose. File paths consistent throughout.

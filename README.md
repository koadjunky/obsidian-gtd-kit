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

`scripts/obsidian-capture.sh` in this repo is a symlink pointing to `~/bin/obsidian-capture.sh` on the original author's machine. New users must create their own capture script at `~/bin/obsidian-capture.sh` before using the symlink or copying from it. Once your script exists, make it executable:

```bash
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
Super+C  →  obsidian-capture.sh  →  Tasks/Capture.md
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

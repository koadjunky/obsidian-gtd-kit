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

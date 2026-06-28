---
description: Apply ~/Documents/Obsidian Vault/Tasks/Classified.md to project files, clear inbox, archive
---

# GTD Inbox Apply

Apply classified tasks from `~/Documents/Obsidian Vault/Tasks/Classified.md` to their project files, then archive.

**Run this after reviewing `/gtd-inbox-sweep` output.**

## Steps

1. Read `~/Documents/Obsidian Vault/Tasks/Classified.md`. If it does not exist, tell the user it is missing — run `/gtd-inbox-sweep` first — then stop. If it exists but is empty, tell the user it is empty — run `/gtd-inbox-sweep` first — then stop.

2. Parse all task lines (lines starting with `- [ ]`).

3. For each task with a resolved project (not `[[Projects/?]]`):
   - Open `~/Documents/Obsidian Vault/Projects/PROJEKT.md`
   - If file has a `## Tasks` section, append the task line there
   - If no `## Tasks` section exists, append one at the end of the file and then add the task line
   - Strip the `> oryginał:` line before appending (keep only the `- [ ]` line)

4. Collect all tasks with `[[Projects/?]]` and print them as a list for manual assignment. Do not write these anywhere — ask the user to assign them manually.

5. Clear `~/Documents/Obsidian Vault/Tasks/Capture.md` — write an empty file (or just a blank line).

6. Move `~/Documents/Obsidian Vault/Tasks/Classified.md` to `~/Documents/Obsidian Vault/Archive/Classified-YYYY-MM-DD.md` (use today's date).

7. Report:
   - How many tasks appended to project files (list: project name → count)
   - How many tasks need manual assignment (`[[Projects/?]]`)
   - Confirm Capture.md cleared and Classified.md archived

## Notes

- Do not create new project files — only append to existing ones. If a referenced project file does not exist, add it to the manual assignment list with a note.
- Preserve existing content in project files exactly — only append to `## Tasks`.
- The `> oryginał:` lines are for human review in Classified.md only; do not copy them to project files.

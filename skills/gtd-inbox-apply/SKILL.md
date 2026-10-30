---
description: Apply ~/Documents/Obsidian Vault/Tasks/Classified.md to project files, clear inbox, archive
---

# GTD Inbox Apply

Apply classified tasks from `~/Documents/Obsidian Vault/Tasks/Classified.md` to their project files, then archive.

**Run this after reviewing `/gtd-inbox-sweep` output.**

## Steps

1. Read `~/Documents/Obsidian Vault/Tasks/Classified.md`. If it does not exist, tell the user it is missing — run `/gtd-inbox-sweep` first — then stop. If it exists but is empty, tell the user it is empty — run `/gtd-inbox-sweep` first — then stop. Always read it from disk: never reuse the version produced by `/gtd-inbox-sweep` earlier in the same session. The review step between sweep and apply is exactly where the user changes project assignments, so the in-context copy is stale.

2. If `Classified.md` contains `#today` tags, it was tagged in Obsidian during review, so Obsidian has it (and likely the project files) open with live buffers. Warn the user before applying: appended lines can come back reordered, duplicated, or already checked off (`- [x] … ✅ <date>`) when Obsidian flushes its buffer. Tagging `#today` after apply, in the project files, avoids it.

3. Parse all task lines (lines starting with `- [ ]`).

4. For each task with a resolved project (not `[[Projects/?]]`):
   - Parse project link — supports both `[[Projects/PROJEKT]]` and `[[Projects/PROJEKT|PROJEKT]]`; extract `PROJEKT` as the filename
   - Open `~/Documents/Obsidian Vault/Projects/PROJEKT.md`
   - If file has a `## Tasks` section, append the task line there
   - If no `## Tasks` section exists, append one at the end of the file and then add the task line
   - Before appending, strip the project link (`[[Projects/PROJEKT|PROJEKT]]` or `[[Projects/PROJEKT]]`) from the task line
   - Strip the `> oryginał:` line before appending (keep only the `- [ ]` line)

5. Verify every appended line actually landed: `grep -F` each line body in its project file. Obsidian may hold a stale in-memory buffer of a project file and overwrite appends made from the shell. If a line is missing, report it and stop before clearing `Capture.md`.

6. Collect all tasks with `[[Projects/?]]` and print them as a list for manual assignment. Do not write these anywhere — ask the user to assign them manually.

7. In every project file that was modified in step 4, strip `#inbox` and `#today` tags from all completed tasks (lines starting with `- [x]`). Do not touch open tasks (`- [ ]`).

8. Clear `~/Documents/Obsidian Vault/Tasks/Capture.md` — write an empty file (or just a blank line).

9. Move `~/Documents/Obsidian Vault/Tasks/Classified.md` to `~/Documents/Obsidian Vault/Archive/Classified-YYYY-MM-DD.md` (use today's date).

10. Report:
   - How many tasks appended to project files (list: project name → count)
   - How many tasks need manual assignment (`[[Projects/?]]`)
   - Confirm Capture.md cleared and Classified.md archived
   - Warn the user to reload the modified project files in Obsidian

## Notes

- Do not create new project files — only append to existing ones. If a referenced project file does not exist, add it to the manual assignment list with a note.
- Preserve existing content in project files exactly — only append to `## Tasks`.
- The `> oryginał:` lines are for human review in Classified.md only; do not copy them to project files.

#!/bin/bash

VAULT="$HOME/Documents/Obsidian Vault"   # ← zmień na swoją ścieżkę
INBOX="$VAULT/Tasks/Capture.md"

SELECTED=$(xclip -o -selection primary 2>/dev/null || echo "")
DATE_ONLY=$(date "+%Y-%m-%d")
TIME_ONLY=$(date "+%H:%M")
WINDOW_TITLE=$(xdotool getactivewindow getwindowname 2>/dev/null || echo "")

SEP=$'\x01'

RESULT=$(yad --form \
    --title="Obsidian Capture" \
    --text="New task:" \
    --width=600 \
    --separator="$SEP" \
    --field="Task" "$SELECTED" \
    --field="Source" "$WINDOW_TITLE" \
    --field="Date" "$DATE_ONLY" \
    --field="Time" "$TIME_ONLY" \
    --button="Create:0" \
    --button="Cancel:1" \
    2>/dev/null)

[ $? -ne 0 ] && exit 0
[ -z "$RESULT" ] && exit 0

TASK=$(echo "$RESULT"    | cut -d"$SEP" -f1)
SOURCE=$(echo "$RESULT"  | cut -d"$SEP" -f2)
DATETIME=$(echo "$RESULT" | cut -d"$SEP" -f3)

[ -z "$TASK" ] && exit 0

# Zbuduj linię do inboxa
LINE="- [ ] #inbox $TASK 🔗 $SOURCE ⏰ $TIME_ONLY ➕ $DATE_ONLY"

# Upewnij się że plik istnieje
mkdir -p "$(dirname "$INBOX")"
touch "$INBOX"

# Upewnij się że plik kończy się newline przed doklejeniem
[ -s "$INBOX" ] && [ "$(tail -c1 "$INBOX" | wc -l)" -eq 0 ] && echo "" >> "$INBOX"

echo "$LINE" >> "$INBOX"

notify-send "Obsidian Capture" "${TASK:0:60}" -t 2000

#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${HOME:-}" || "$HOME" == "/" ]]; then
  printf 'Refusing to initialize: HOME must be a non-root home directory.\n' >&2
  exit 1
fi

lab_dir="$HOME/navigation_lab"
if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir/inbox" "$lab_dir/work" "$lab_dir/empty-room"
printf 'Field notes: the north trail begins beside the old bridge.\n' > "$lab_dir/inbox/field-notes.txt"
printf 'Old map: the east path is closed.\n' > "$lab_dir/inbox/old-map.txt"
printf 'Temporary draft; remove this file during the exercise.\n' > "$lab_dir/work/draft.tmp"

printf 'Exercise initialized at %s\n' "$lab_dir"
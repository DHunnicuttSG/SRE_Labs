#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${HOME:-}" || "$HOME" == "/" ]]; then
  printf 'Refusing to initialize: HOME must be a non-root home directory.\n' >&2
  exit 1
fi

lab_dir="$HOME/system_info_lab"
if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir"
printf 'Exercise initialized at %s\n' "$lab_dir"
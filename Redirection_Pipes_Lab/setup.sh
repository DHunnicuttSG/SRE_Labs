#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lab_dir="${HOME:?HOME must be set}/redirection_practice"

if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir"
cp -R "$script_dir/dataset/." "$lab_dir/"
tr -d '\r' < "$lab_dir/activity.log" > "$lab_dir/activity.log.tmp"
mv "$lab_dir/activity.log.tmp" "$lab_dir/activity.log"
printf '\n' >> "$lab_dir/activity.log"
mkdir -p "$lab_dir/reports"
printf 'Redirection and pipes practice initialized at %s\n' "$lab_dir"
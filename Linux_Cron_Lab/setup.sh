#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lab_dir="${HOME:?HOME must be set}/cron_practice"

if ! command -v crontab >/dev/null 2>&1; then
  printf 'crontab is not installed. Install cron (Ubuntu/Debian) or cronie (Amazon Linux/RHEL).\n' >&2
  exit 1
fi

if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir"
cp -R "$script_dir/dataset/." "$lab_dir/"
mkdir -p "$lab_dir/logs" "$lab_dir/reports"
chmod +x "$lab_dir"/scripts/*.sh
printf 'Cron practice initialized at %s\n' "$lab_dir"
#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lab_dir="${HOME:?HOME must be set}/awk_practice"

if ! command -v gawk >/dev/null 2>&1; then
  printf 'GNU awk (gawk) is required. Install it and rerun setup.sh.\n' >&2
  exit 1
fi

if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir"
cp -R "$script_dir/dataset/." "$lab_dir/"
mkdir -p "$lab_dir/reports"
printf 'Awk practice initialized at %s\n' "$lab_dir"
#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
lab_dir="${HOME:?HOME must be set}/find_practice"

if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

for tool in find locate updatedb; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'Required command not found: %s (install GNU findutils).\n' "$tool" >&2
    exit 1
  fi
done

mkdir -p "$lab_dir"
cp -R "$script_dir/dataset/." "$lab_dir/"
mkdir -p "$lab_dir/reports"
mkdir -p "$lab_dir/tree/incoming"
: > "$lab_dir/tree/docs/empty.txt"
touch -d '10 days ago' "$lab_dir/tree/logs/archive/old.log"
chmod 0640 "$lab_dir/tree/config/secret.conf"
updatedb --localpaths="$lab_dir/tree" --output="$lab_dir/locate.db"
printf 'Find and locate practice initialized at %s\n' "$lab_dir"
#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${HOME:-}" || "$HOME" == "/" ]]; then
  printf 'Refusing to initialize: HOME must be a non-root home directory.\n' >&2
  exit 1
fi

lab_dir="$HOME/networking_lab"
if [[ -e "$lab_dir" ]]; then
  printf 'Refusing to overwrite %s. Remove it first if you want a fresh attempt.\n' "$lab_dir" >&2
  exit 1
fi

mkdir -p "$lab_dir/www"
cat > "$lab_dir/www/index.html" <<'HTML'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Local Networking Lab Service</title>
  </head>
  <body>
    <h1>Local Networking Lab Service</h1>
    <p>The local HTTP service is reachable on port 8080.</p>
  </body>
</html>
HTML

printf 'Exercise initialized at %s\n' "$lab_dir"
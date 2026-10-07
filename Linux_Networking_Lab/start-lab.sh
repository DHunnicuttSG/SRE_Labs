#!/usr/bin/env bash
set -euo pipefail

lab_dir="${HOME:?HOME must be set}/networking_lab"
python3 -m http.server 8080 \
  --bind 127.0.0.1 \
  --directory "$lab_dir/www" \
  > "$lab_dir/http-server.log" 2>&1 &

for attempt in {1..40}; do
  if curl --fail --silent http://127.0.0.1:8080/ >/dev/null; then
    break
  fi
  sleep 0.25
done

if ! curl --fail --silent http://127.0.0.1:8080/ >/dev/null; then
  printf 'Could not start the local HTTP service on 127.0.0.1:8080.\n' >&2
  exit 1
fi

printf 'Local HTTP service ready at http://127.0.0.1:8080\n'
exec bash -l
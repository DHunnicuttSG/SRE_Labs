#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/networking_lab"
report_dir="$lab_dir/reports"
score=0
total=100

check() {
  local points="$1"
  local label="$2"
  shift 2

  if "$@"; then
    printf '[PASS] %s (+%d)\n' "$label" "$points"
    score=$((score + points))
  else
    printf '[FAIL] %s (%d points)\n' "$label" "$points"
  fi
}

has_report() {
  local file="$1"
  local pattern="$2"
  [[ -f "$report_dir/$file" ]] && grep -Eiq -- "$pattern" "$report_dir/$file"
}

printf 'Checking exercise reports in %s\n\n' "$report_dir"
check 15 'interface report includes loopback' has_report interfaces.txt '(^|[[:space:]])lo([[:space:]]|$)'
check 15 'route report includes a default route' has_report routes.txt '(^|[[:space:]])default([[:space:]]|$)'
check 15 'ping report shows a loopback reply' has_report ping.txt 'bytes from 127\.0\.0\.1'
check 10 'name-resolution report includes localhost' has_report dns.txt 'localhost'
check 15 'listener report includes port 8080' has_report listeners.txt ':8080([[:space:]]|$)'
check 15 'TCP check reports a successful connection' has_report tcp-check.txt 'succeeded|open'
check 15 'HTTP report includes a successful response' has_report http-headers.txt '200 OK'

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review the failed checks, make corrections, and run the grader again.\n'
exit 1
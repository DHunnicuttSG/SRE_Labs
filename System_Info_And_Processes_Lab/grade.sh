#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/system_info_lab"
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

system_report_is_valid() {
  [[ -f "$report_dir/system.txt" ]] \
    && grep -Eiq 'Linux' "$report_dir/system.txt" \
    && grep -Eiq '^PRETTY_NAME=' "$report_dir/system.txt"
}

process_was_inspected() {
  [[ -f "$report_dir/worker.pid" ]] \
    && grep -Eq '^[1-9][0-9]*$' "$report_dir/worker.pid" \
    && grep -Eiq 'sleep' "$report_dir/process.txt"
}

printf 'Checking exercise reports in %s\n\n' "$report_dir"
check 10 'system report identifies Linux and includes OS details' system_report_is_valid
check 5 'hostname report is present' test -s "$report_dir/hostname.txt"
check 10 'uptime report includes load averages' has_report uptime.txt 'load average'
check 10 'memory report includes physical memory' has_report memory.txt 'Mem:'
check 10 'disk report includes the root filesystem' has_report disk.txt '[[:space:]]/[[:space:]]*$'
check 15 'vmstat report includes memory statistics' has_report vmstat.txt 'swpd[[:space:]]+free'
check 10 'job list includes the background test process' has_report jobs.txt 'sleep[[:space:]]+600'
check 15 'process report records its PID and shows sleep' process_was_inspected
check 15 'stop report records SIGTERM exit status 143' has_report stop-status.txt '143'

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review the failed checks, make corrections, and run the grader again.\n'
exit 1
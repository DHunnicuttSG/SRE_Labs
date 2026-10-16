#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/cron_practice"
minute_line="* * * * * $lab_dir/scripts/heartbeat.sh >> $lab_dir/logs/heartbeat.log 2>&1"
daily_line="0 2 * * * $lab_dir/scripts/daily_health.sh >> $lab_dir/logs/daily-health.log 2>&1"
weekly_line="15 3 * * 1 $lab_dir/scripts/daily_health.sh >> $lab_dir/logs/weekly-health.log 2>&1"
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

check_report() {
  local report="$1"
  shift
  [[ -f "$report" ]] || return 1

  local expected
  expected="$(mktemp)" || return 1
  if "$@" > "$expected"; then
    cmp -s "$expected" "$report"
    local result=$?
    rm -f "$expected"
    return "$result"
  fi

  rm -f "$expected"
  return 1
}

expected_q01() {
  crontab -l 2>/dev/null | grep -Fxq -- "$minute_line" || return 1
  printf '%s\n' "$minute_line"
}
expected_q02() {
  crontab -l 2>/dev/null | grep -Fxq -- "$daily_line" || return 1
  printf '%s\n' "$daily_line"
}
expected_q03() {
  local installed
  installed="$(crontab -l 2>/dev/null)" || return 1
  grep -Fxq -- "$minute_line" <<< "$installed" || return 1
  grep -Fxq -- "$daily_line" <<< "$installed" || return 1
  printf '%s\n%s\n' "$minute_line" "$daily_line" | LC_ALL=C sort
}
expected_q04() {
  pgrep -x cron >/dev/null 2>&1 || pgrep -x crond >/dev/null 2>&1 || return 1
  printf 'cron running\n'
}
expected_q05() {
  [[ -f "$lab_dir/reports/q05.txt" ]] || return 1
  LC_ALL=C grep -Eq '^HEARTBEAT timestamp=[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z host=.+$' "$lab_dir/reports/q05.txt"
  cat "$lab_dir/reports/q05.txt"
}
expected_q06() {
  [[ -f "$lab_dir/logs/heartbeat.log" ]] || return 1
  local reported actual
  reported="$(cat "$lab_dir/reports/q06.txt" 2>/dev/null)" || return 1
  [[ "$reported" =~ ^[0-9]+$ ]] && (( reported > 0 )) || return 1
  actual="$(grep -c '^HEARTBEAT ' "$lab_dir/logs/heartbeat.log")" || return 1
  (( actual >= reported ))
}
expected_q07() {
  [[ -f "$lab_dir/reports/q07.txt" ]] || return 1
  LC_ALL=C grep -Eq '^DAILY_HEALTH timestamp=[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z root_usage=[0-9]+%$' "$lab_dir/reports/q07.txt"
  cat "$lab_dir/reports/q07.txt"
}
expected_challenge() {
  crontab -l 2>/dev/null | grep -Fxq -- "$weekly_line" || return 1
  printf '%s\n' "$weekly_line"
}

printf 'Checking cron reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 10 'Q1: every-minute heartbeat entry is installed' check_report reports/q01.txt expected_q01
check 10 'Q2: daily health entry is installed' check_report reports/q02.txt expected_q02
check 10 'Q3: both lab entries appear in the user crontab' check_report reports/q03.txt expected_q03
check 10 'Q4: cron daemon is running' check_report reports/q04.txt expected_q04
check 10 'Q5: heartbeat script emits a UTC timestamp' check_report reports/q05.txt expected_q05
check 10 'Q6: scheduled heartbeat has run' expected_q06
check 10 'Q7: health script reports root filesystem usage' check_report reports/q07.txt expected_q07
check 30 'Challenge: weekly schedule is installed and reported' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1
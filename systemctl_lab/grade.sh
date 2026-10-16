#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/systemctl_practice"
score=0
total=150

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
  "$@" > "$expected" 2>&1
  cmp -s "$expected" "$report"
  local result=$?
  rm -f "$expected"
  return "$result"
}

expected_export_count() {
  journalctl -u payments-api.service | wc -l | tr -d ' '
}

expected_challenge() {
  journalctl -u payments-api.service -b -1 -p warning -n 2
}

printf 'Checking systemctl and journalctl reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1
source "$lab_dir/lab-env.sh"

check 10 'Q1: failed units are listed' check_report reports/q01.txt systemctl --failed
check 10 'Q2: detailed service status is captured' check_report reports/q02.txt systemctl status payments-api.service
check 10 'Q3: service active state is captured' check_report reports/q03.txt systemctl is-active payments-api.service
check 10 'Q4: boot enablement is checked' check_report reports/q04.txt systemctl is-enabled payments-api.service
check 10 'Q5: selected unit properties are shown' check_report reports/q05.txt systemctl show payments-api.service -p ActiveState -p SubState -p Result -p ExecMainStatus -p FragmentPath
check 10 'Q6: effective unit definition is inspected' check_report reports/q06.txt systemctl cat payments-api.service
check 10 'Q7: service dependencies are shown' check_report reports/q07.txt systemctl list-dependencies payments-api.service
check 10 'Q8: recent service journal is captured' check_report reports/q08.txt journalctl -u payments-api.service -n 8
check 10 'Q9: warning-and-higher service logs are filtered' check_report reports/q09.txt journalctl -u payments-api.service -p warning
check 10 'Q10: previous-boot service logs are captured' check_report reports/q10.txt journalctl -u payments-api.service -b -1
check 10 'Q11: boot history is listed' check_report reports/q11.txt journalctl --list-boots
check 10 'Q12: kernel warnings and errors are captured' check_report reports/q12.txt journalctl -k -p warning
check 10 'Q13: service logs are bounded by start time' check_report reports/q13.txt journalctl -u payments-api.service --since '2026-10-16 09:30:00'
check 10 'Q14: scoped journal export line count is recorded' check_report reports/q14.txt expected_export_count
check 10 'Challenge: previous-boot warning excerpt is captured' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1

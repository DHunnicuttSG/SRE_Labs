#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/grep_practice"
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

expected_challenge() {
  grep -n 'ERROR' log.txt | grep -v 'DEBUG' | head -n 10
}

printf 'Checking grep exercise reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 7 'Q1: matching error lines' check_report reports/q01.txt grep -F 'error' log.txt
check 7 'Q2: case-insensitive warning search' check_report reports/q02.txt grep -i 'warning' system.log
check 7 'Q3: count matching success lines' check_report reports/q03.txt grep -ic 'success' output.txt
check 7 'Q4: failed matches include line numbers' check_report reports/q04.txt grep -n 'failed' report.txt
check 7 'Q5: recursive TODO search is limited to Python files' check_report reports/q05.txt grep -r --include='*.py' 'TODO' projects
check 7 'Q6: cat matches whole words only' check_report reports/q06.txt grep -w 'cat' animals.txt
check 7 'Q7: DEBUG lines are excluded' check_report reports/q07.txt grep -v 'DEBUG' app.log
check 7 'Q8: only lines starting with ERROR are selected' check_report reports/q08.txt grep '^ERROR' server.log
check 7 'Q9: either error or fail is matched' check_report reports/q09.txt grep -Ei 'error|fail' system.log
check 7 'Q10: IPv4 addresses are extracted' check_report reports/q10.txt grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' access.log
check 7 'Q11: three lines of context surround critical matches' check_report reports/q11.txt grep -i -C 3 'critical' kernel.log
check 7 'Q12: matching configuration filenames are listed' check_report reports/q12.txt grep -rlF -- 'port=8080' etc
check 7 'Q13: date strings are extracted' check_report reports/q13.txt grep -Eo '\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b' data.txt
check 9 'Challenge: numbered ERROR lines exclude DEBUG and stop at ten' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1
#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/redirection_practice"
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

expected_q01() { printf 'Hello Linux\n'; }
expected_q02() { printf 'Hello Linux\nLearning redirection\n'; }
expected_q03() { sort < names.txt; }
expected_q04() { printf 'North\nSouth\nWest\n'; }
expected_q05() { wc -w <<< 'quick brown fox'; }
expected_q06() { ls services | grep -c '\.conf$'; }
expected_q07() { grep 'ERROR' events.log; }
expected_q08() { printf 'session started\ntask checked\ntask completed\n'; }
expected_q09() { wc -l < names.txt; }
expected_q10() { cat events.log | grep -E '^(ERROR|WARN)' | sort; }
expected_q11() {
  grep 'WARN' <<'EOF'
INFO service started
WARN retrying database
ERROR connection timeout
EOF
}
expected_q12() { cat names.txt | grep -E '^(M|O)' | tr '[:lower:]' '[:upper:]'; }
expected_q13() { grep -h '^port=' services/*.conf | sort -t= -k2,2n; }
expected_challenge() { printf '4\n'; }

printf 'Checking redirection and pipes reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 7 'Q1: output overwrite creates the requested file' check_report reports/q01.txt expected_q01
check 7 'Q2: output append preserves the original line' check_report reports/q02.txt expected_q02
check 7 'Q3: input redirection sorts the names' check_report reports/q03.txt expected_q03
check 7 'Q4: here-document provides three lines' check_report reports/q04.txt expected_q04
check 7 'Q5: here-string supplies three words' check_report reports/q05.txt expected_q05
check 7 'Q6: pipeline counts configuration files' check_report reports/q06.txt expected_q06
check 7 'Q7: output redirection saves matching log lines' check_report reports/q07.txt expected_q07
check 7 'Q8: append redirection preserves the activity log' check_report reports/q08.txt expected_q08
check 7 'Q9: input redirection counts file lines' check_report reports/q09.txt expected_q09
check 7 'Q10: pipeline filters and sorts log lines' check_report reports/q10.txt expected_q10
check 7 'Q11: here-document feeds grep through a pipeline' check_report reports/q11.txt expected_q11
check 7 'Q12: pipeline filters names and transforms case' check_report reports/q12.txt expected_q12
check 7 'Q13: pipeline sorts configuration ports numerically' check_report reports/q13.txt expected_q13
check 9 'Challenge: pipeline count is redirected to the report' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1
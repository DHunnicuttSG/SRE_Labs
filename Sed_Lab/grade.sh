#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/sed_practice"
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

expected_q05() {
  grep -rl 'port=8080' etc | xargs sed -n 's/port=8080/port=80/p'
}

expected_q06() {
  [[ "$(<etc/app/config.conf)" == $'service=web\nport=8080\nhost=127.0.0.1' ]] \
    && check_report reports/q06.txt cat etc/app/config.conf
}

expected_q09() {
  sed = animals.txt | sed 'N;s/\n/\t/'
}

expected_q10() {
  sed -n 's/^\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/p' access.log
}

expected_q11() {
  sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\1\/\2\/\3/g' data.txt
}

expected_q12() {
  sed -n '/critical/I{s/.*/\U&/p}' kernel.log
}

expected_q13() {
  sed '1i\# Log Start' log.txt
}

expected_q14() {
  sed '$a\# Log End' log.txt
}

expected_challenge() {
  nl -ba log.txt | sed '/DEBUG/d;s/ERROR/ERR/'
}

printf 'Checking sed exercise reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 6 'Q1: first ERROR per line is replaced' check_report reports/q01.txt sed 's/ERROR/ERR/' log.txt
check 6 'Q2: every INFO token is replaced' check_report reports/q02.txt sed 's/INFO/INFORMATION/g' log.txt
check 6 'Q3: warning replacement ignores case' check_report reports/q03.txt sed 's/warning/WARN/Ig' system.log
check 6 'Q4: only changed failed lines are printed' check_report reports/q04.txt sed -n 's/failed/FAIL/p' report.txt
check 6 'Q5: recursive substitution is previewed' check_report reports/q05.txt expected_q05
check 6 'Q6: host is edited in place and result is saved' expected_q06
check 6 'Q7: DEBUG lines are deleted from output' check_report reports/q07.txt sed '/DEBUG/d' app.log
check 6 'Q8: matching lines receive an ERROR prefix' check_report reports/q08.txt sed 's/^ERROR/[ERROR] &/' server.log
check 6 'Q9: lines are numbered with tabs' check_report reports/q09.txt expected_q09
check 6 'Q10: IPv4-shaped addresses are extracted' check_report reports/q10.txt expected_q10
check 6 'Q11: date separators are converted' check_report reports/q11.txt expected_q11
check 6 'Q12: critical lines are printed in uppercase' check_report reports/q12.txt expected_q12
check 6 'Q13: header is inserted in output' check_report reports/q13.txt expected_q13
check 6 'Q14: footer is appended in output' check_report reports/q14.txt expected_q14
check 6 'Q15: characters are transliterated' check_report reports/q15.txt sed 'y/cb/ba/' animals.txt
check 10 'Challenge: DEBUG is removed, lines numbered, ERROR replaced' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1
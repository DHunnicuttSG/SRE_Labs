#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/awk_practice"
score=0
total=100

if ! command -v gawk >/dev/null 2>&1; then
  printf 'GNU awk (gawk) is required to grade this lab.\n' >&2
  exit 1
fi

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
  gawk '!/DEBUG/ {gsub(/ERROR/, "ERR"); printf "%5d\t%s\n", NR, $0}' log.txt | head -n 10
}

printf 'Checking awk exercise reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1

check 6 'Q1: ERROR matches include original line numbers' check_report reports/q01.txt gawk '/ERROR/ {print NR ":" $0}' log.txt
check 6 'Q2: ERROR lines are counted' check_report reports/q02.txt gawk '/ERROR/ {count++} END {print count+0}' log.txt
check 6 'Q3: warning count ignores case' check_report reports/q03.txt gawk 'BEGIN {IGNORECASE=1} /warning/ {count++} END {print count+0}' system.log
check 6 'Q4: access log client fields are selected' check_report reports/q04.txt gawk '{print $1}' access.log
check 6 'Q5: response sizes are summed' check_report reports/q05.txt gawk '{sum += $NF} END {print sum+0}' access.log
check 6 'Q6: status and request are printed' check_report reports/q06.txt gawk -F '"' '{split($3, fields, " "); print fields[1], $2}' access.log
check 6 'Q7: ERROR is replaced in log output' check_report reports/q07.txt gawk '{gsub(/ERROR/, "ERR"); print}' log.txt
check 6 'Q8: DEBUG lines are excluded' check_report reports/q08.txt gawk '!/DEBUG/' app.log
check 6 'Q9: only lines starting with ERROR are selected' check_report reports/q09.txt gawk '/^ERROR/' server.log
check 6 'Q10: IPv4 addresses are extracted' check_report reports/q10.txt gawk 'match($0, /([0-9]{1,3}\.){3}[0-9]{1,3}/) {print substr($0, RSTART, RLENGTH)}' access.log
check 6 'Q11: dates are reformatted' check_report reports/q11.txt gawk '{print gensub(/([0-9]{4})-([0-9]{2})-([0-9]{2})/, "\\1/\\2/\\3", "g")}' data.txt
check 6 'Q12: critical lines are uppercased' check_report reports/q12.txt gawk 'tolower($0) ~ /critical/ {print toupper($0)}' kernel.log
check 6 'Q13: log output has a header and footer' check_report reports/q13.txt gawk 'BEGIN {print "# Log Start"} {print} END {print "# Log End"}' log.txt
check 6 'Q14: animal lines are numbered and aligned' check_report reports/q14.txt gawk '{printf "%5d\t%s\n", NR, $0}' animals.txt
check 6 'Q15: log levels are counted in sorted order' check_report reports/q15.txt gawk '{count[$3]++} END {n=asorti(count, keys); for (i=1; i<=n; i++) printf "%s %d\n", keys[i], count[keys[i]]}' log.txt
check 10 'Challenge: DEBUG excluded, ERROR replaced, original lines numbered, first ten shown' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1
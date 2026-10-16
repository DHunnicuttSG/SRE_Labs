#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/alias_practice"
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

check_alias() {
  local name="$1"
  local expected="alias $1='$2'"
  local actual
  actual="$(alias "$name" 2>/dev/null)" || return 1
  [[ "$actual" == "$expected" ]]
}

function_defined() {
  declare -F "$1" >/dev/null
}

logfind_rejects_missing_arguments() {
  local status
  logfind >/dev/null 2>&1
  status=$?
  [[ "$status" -eq 2 ]]
}

mkcd_rejects_wrong_argument_count() {
  local status
  mkcd >/dev/null 2>&1
  status=$?
  [[ "$status" -eq 2 ]]
}

printf 'Checking alias and function exercise in %s\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
if [[ ! -f "$lab_dir/aliases.sh" ]]; then
  printf 'aliases.sh not found. Complete the student exercise first.\n' >&2
  exit 1
fi

cd "$lab_dir" || exit 1
source aliases.sh

check 6 'll alias definition' check_alias ll 'ls -alF --color=auto'
check 6 'errors alias definition' check_alias errors 'grep --color=never -i -n -C 1 -- "error"'
check 6 't100 alias definition' check_alias t100 'tail -n 100'
check 6 'dfh alias definition' check_alias dfh 'df -h'
check 8 'Q1: errors alias report matches the app log' check_report reports/q01.txt grep --color=never -i -n -C 1 -- error logs/app.log
check 6 'logfind function is defined' function_defined logfind
check 12 'Q2: logfind searches multiple files with context' check_report reports/q02.txt logfind database logs/app.log logs/api.log
check 5 'logfind rejects missing arguments with status 2' logfind_rejects_missing_arguments
check 6 'mkcd function is defined' function_defined mkcd
check 12 'Q3: mkcd created the requested directory and report' test -d work/incident-notes
check 5 'Q3: reported path is correct' check_report reports/q03.txt printf '%s\n' "$lab_dir/work/incident-notes"
check 5 'mkcd rejects a missing argument with status 2' mkcd_rejects_wrong_argument_count
check 17 'Challenge: logfind locates the API timeout with context' check_report reports/challenge.txt logfind timeout logs/api.log

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed definitions and reports, source aliases.sh again, and rerun the grader.\n'
exit 1
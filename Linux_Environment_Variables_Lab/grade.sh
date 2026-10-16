#!/usr/bin/env bash
set -uo pipefail

lab_dir="${HOME:?HOME must be set}/environment_variables_practice"
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

expected_local_export() {
  SUPPORT_NOTE=triage-only
  printf 'parent=%s\n' "$SUPPORT_NOTE"
  bash -c 'printf "child-before-export=%s\n" "${SUPPORT_NOTE-unset}"'
  export SUPPORT_NOTE
  bash -c 'printf "child-after-export=%s\n" "$SUPPORT_NOTE"'
}

expected_command_override() {
  APP_LOG_LEVEL=debug bash -c 'printf "child=%s\n" "$APP_LOG_LEVEL"'
  printf 'parent=%s\n' "$APP_LOG_LEVEL"
}

expected_unset_default() {
  env -u APP_REGION bash -c 'printf "child=%s\n" "${APP_REGION:-region-not-set}"'
  printf 'parent=%s\n' "$APP_REGION"
}

expected_status_capture() {
  false
  printf 'exit_status=%s\n' "$?"
}

expected_challenge() {
  env -u APP_CONFIG APP_ENV=staging APP_LOG_LEVEL=error ./bin/lab-health
}

printf 'Checking environment-variable exercise reports in %s/reports\n\n' "$lab_dir"
if [[ ! -d "$lab_dir" ]]; then
  printf 'Exercise directory not found. Run setup.sh or start the Docker lab first.\n' >&2
  exit 1
fi
cd "$lab_dir" || exit 1
source "$lab_dir/lab-env.sh"

check 10 'Q1: APP_ENV is printed' check_report reports/q01.txt printenv APP_ENV
check 10 'Q2: exported APP_ variables are sorted' check_report reports/q02.txt bash -o pipefail -c 'env | grep "^APP_" | LC_ALL=C sort'
check 10 'Q3: child visibility changes after export' check_report reports/q03.txt expected_local_export
check 10 'Q4: command-scoped override leaves parent unchanged' check_report reports/q04.txt expected_command_override
check 10 'Q5: PATH resolves lab-health' check_report reports/q05.txt command -v lab-health
check 10 'Q6: unset default is scoped to child process' check_report reports/q06.txt expected_unset_default
check 10 'Q7: effective service environment is reported' check_report reports/q07.txt ./bin/lab-health
check 10 'Q8: config file values can be inspected' check_report reports/q08.txt grep -E '^(#|APP_)' config/runtime.conf
check 10 'Q9: command exit status is captured' check_report reports/q09.txt expected_status_capture
check 10 'Challenge: temporary overrides and unset config are reflected' check_report reports/challenge.txt expected_challenge

printf '\nScore: %d/%d\n' "$score" "$total"
if (( score == total )); then
  printf 'Exercise complete.\n'
  exit 0
fi

printf 'Review failed reports and rerun the grader.\n'
exit 1

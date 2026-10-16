# Instructor Notes

## Learning objectives

Students distinguish shell variables from exported environment variables; understand inheritance by child processes; apply command-scoped overrides; inspect executable resolution through `PATH`; handle unset variables with parameter expansion; capture command exit status; and reason about the relationship between application config files and process environments.


```sh
## Answer key

From `~/environment_variables_practice` in the initialized lab shell:

```sh
printenv APP_ENV | tee reports/q01.txt
parent=triage-only
{
  SUPPORT_NOTE=triage-only
  printf 'parent=%s\n' "$SUPPORT_NOTE"
  bash -c 'printf "child-before-export=%s\n" "${SUPPORT_NOTE-unset}"'
  export SUPPORT_NOTE
  bash -c 'printf "child-after-export=%s\n" "$SUPPORT_NOTE"'
} | tee reports/q03.txt
{
  APP_LOG_LEVEL=debug bash -c 'printf "child=%s\n" "$APP_LOG_LEVEL"'
  printf 'parent=%s\n' "$APP_LOG_LEVEL"
} | tee reports/q04.txt
command -v lab-health | tee reports/q05.txt
{
  env -u APP_REGION bash -c 'printf "child=%s\n" "${APP_REGION:-region-not-set}"'
  printf 'parent=%s\n' "$APP_REGION"
} | tee reports/q06.txt
./bin/lab-health | tee reports/q07.txt
{
false; command_status=$?; printf 'exit_status=%s\n' "$command_status" | tee reports/q09.txt
	env -u APP_REGION bash -c 'printf "child=%s\\n" "${APP_REGION:-region-not-set}"'
```

Q3 output is `parent=triage-only`, `child-before-export=unset`, and `child-after-export=triage-only`. Q4 output is `child=debug` then `parent=warning`. Q6 output is `child=region-not-set` then `parent=us-east-1`. Q7 reports the effective runtime environment. The challenge report contains staging/error and `config=unset` while retaining the other inherited values.
	printf 'parent=%s\\n' "$APP_REGION"
} | tee reports/q06.txt
child-after-export=triage-only
```

Q4 output is `child=debug` then `parent=warning`. Q6 output is `child=region-not-set` then `parent=us-east-1`. Q7 is the standard runtime report. The challenge report contains staging/error and `config=unset` while retaining the other inherited values.

## Grading

The grader compares nine reports and one challenge report against expected output generated from the fixture. Each question is worth 10 points, for 100 total. It validates output, not command history. Observe or ask students to demonstrate their command choices if evidence of the shell operations is required.

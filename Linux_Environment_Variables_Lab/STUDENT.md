# Student Exercise: Linux Environment Variables

## Goal

Practice inspecting exported variables, checking what child processes inherit, applying command-scoped overrides, diagnosing executable lookup through `PATH`, and reasoning about configuration precedence without exposing secrets.

The fixtures use fake values for a sample `payments-api` service. Do not add real passwords, tokens, or cloud credentials to the reports. Start by confirming the workspace and fixtures:

```sh
pwd
ls
```

Save each command's output while displaying it with `| tee reports/name.txt`. For example:

```sh
printenv APP_ENV | tee reports/q01.txt
```

The lab shell loads values from `lab-env.sh`. In a local Bash session, source it as described in `README.md`. In Docker, it is already loaded. Reports are checked for correct output; the grader cannot prove which commands you typed.

## Exercises

1. Print the value of `APP_ENV`. Save it to `reports/q01.txt`.
2. Show only exported variables whose names begin with `APP_`, sorted by name. Save to `reports/q02.txt`.
3. In one shell command, assign `SUPPORT_NOTE=triage-only` without exporting it, show that the parent shell sees it but a child Bash does not, then export it and show that a child Bash now sees it. Label the three lines `parent`, `child-before-export`, and `child-after-export`. Save to `reports/q03.txt`.
4. Run a child command with `APP_LOG_LEVEL=debug` set only for that command. Show the child's value and then the unchanged parent value. Label the lines `child` and `parent`. Save to `reports/q04.txt`.
5. Use command lookup to print the path Bash resolves for `lab-health`. Save to `reports/q05.txt`.
6. In a child command, remove `APP_REGION` from that process environment and print `region-not-set` when it is unset. Then print the parent's `APP_REGION` to show it is unchanged. Label the lines `child` and `parent`. Save to `reports/q06.txt`.
7. Run `./bin/lab-health` and save its effective runtime settings to `reports/q07.txt`.
8. Show the comments and `APP_` assignments in `config/runtime.conf`. Save to `reports/q08.txt`. Compare its file values with the process values from Q7: what evidence indicates the service environment overrides the file values in this fixture?
9. Run a harmless failing command, capture its exit status immediately, and print it as `exit_status=<value>`. Save to `reports/q09.txt`. `$?` is a shell special parameter, not an environment variable.

## Challenge

Launch `lab-health` with `APP_ENV=staging` and `APP_LOG_LEVEL=error` for that process only, while leaving `APP_CONFIG` unset for the process. Save the output to `reports/challenge.txt`. Then explain which values came from the parent shell, which were overridden, and why the config path is reported as unset.

## Production support notes

- `printenv NAME` shows an exported environment variable; a shell variable that is not exported is not automatically visible to child processes.
- A command-scoped assignment such as `NAME=value command` is temporary for that command and its children. It does not update the current shell.
- `PATH` is ordered. Prepend or append directories while preserving the existing value; do not replace it casually during incident response.
- Useful host/session context includes `USER`, `LOGNAME`, `HOME`, `PWD`, `SHELL`, `HOSTNAME`, `UID`, `EUID`, `LANG`, `TERM`, and `TMPDIR`. Cloud and remote-session variables such as `AWS_REGION`, `AWS_PROFILE`, `SSH_CLIENT`, and `SSH_TTY` may be absent or differ between login methods.
- `$?`, `$$`, `$PPID`, `$0`, and positional parameters such as `$1` are shell parameters, not environment variables. Capture `$?` before another command overwrites it.
- An unset variable is not the same as an empty variable. `${NAME:-default}` uses the default for either; `${NAME-default}` uses it only when unset.
- A variable affects an application only if the application or its launcher reads it. A `KEY=value` file is not automatically loaded by Bash or every service manager.
- Startup files such as `~/.bashrc` and `/etc/profile` have different scope and loading rules. For services, inspect the actual service manager configuration and process environment before changing persistent settings.
- Treat environment dumps as sensitive: they can contain credentials. Prefer printing named, non-secret variables and redact values before sharing incident output.

Run the grader from any directory:

```sh
bash /opt/environment-variables-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Linux_Environment_Variables_Lab/grade.sh`.

# Student Exercise: Bash Aliases and Functions

## Goal

Create and use Bash aliases for common, fixed shortcuts, then write functions for commands that need arguments or validation. Apply them to the sample support logs in `~/alias_practice`; do not add shortcuts that stop services, kill processes, or modify files.

Begin in the workspace:

```bash
cd ~/alias_practice
ls
```

Edit `aliases.sh` with a text editor. After saving changes, load them into the current shell with:

```bash
source ~/alias_practice/aliases.sh
```

Sourcing runs the file in the current shell, so its aliases and functions become available there. It does not install them permanently. To make a trusted personal file load in future interactive Bash sessions, you could add a `source` line to `~/.bashrc`; this lab intentionally does not edit that file.

## Easy: Fixed shortcuts

Add these aliases to `aliases.sh`:

1. `ll` for a detailed, human-readable directory listing with file types and automatic color.
2. `errors` for case-insensitive `error` matches with line numbers and one line of context, without forced color.
3. `t100` for the last 100 lines of a file.
4. `dfh` for human-readable filesystem capacity.

Source the file, then inspect definitions with `alias` and `type`. Run `errors logs/app.log` and save its output to `reports/q01.txt` using `tee`.

## Intermediate: Write a log-search function

Aliases are simple text substitutions; they do not provide their own positional parameters or argument validation. Write a `logfind` function in `aliases.sh` that:

- Requires a search expression and at least one filename. With too few arguments, print a usage line to standard error and return status 2.
- Searches case-insensitively, includes line numbers and one line of context, and accepts one or more filenames.
- Passes the search expression and filenames as quoted arguments so spaces and filenames beginning with `-` are handled safely. Use `--` before user-provided search text.

Source the file again. Search for `database` in both sample logs and save the output to `reports/q02.txt`:

```bash
logfind database logs/app.log logs/api.log | tee reports/q02.txt
```

Try `logfind` with no arguments and check its status with `echo "$?"`.

## Advanced: Write a directory function

Write an `mkcd` function that requires exactly one directory argument, creates missing parent directories, and changes the current shell into that directory. Quote the argument and use `--` with `mkdir` and `cd`. With an incorrect number of arguments, print usage to standard error and return status 2.

After sourcing the file, use the function and save the resulting path to `reports/q03.txt`:

```bash
mkcd work/incident-notes
pwd | tee ~/alias_practice/reports/q03.txt
```

Use `declare -F` to list your functions and `declare -f logfind` to inspect one definition.

## Challenge

Use `logfind` to find `timeout` in `logs/api.log`; save the result to `reports/challenge.txt`.

## Production-support notes

- Prefer shortcuts that make read-only inspection faster: logs, process listings, disk and memory summaries, and connectivity checks.
- Verify the host, account, and target before running a command. An alias can hide important options and is not a security boundary.
- Avoid broad `kill` aliases/functions and automatic `sudo` shortcuts. `kill -9` prevents graceful cleanup; `sudo !!` can repeat a different command than intended.
- Aliases generally apply to interactive shells, not scripts. Functions are clearer for arguments, validation, branching, and reusable workflows.

## Submit

Run the grader:

```bash
bash /opt/alias-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Alias_Lab/grade.sh`. The grader checks definitions, function behavior, and report contents; it cannot prove which commands you typed. Be prepared to explain the difference between aliases and functions and how you loaded your definitions.
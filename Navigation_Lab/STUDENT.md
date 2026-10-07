# Student Exercise: Find Your Way Around Linux

## Goal

Practice moving between directories and making small, deliberate changes to a filesystem. Work in a Bash shell. Do not edit the starter files by opening them in an editor; use the shell commands in the exercise.

## 1. Orient yourself

- Use `pwd` to identify your current directory.
- Use `ls` to inspect it.
- Go to `/` with `cd`, then use `pwd` and `ls` to inspect the filesystem root.
- Use `cd` with `~` to return to your home directory. Use `pwd` to confirm.
- Navigate into `navigation_lab` and inspect its contents with `ls`.

## 2. Build the deliverables

Inside `navigation_lab`:

- Create two directories: `archive` and `deliverables`.
- Create an empty file named `checked.txt` inside `deliverables`.
- Copy `inbox/field-notes.txt` into `deliverables`, keeping the original in `inbox`.
- Move `inbox/old-map.txt` into `archive`.

## 3. Clean up

- Remove `work/draft.tmp`.
- Remove the empty directory `empty-room`.

## 4. Inspect and submit

Use `ls` to inspect the relevant directories. Confirm your current location with `pwd`, then run the grader from the project directory:

```sh
bash grade.sh
```

In Docker, use `bash /opt/navigation-lab/grade.sh` instead. The grader checks the final filesystem state; it cannot verify which commands you typed, so complete the navigation steps as part of the exercise.
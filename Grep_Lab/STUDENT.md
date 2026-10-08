# Student Exercise: Search Text with grep

## Goal

Practice literal searches, case-insensitive and inverted matches, line counts and numbers, recursive searches, regular expressions, context output, filename listing, and pipelines. Work in `~/grep_practice`; save each result in `reports/` so the grader can check it.

Start in the dataset directory and inspect its files:

```sh
cd ~/grep_practice
ls
```

Save a command's output while displaying it with `| tee reports/name.txt`. For example:

```sh
grep -i 'warning' system.log | tee reports/q02.txt
```

## Easy

1. Find lines containing the lowercase text `error` in `log.txt`. Save to `reports/q01.txt`.
2. Search for `warning` in `system.log`, ignoring case. Save to `reports/q02.txt`.
3. Count the lines containing `success` in `output.txt`, ignoring case. Save the count to `reports/q03.txt`.
4. Show line numbers for lines containing `failed` in `report.txt`. Save to `reports/q04.txt`.
5. Search recursively for `TODO` in Python files under `projects`. Save to `reports/q05.txt`.
6. Match `cat` as a whole word in `animals.txt`, not as part of a longer word. Save to `reports/q06.txt`.
7. Show lines in `app.log` that do not contain `DEBUG`. Save to `reports/q07.txt`.
8. Find lines beginning with `ERROR` in `server.log`. Save to `reports/q08.txt`.

## Advanced

9. Find lines in `system.log` containing either `error` or `fail`, ignoring case. Save to `reports/q09.txt`.
10. Extract IPv4 address strings from `access.log`, printing only each address. Save to `reports/q10.txt`.
11. Show three lines of context before and after each `critical` match in `kernel.log`, ignoring case. Save to `reports/q11.txt`.
12. Recursively list only filenames under `etc` whose contents include the literal string `port=8080`. Save to `reports/q12.txt`.
13. Extract dates in `YYYY-MM-DD` form from `data.txt`. Save to `reports/q13.txt`.

## Challenge

From `log.txt`, find lines that contain uppercase `ERROR` but not `DEBUG`; include line numbers and show no more than the first ten results. Use a pipeline and save the result to `reports/challenge.txt`.

## Submit

Run the grader from any directory:

```sh
bash /opt/grep-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Grep_Lab/grade.sh`. The grader checks report contents; it cannot prove which commands you typed. Be prepared to explain the options and regular expressions you used.
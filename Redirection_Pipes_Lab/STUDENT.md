# Student Exercise: Redirection and Pipes

## Goal

Practice redirecting standard output with `>` and `>>`, redirecting standard input with `<`, providing input with here-documents and here-strings, and chaining commands with `|`. Work in `~/redirection_practice`; save each result in `reports/` so the grader can check it.

Start in the exercise directory and inspect the fixtures:

```sh
cd ~/redirection_practice
ls
```

For each question, save the requested result with `tee reports/qNN.txt`. For example:

```sh
grep 'ERROR' events.log | tee reports/q07.txt
```

## Easy

1. Use `>` to create `hello.txt` containing exactly `Hello Linux`. Save its contents to `reports/q01.txt`.
2. Use `>>` to append `Learning redirection` to `hello.txt`. Save the complete file to `reports/q02.txt`.
3. Use `<` to sort the names in `names.txt`. Save the sorted output to `reports/q03.txt`.
4. Use a here-document with `cat` to print these three lines, in order: `North`, `South`, `West`. Save them to `reports/q04.txt`.
5. Use a here-string to pass `quick brown fox` to `wc -w`. Save the count to `reports/q05.txt`.
6. Use a pipeline to count the `.conf` files in `services/`. Save the count to `reports/q06.txt`.
7. Redirect lines containing `ERROR` from `events.log` into `errors.txt` with `>`. Save the contents of `errors.txt` to `reports/q07.txt`.

## Advanced

8. Append `task completed` to `activity.log` with `>>`. Save the complete log to `reports/q08.txt`.
9. Use `<` with `wc -l` to count the lines in `names.txt`. Save the count to `reports/q09.txt`.
10. Use a pipeline to select lines beginning with `ERROR` or `WARN` from `events.log`, then sort them. Save the result to `reports/q10.txt`.
11. Use a here-document as input to `grep` to select the line containing `WARN` from this input, and save the result to `reports/q11.txt`:

    ```text
    INFO service started
    WARN retrying database
    ERROR connection timeout
    ```

12. Use a pipeline to select names beginning with `M` or `O` from `names.txt`, then convert them to uppercase. Save the result to `reports/q12.txt`.
13. Use `grep` and a pipeline to list the `port=` lines from all `.conf` files in `services/`, sorted by numeric port. Save the result to `reports/q13.txt`.

## Challenge

Use a pipeline to count the `.conf` files in `services/`, and use `>` to save the count directly to `reports/challenge.txt`.

Run the grader from any directory:

```sh
bash /opt/redirection-pipes-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Redirection_Pipes_Lab/grade.sh`. The grader checks report contents; it cannot prove which commands you typed. Be prepared to explain the redirections and pipes you used.

> Note: `>>>` in the source lesson is not a valid Bash redirection operator. Use `>` to overwrite and `>>` to append.
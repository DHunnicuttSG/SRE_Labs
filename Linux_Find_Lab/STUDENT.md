# Student Exercise: Find and Locate Files

## Goal

Practice finding files by name, type, size, age, and permissions; combining predicates; using `-exec`; and searching an index with `locate`. Work in `~/find_practice`; save each result in `reports/` so the grader can check it.

Start in the exercise directory and inspect the fixture tree:

```sh
cd ~/find_practice
find tree -maxdepth 2 -print
```

For each question, save the result with `tee reports/qNN.txt`. Quote filename patterns so the shell passes them to `find` or `locate` unchanged.

## Easy

1. Find regular files whose names end in `.conf`, case-sensitively. Sort the paths and save them to `reports/q01.txt`.
2. Find regular files with a case-insensitive `.md` suffix. Sort the paths and save them to `reports/q02.txt`.
3. List all directories under `tree`, including `tree` itself. Sort the paths and save them to `reports/q03.txt`.
4. Find regular files larger than 50 bytes. Sort the paths and save them to `reports/q04.txt`.
5. Find regular files modified more than seven days ago. Sort the paths and save them to `reports/q05.txt`.
6. Find regular files whose permissions are exactly `640`. Save the paths to `reports/q06.txt`.
7. Find regular files ending in `.conf` or `.log`. Use parentheses to group the alternatives, sort the paths, and save them to `reports/q07.txt`.
8. Find empty files under `tree`. Sort the paths and save them to `reports/q08.txt`.

## Advanced

9. Find shell scripts under `tree/scripts` and use `-exec basename {} \;` to print only their names. Sort the output and save it to `reports/q09.txt`.
10. Use the prebuilt locate database to find paths ending in `.conf`. Sort the output and save it to `reports/q10.txt`:

    ```sh
    locate -d locate.db '*.conf'
    ```

11. Create a non-empty `tree/incoming/new-note.txt`. Before updating the index, search for it with `locate -d locate.db 'new-note.txt'` and observe that it is not returned. Refresh the lab database with `updatedb --localpaths="$PWD/tree" --output="$PWD/locate.db"`, then locate the new file and save the result to `reports/q11.txt`.

## Challenge

The fixture contains one `.tmp` file under `tree/tmp`. First preview the matching path with `find` and save that output to `reports/challenge.txt`. Inspect the report, then use `find` with `-delete` to remove only matching `.tmp` files from `tree/tmp`. Never run a destructive `find` command until you have checked its exact search path and previewed its matches.

Run the grader from any directory:

```sh
bash /opt/linux-find-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Linux_Find_Lab/grade.sh`. The grader checks report contents and the challenge result; it cannot prove which commands you typed. Be prepared to explain why `find` sees current filesystem state while `locate` can be stale until its database is refreshed.

## Useful Admin Notes

- `find` starts at the path you give it. Limit searches to the directory you intend; searching `/` can be slow and noisy.
- `-mtime +7` means more than seven 24-hour periods ago, rounded down to whole days. For `-size`, `c` means bytes; `+50c` means strictly greater than 50 bytes.
- `-perm 0640` matches that exact mode. GNU find also supports tests such as `-perm -u+w` for required permission bits.
- Use `-print0` with `xargs -0` when piping arbitrary filenames, because filenames can contain spaces or newlines.
- Preview a destructive search without `-delete` first. `-exec command {} \;` runs once per match; `-exec command {} +` batches matches when the command supports it.
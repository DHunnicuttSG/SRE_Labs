# Student Exercise: Hard Links, Symbolic Links, and Inodes

## Goal

Practice identifying shared inode data, checking link counts, finding paths to the same inode, resolving relative symlinks, diagnosing dangling links, and removing a link without deleting its target. Work in `~/links_practice`; save each result in `reports/` with `tee`.

Start in the fixture directory:

```sh
cd ~/links_practice
find . -maxdepth 3 -print
```

## Easy

1. Create a hard link at `evidence/service-hard.log` to `data/service.log`. Use `stat` to save each path's inode, link count, and name to `reports/q01.txt`, sorted by path.
2. Confirm the two paths have the same inode and save `inode=<number> links=2` to `reports/q02.txt`.
3. Append `2026-10-16T09:15:00Z WARN retry scheduled` through `evidence/service-hard.log`. Read `data/service.log` and save its full contents to `reports/q03.txt`.
4. Use `find -samefile` to list all paths in `data/` and `evidence/` that reference the inode of `evidence/service-hard.log`. Sort and save the paths to `reports/q04.txt`.
5. Remove only `data/service.log`. Verify the evidence link remains, has one hard link, and still reads the log. Save `remaining hard links=1` followed by its contents to `reports/q05.txt`.

## Advanced

6. Create `links/config-current.conf` as a relative symlink to `../releases/v1/app.conf`. Save the stored target text with `readlink` to `reports/q06.txt`.
7. Read `links/config-current.conf` and save the resolved configuration contents to `reports/q07.txt`.
8. Create a staged symlink named `links/config-next.conf` to `../releases/v2/app.conf`, then atomically rename it over `links/config-current.conf` with `mv -Tf`. Save the new target text and contents to `reports/q08.txt`.
9. Create `links/next.conf` as a symlink to the not-yet-created `../releases/v3/app.conf`. Use `-L` and `-e` tests to verify the link exists but its target does not; save `symlink exists; target missing` to `reports/q09.txt`.
10. Create `releases/v3/app.conf` with these two lines, then read it through `links/next.conf` and save the result to `reports/q10.txt`:

    ```text
    release=v3
    service=payments
    ```

## Challenge

Remove `links/config-current.conf` without removing `releases/v2/app.conf`. Save `link removed; target retained` to `reports/challenge.txt` only after verifying the link path is absent and the target file remains.

Run the grader with:

```sh
bash /opt/hard-soft-links-lab/grade.sh
```

For a local Bash run, use `bash /path/to/Hard_Soft_Links_Lab/grade.sh`. The grader checks report contents and resulting filesystem state; it cannot prove which commands you typed. Be prepared to explain why deleting one hard-link name does not necessarily delete file data, and why deleting a symlink is different from deleting its target.
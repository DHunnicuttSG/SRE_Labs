# Student Exercise: Linux File Permissions

## Goal

Practice reading and changing Linux permissions, changing ownership and group ownership, and using `umask`. Work only inside `~/permissions_lab`. This disposable container grants the `student` account passwordless sudo so ownership exercises work without changing the host.

Permission values are `r = 4`, `w = 2`, and `x = 1`. Each octal digit is the sum for owner, group, or others. For example, `640` means owner read/write, group read, and no access for others. Use `ls -l`, `ls -ld`, and `stat` to inspect results.

## 1. Set file permissions

In `~/permissions_lab/files`:

- Set `report.txt` to owner read/write, group read, others read (`644`).
- Set `secret.txt` so only its owner can read and write (`600`).
- Set `team_notes.txt` so owner and group can read/write, with no access for others (`660`).
- Ensure `backup.sh` is executable by everyone (`755`).

Use numeric mode for `report.txt` and `secret.txt`, and symbolic mode for `team_notes.txt` and `backup.sh`. Verify with `ls -l`.

## 2. Secure and share directories

In `~/permissions_lab/directories`:

- Set `finance` so only its owner can read, write, and enter it (`700`). Remember that directory execute permission allows traversal.
- Configure `projectA` for full owner and group access, with no access for others (`770`). Set its group to `developers` and verify with `ls -ld`.

## 3. Change owner and group

For `~/permissions_lab/files/inventory.txt`:

- Change the owner to `student1`.
- Change the group to `developers`.
- Verify both names with `ls -l` or `stat`.

Use `sudo` for the ownership change. This account has sudo only inside the lab container.

## 4. Apply symbolic changes

The file `~/permissions_lab/symbolic/file.txt` starts at `rw-r-----` (`640`). Using symbolic `chmod` only:

- Add group write.
- Add read for others.
- Remove owner write.

Verify the resulting mode is `464` (`r--rw-r--`).

## 5. Set a default creation mask

In `~/permissions_lab/umask`:

- Display the current mask, then set it to `027`.
- Create `new-file.txt` and `new-directory`.
- Inspect both with `ls -l` and `ls -ld`.
- Explain why the file is not executable and which permissions the mask removes.

Expected modes are `640` for the file and `750` for the directory. Files normally start from `666` and directories from `777` before the mask removes permissions.

## 6. Troubleshoot and convert

- In `~/permissions_lab/troubleshooting`, fix `backup.sh`, which starts without execute permission. Grant only the owner execute access and verify the final mode is `744`.
- In `~/permissions_lab/conversion`, convert each permission string written in the file to its octal mode, then set that file to the matching mode. For example, the file named `750.txt` corresponds to `rwxr-x---`.

## 7. Stretch: symbolic notation only

Set the permissions of the files in `~/permissions_lab/stretch` using symbolic notation only:

| File | Target mode |
|---|---:|
| `640.txt` | 640 |
| `755.txt` | 755 |
| `700.txt` | 700 |
| `775.txt` | 775 |

## 8. Submit

Run the grader from any directory:

```sh
bash /opt/permissions-lab/grade.sh
```

The grader checks final modes and ownership; it cannot prove which commands you used. Be prepared to demonstrate the symbolic changes and explain your `umask` results.
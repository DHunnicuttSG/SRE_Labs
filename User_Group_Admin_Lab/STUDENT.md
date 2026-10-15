# Student Exercise: Linux User and Group Administration

## Goal

Practice creating a group, adding existing users without replacing their current groups, assigning group ownership, setting directory permissions, and checking setgid and `umask` behavior. The lab uses isolated accounts named `lab_alice`, `lab_bob`, and `lab_auditor`, and the group `project_team`.

Work in `/opt/user_group_admin_practice`. Save each requested result in `reports/` with `tee`; for example:

```sh
getent group project_team | cut -d: -f1 | tee reports/q01.txt
```

The Docker lab opens a root shell, so run commands without `sudo`. If using a disposable VM, complete the exercise in a root shell. Do not run this exercise on a shared or production system.

## Easy

1. Create the `project_team` group. Verify it exists and save only its group name to `reports/q01.txt`.
2. Add `lab_alice` to `project_team` with `usermod -aG`. Use `id` to verify the new membership and save only `project_team` to `reports/q02.txt`. The `-a` option preserves the user's existing supplementary groups.
3. Add `lab_bob` to `project_team`. List and sort the group's member names, saving them to `reports/q03.txt`.
4. Assign `project_team` as the group owner of `shared_project/`. Save the directory's group name to `reports/q04.txt`.
5. Give the directory owner and group full access, with no access for others, using mode `770`. Save the numeric and symbolic permissions to `reports/q05.txt`.
6. Set the setgid bit on `shared_project/`. Save its numeric and symbolic permissions to `reports/q06.txt`.
7. Start a shell as `lab_alice` and create `created_by_alice.txt` inside `shared_project/`. Save the new file's owner and group to `reports/q07.txt`.
8. Start a shell as `lab_bob`, set that shell's `umask` to `002`, and create `group_writable.txt` inside `shared_project/`. Save its numeric and symbolic permissions to `reports/q08.txt`.

## Advanced

9. Use `id` to verify that `lab_auditor` is not a member of `project_team`. Save exactly `not a member` to `reports/q09.txt`.
10. Set `private_project/budget.txt` to mode `640`. Save its numeric and symbolic permissions to `reports/q10.txt`.
11. Set `shared_project/README.txt`'s group to `project_team`, then use symbolic `chmod` to give the group read/write and remove all permissions for others. Save its group and numeric mode to `reports/q11.txt`.
12. Run read and write checks on `shared_project/README.txt` as `lab_alice`. Save `read-write` to `reports/q12.txt` only when both checks succeed.

## Challenge

Use `find` and a pipeline to list each regular file directly inside `shared_project/` as `filename:group`, sorted by filename. Save the result to `reports/challenge.txt`. All files in the shared directory should inherit or be assigned to `project_team`.

Run the grader with:

```sh
bash /opt/user-group-admin-lab/grade.sh
```

The grader checks report contents and resulting account/filesystem state; it cannot prove which commands you typed. Be ready to explain why `usermod -aG`, setgid on a directory, and a `002` umask are useful for team collaboration.
# Instructor Notes

## Learning objectives

Students create and inspect groups; add existing users as supplementary members; distinguish user, group, and other permissions; assign group ownership; use numeric and symbolic `chmod`; set the setgid bit on a shared directory; configure a session's `umask`; and verify access as a non-root user.

## Environment and safety

The Docker image runs as root because account and group administration require it. The container is disposable and does not mount host directories. The optional local setup is for a disposable Linux VM only: it creates `lab_alice`, `lab_bob`, `lab_auditor`, and `project_team` on that system, and leaves them in place. Setup refuses to use existing names or overwrite its exercise directory.

The work area is `/opt/user_group_admin_practice`; `reports/` is separate from the shared project directory. Each exercise user receives a private primary group during setup. `project_team` does not exist until the student creates it.

## Answer key

Run in `/opt/user_group_admin_practice` as root:

```sh
groupadd project_team
getent group project_team | cut -d: -f1 | tee reports/q01.txt

usermod -aG project_team lab_alice
id -nG lab_alice | tr ' ' '\n' | grep -Fx project_team | tee reports/q02.txt

usermod -aG project_team lab_bob
getent group project_team | cut -d: -f4 | tr ',' '\n' | sort | tee reports/q03.txt

chown :project_team shared_project
stat -c '%G' shared_project | tee reports/q04.txt

chmod 770 shared_project
stat -c '%a %A' shared_project | tee reports/q05.txt

chmod g+s shared_project
stat -c '%a %A' shared_project | tee reports/q06.txt

su -s /bin/bash lab_alice -c 'printf "created by alice\\n" > /opt/user_group_admin_practice/shared_project/created_by_alice.txt'
stat -c '%U %G' shared_project/created_by_alice.txt | tee reports/q07.txt

su -s /bin/bash lab_bob -c 'umask 002; printf "created by bob\\n" > /opt/user_group_admin_practice/shared_project/group_writable.txt'
stat -c '%a %A' shared_project/group_writable.txt | tee reports/q08.txt

if id -nG lab_auditor | tr ' ' '\n' | grep -Fxq project_team; then printf 'member\\n'; else printf 'not a member\\n'; fi | tee reports/q09.txt

chmod 640 private_project/budget.txt
stat -c '%a %A' private_project/budget.txt | tee reports/q10.txt

chown :project_team shared_project/README.txt
chmod g+rw,o-rwx shared_project/README.txt
stat -c '%G %a' shared_project/README.txt | tee reports/q11.txt

su -s /bin/bash lab_alice -c 'test -r /opt/user_group_admin_practice/shared_project/README.txt && test -w /opt/user_group_admin_practice/shared_project/README.txt && printf "read-write\\n"' | tee reports/q12.txt

LC_ALL=C find shared_project -maxdepth 1 -type f -printf '%f:%G\\n' | LC_ALL=C sort | tee reports/challenge.txt
```

## Grading

The grader awards 100 points for twelve 7-point checks and a 16-point challenge. It verifies reports against known expected values and checks group membership and resulting permissions through command output. This validates state, not command history; observe or ask students to demonstrate the required commands when command-use evidence matters. The grader is visible teaching material, not a tamper-resistant assessment system.

`usermod -aG group user` appends a supplementary group; omitting `-a` replaces the user's supplementary group list. Group membership is evaluated when a process starts, so the lab uses a fresh `su` session to test access. On directories, setgid causes newly created entries to inherit the directory's group. A `002` umask removes only owner/group write bits from the usual creation modes, yielding `664` for regular files created with mode `666`. It is a per-process setting; persistent defaults should be configured through the appropriate user or system profile policy, not by editing a shared file during this exercise.
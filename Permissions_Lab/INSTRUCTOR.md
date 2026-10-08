# Instructor Notes

## Learning objectives

Students inspect permission strings; use symbolic and octal `chmod`; understand file versus directory execute access; change owner and group with `chown` and `chgrp`; and predict file and directory modes from `umask`.

## Environment

The Compose lab uses Ubuntu 24.04 and runs as the non-root `student` account. It creates `student1` and the `developers` group, with both accounts in that group. Passwordless sudo is confined to the disposable container so learners can practice ownership changes. No host paths are mounted.

## Answer key

From the student home directory:

```sh
cd ~/permissions_lab/files
chmod 644 report.txt
chmod 600 secret.txt
chmod g+rw,o-rwx team_notes.txt
chmod a+x backup.sh

cd ../directories
chmod 700 finance
chmod 770 projectA
chgrp developers projectA

cd ../files
sudo chown student1 inventory.txt
sudo chgrp developers inventory.txt

cd ../symbolic
chmod g+w file.txt
chmod o+r file.txt
chmod u-w file.txt

cd ../umask
umask
umask 027
touch new-file.txt
mkdir new-directory

cd ../troubleshooting
chmod u+x backup.sh

cd ../conversion
chmod 750 750.txt
chmod 664 664.txt
chmod 777 777.txt
chmod 400 400.txt

cd ../stretch
chmod u=rw,g=r,o= 640.txt
chmod u=rwx,g=rx,o=rx 755.txt
chmod u=rwx,g=,o= 700.txt
chmod u=rwx,g=rwx,o=rx 775.txt
```

Expected umask results are `640` for a newly created regular file and `750` for a directory. Files are created without execute bits by default (`666`); `027` removes group write and all permissions for others. With `022`, the corresponding defaults are `644` and `755`.

Optional combined sudo challenge: set `~/permissions_lab/combined/backup.sh` to mode `700`, change its owner to root, then run it with sudo. Its output should report `root`.

## Grading

The shell grader awards 100 points for the expected modes and ownership. It verifies the end state, not command history; observe or ask students to demonstrate command usage if that is part of the assessment. The grader and initialization script are visible teaching materials, not a tamper-resistant assessment system.
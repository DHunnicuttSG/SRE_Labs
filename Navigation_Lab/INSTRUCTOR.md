# Instructor Notes

## Learning objectives

Students practice `cd`, `pwd`, `/`, `~`, and `ls`, then use `mkdir`, `touch`, `cp`, `mv`, `rm`, and `rmdir` to reach a specified filesystem state.

## Answer key

From the student's home directory:

```sh
pwd
ls
cd /
pwd
ls
cd ~
pwd
cd ~/navigation_lab
ls
mkdir archive deliverables
touch deliverables/checked.txt
cp inbox/field-notes.txt deliverables/field-notes.txt
mv inbox/old-map.txt archive/old-map.txt
rm work/draft.tmp
rmdir empty-room
ls -R .
```

Run the grader from the lab project directory. In Docker, run `bash /opt/navigation-lab/grade.sh`; in a native Bash setup, run `bash grade.sh` from this project directory.

## Grading

The shell grader awards 100 points for the expected end state: created directories, a correct copy with the original retained, an empty marker file, a correctly moved file, and removed file/directory targets. It exits with status 0 only for a full score. The filesystem alone cannot establish whether students used a particular command or navigated through `/` and `~`; assess those steps through observation, a short demonstration, or a submitted terminal transcript if command-use evidence is required.

The grader and initialization script are intentionally visible teaching materials, not a tamper-resistant assessment system.
# Linux Hard and Soft Links Lab

A production-support practice lab for understanding inode identity, hard-link counts, symbolic-link targets, dangling links, release pointers, and safe cleanup. It runs in a disposable Docker container or in a Linux Bash shell.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build hard-soft-links-lab
docker compose run --rm hard-soft-links-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/hard-soft-links-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and production-support notes.

## Run in Linux or WSL

The local run requires real Unix hard-link and symlink behavior. Git Bash on Windows may emulate symlinks as ordinary files; use Docker Desktop or WSL instead. From this directory, initialize the exercise in your home directory:

```sh
bash setup.sh
```

Complete `STUDENT.md`, then grade the reports from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/links_practice`. Remove that exercise directory yourself to start over.

## Source lesson

- [Hard links, soft links, and inodes](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Hard_Links-Soft_Links_and_Inodes.md#L4)
# Linux Find and Locate Lab

A self-contained command-line lab for traversing directory trees, matching files by metadata, combining predicates, safely acting on matches, and comparing `find` with the indexed `locate` command. It works in Docker or a Linux Bash shell, including WSL.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build linux-find-lab
docker compose run --rm linux-find-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/linux-find-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Run in a Linux Bash shell

Install GNU findutils first; it provides `find`, `locate`, and `updatedb`. From this directory, initialize the exercise in your home directory:

```sh
bash setup.sh
```

Complete `STUDENT.md`, then grade the reports from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/find_practice`. Remove that exercise directory yourself to start over.

## Source lesson

- [Find and Locate](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/3.4-Find_Locate.md)
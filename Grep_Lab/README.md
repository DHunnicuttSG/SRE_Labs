# Linux Grep Lab

A self-contained command-line lab for searching logs, source files, and configuration files with `grep`. It includes a local copy of the linked practice dataset and works in Docker or a Linux Bash shell, including WSL.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build grep-lab
docker compose run --rm grep-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/grep-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Run in a Linux Bash shell

From this directory, initialize the exercise in your home directory:

```sh
bash setup.sh
```

Complete `STUDENT.md`, then grade the reports from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/grep_practice`. Remove that exercise directory yourself to start over.

## Source lessons

- [Using the grep Command in Linux](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.1-Grep.md)
- [Grep Practice Worksheet](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.1.1-grep_worksheet_Q_Only.md)
- [Grep Practice Dataset](https://github.com/DHunnicuttSG/SRE/tree/main/Linux/Grep_Exercise/grep_practice)
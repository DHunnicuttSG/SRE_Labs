# Linux Awk Lab

A self-contained command-line lab for processing structured text, calculating summaries, and analyzing logs with `awk`. It uses the same practice dataset as the worksheet and works in Docker or a Linux Bash shell, including WSL. GNU awk (`gawk`) is required for several worksheet exercises.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build awk-lab
docker compose run --rm awk-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/awk-lab/grade.sh
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

Setup refuses to overwrite an existing `~/awk_practice`. Remove that exercise directory yourself to start over. Install GNU awk (`gawk`) if it is not already available.

## Source lessons

- [Using the awk Command in Linux](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.3-awk.md)
- [Awk Practice Worksheet](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/6.3.1-awk_worksheet.md)
# Linux Redirection and Pipes Lab

A self-contained command-line lab for directing command input and output with Bash redirections and composing commands with pipes. It runs in Docker or a Linux Bash shell, including WSL.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build redirection-pipes-lab
docker compose run --rm redirection-pipes-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/redirection-pipes-lab/grade.sh
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

Setup refuses to overwrite an existing `~/redirection_practice`. Remove that exercise directory yourself to start over.

## Source lesson

- [Redirection and Pipes in Linux](https://github.com/DHunnicuttSG/SRE/blob/main/Linux/Advanced/Redirection_and_Pipes.md)
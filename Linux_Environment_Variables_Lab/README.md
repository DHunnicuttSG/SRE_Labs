# Linux Environment Variables Lab

A self-contained Linux command-line lab on environment variables in production support. It covers exported process environments, child processes, temporary overrides, `PATH`, unset-variable defaults, and the difference between a config file and a process environment. All service values are synthetic; no host or cloud credentials are used.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build environment-variables-lab
docker compose run --rm environment-variables-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/environment-variables-lab/grade.sh
```

The container and its work are discarded when you exit. Rerun it for a clean attempt. See `INSTRUCTOR.md` for the answer key and grading details.

## Run in a Linux Bash shell

Initialize the exercise in your home directory:

```sh
bash setup.sh
source "$HOME/environment_variables_practice/lab-env.sh"
cd "$HOME/environment_variables_practice"
```

Complete `STUDENT.md`, then grade the reports from this directory:

```sh
bash grade.sh
```

Setup refuses to overwrite an existing `~/environment_variables_practice`. Remove that exercise directory yourself to start over. Source `lab-env.sh` only in the lab shell; the exported values are synthetic and disappear when that shell exits.

## Source lesson

- [Linux System & Environment Variables](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/System_Variables.md)

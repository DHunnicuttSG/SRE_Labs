# Linux Alias and Functions Lab

A hands-on Bash lab for building shell aliases and functions that speed up production-support triage. The exercises use sample logs and safe, read-only commands; they do not change services or require access to a production system.

## Run with Docker

From this directory, build and start the interactive lab:

```sh
docker compose build alias-lab
docker compose run --rm alias-lab
```

Inside the container, follow `STUDENT.md`. Run the grader with:

```sh
bash /opt/alias-lab/grade.sh
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

Setup refuses to overwrite an existing `~/alias_practice`. Remove that exercise directory yourself to start over. The lab does not edit `~/.bashrc`; source `~/alias_practice/aliases.sh` when you want its definitions in the current Bash session.

## Source lessons

- [Linux aliases and shortcuts](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Alias.md)
- [Aliases for production support](https://github.com/DHunnicuttSG/SRE/blob/5b2331944b66dbd5109aee2788585d9aff21ad6b/Linux/Advanced/Aliases_for_Prod_Support.md)
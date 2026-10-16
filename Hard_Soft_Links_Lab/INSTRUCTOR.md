# Instructor Notes

## Learning objectives

Students distinguish a filename from an inode; verify hard links with `stat` and `find -samefile`; observe shared content and link-count changes; create and inspect relative symlinks; distinguish a symlink itself from its target; diagnose and repair a dangling link; and safely remove a pointer without deleting the pointed-to file.

## Environment

The Docker image runs as the unprivileged `student` user and does not mount host paths. Setup copies the fixture tree into `~/links_practice` and creates empty work directories. Local Bash setup also writes only under that exercise directory. No privileged operations or external packages are needed.

## Answer key

From `~/links_practice`:

```sh
ln data/service.log evidence/service-hard.log
stat -c '%i %h %n' data/service.log evidence/service-hard.log | sort -k3,3 | tee reports/q01.txt

if [[ "$(stat -c '%i' data/service.log)" == "$(stat -c '%i' evidence/service-hard.log)" ]] \
  && [[ "$(stat -c '%h' data/service.log)" == 2 ]]; then
  stat -c 'inode=%i links=%h' data/service.log | tee reports/q02.txt
fi

printf '2026-10-16T09:15:00Z WARN retry scheduled\n' >> evidence/service-hard.log
cat data/service.log | tee reports/q03.txt

find data evidence -type f -samefile evidence/service-hard.log -print | LC_ALL=C sort | tee reports/q04.txt

rm data/service.log
printf 'remaining hard links=%s\n' "$(stat -c '%h' evidence/service-hard.log)" | tee reports/q05.txt
cat evidence/service-hard.log | tee -a reports/q05.txt

ln -s ../releases/v1/app.conf links/config-current.conf
readlink links/config-current.conf | tee reports/q06.txt
cat links/config-current.conf | tee reports/q07.txt

ln -s ../releases/v2/app.conf links/config-next.conf
mv -Tf links/config-next.conf links/config-current.conf
printf 'target=%s\n' "$(readlink links/config-current.conf)" | tee reports/q08.txt
cat links/config-current.conf | tee -a reports/q08.txt

ln -s ../releases/v3/app.conf links/next.conf
if [[ -L links/next.conf && ! -e links/next.conf ]]; then
  printf 'symlink exists; target missing\n' | tee reports/q09.txt
fi

printf 'release=v3\nservice=payments\n' > releases/v3/app.conf
cat links/next.conf | tee reports/q10.txt

rm links/config-current.conf
if [[ ! -L links/config-current.conf && ! -e links/config-current.conf \
  && -f releases/v2/app.conf ]]; then
  printf 'link removed; target retained\n' | tee reports/challenge.txt
fi
```

## Production support notes

- A hard link is another directory entry for the same inode. Both names expose the same bytes, ownership, permissions, and timestamps. Editing through either name changes the same file; a hard link is not an independent backup or snapshot.
- Removing a filename unlinks that directory entry. The inode's data remains while another hard link exists, and can also remain while a process still has the file open. A low link count alone does not prove data has been reclaimed.
- Hard links normally cannot cross filesystem boundaries, and creating hard links to directories is generally prohibited. Compare device IDs with `stat -c '%d %n'` or filesystem types with `df -T` before investigating a suspected cross-filesystem link.
- A symbolic link is a separate inode containing a path. Relative targets are resolved relative to the symlink's containing directory. Moving a symlink without preserving the target's relative layout can break it; absolute symlinks can also become invalid when a mount or deployment path changes.
- `test -L path` checks that the path is a symlink, including a dangling one. `test -e path` checks that the target resolves to an existing object. `readlink path` shows stored text; `readlink -f path` attempts to show the resolved path. `stat` follows symlinks by default on common GNU systems; use `stat -c`/`stat -L` deliberately, and use `lstat`-style tools when inspecting the link itself.
- For a deployment pointer, inspect the current link and target before changing it. Create a staged symlink beside the current one and rename it over the current link on the same filesystem; then verify the target and application health. Do not use recursive deletion through a link or assume removing a link removes its target.
- During log rotation or incident collection, a pathname can be renamed or replaced while a process continues writing to the old inode through an open file descriptor. Compare inode and device values (`stat`, `ls -li`, `/proc/<pid>/fd`) before concluding that two similarly named logs are the same file.
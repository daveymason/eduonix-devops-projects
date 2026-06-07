# Backup Scheme with rsync

This project is a simple local backup scheme for the DevOps Foundation module. It uses `rsync` to create timestamped backups, compresses each backup as a `.tar.gz` archive, and includes a sample `crontab` entry for scheduling.

## Files

- `backup.sh` - runs the backup with `rsync` and compression
- `restore.sh` - extracts a compressed backup archive
- `backup.cron` - sample cron entry for daily scheduled backups
- `rsync-excludes.txt` - optional exclude patterns for `rsync`

## What the script does

1. Syncs the source directory into a timestamped snapshot folder.
2. Keeps a `latest` snapshot for efficient future `rsync` runs.
3. Compresses each snapshot into a `.tar.gz` archive.
4. Supports scheduling through `crontab`.

## Run a backup manually

```bash
cd projects/devops-foundation
chmod +x backup.sh restore.sh
./backup.sh /path/to/source /path/to/backups
```

Example:

```bash
./backup.sh ~/Documents ~/backups
```

## Restore a backup

```bash
./restore.sh /path/to/backups/archives/backup_2026-06-07_12-00-00.tar.gz /path/to/restore-folder
```

## Schedule with cron

Copy the example from `backup.cron` into your crontab:

```bash
crontab -e
```

Then add a line similar to:

```text
0 2 * * * /bin/bash /path/to/eduonix-devops/projects/devops-foundation/backup.sh /path/to/source /path/to/backups >> /path/to/backup.log 2>&1
```

## Requirements

- Bash
- rsync
- tar
- cron
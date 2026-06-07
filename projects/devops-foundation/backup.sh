#!/usr/bin/env bash

set -euo pipefail

SOURCE_DIR="${1:-${SOURCE_DIR:-}}"
BACKUP_ROOT="${2:-${BACKUP_ROOT:-}}"
EXCLUDE_FILE="${EXCLUDE_FILE:-$(dirname "$0")/rsync-excludes.txt}"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"

if [[ -z "$SOURCE_DIR" || -z "$BACKUP_ROOT" ]]; then
  echo "Usage: ./backup.sh <source_dir> <backup_root>"
  echo "Or set SOURCE_DIR and BACKUP_ROOT environment variables."
  exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Source directory does not exist: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$BACKUP_ROOT"

WORK_DIR="$BACKUP_ROOT/incremental"
ARCHIVE_DIR="$BACKUP_ROOT/archives"
LATEST_DIR="$WORK_DIR/latest"
SNAPSHOT_DIR="$WORK_DIR/$TIMESTAMP"
ARCHIVE_FILE="$ARCHIVE_DIR/backup_$TIMESTAMP.tar.gz"

mkdir -p "$WORK_DIR" "$ARCHIVE_DIR"

RSYNC_ARGS=(
  -avh
  --delete
  --link-dest="$LATEST_DIR"
)

if [[ -f "$EXCLUDE_FILE" ]]; then
  RSYNC_ARGS+=(--exclude-from="$EXCLUDE_FILE")
fi

echo "Starting rsync backup from $SOURCE_DIR"
rsync "${RSYNC_ARGS[@]}" "$SOURCE_DIR/" "$SNAPSHOT_DIR/"

rm -rf "$LATEST_DIR"
cp -al "$SNAPSHOT_DIR" "$LATEST_DIR"

echo "Compressing snapshot to $ARCHIVE_FILE"
tar -czf "$ARCHIVE_FILE" -C "$WORK_DIR" "$TIMESTAMP"

echo "Backup completed successfully."
echo "Snapshot: $SNAPSHOT_DIR"
echo "Archive: $ARCHIVE_FILE"

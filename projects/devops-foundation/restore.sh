#!/usr/bin/env bash

set -euo pipefail

ARCHIVE_FILE="${1:-}"
RESTORE_DIR="${2:-}"

if [[ -z "$ARCHIVE_FILE" || -z "$RESTORE_DIR" ]]; then
  echo "Usage: ./restore.sh <archive_file.tar.gz> <restore_dir>"
  exit 1
fi

if [[ ! -f "$ARCHIVE_FILE" ]]; then
  echo "Archive file does not exist: $ARCHIVE_FILE"
  exit 1
fi

mkdir -p "$RESTORE_DIR"
tar -xzf "$ARCHIVE_FILE" -C "$RESTORE_DIR"

echo "Restore completed successfully into $RESTORE_DIR"

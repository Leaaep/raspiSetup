#!/bin/bash
set -euo pipefail

if [ ! -f ".env.restic" ]; then
    echo ".env.restic not found!"
    exit 1
fi
source .env.restic

if ! restic snapshots >/dev/null 2>&1; then
    echo "Repository not found – initializing new Restic repo at $RESTIC_REPOSITORY ..."
    restic init --repo $RESTIC_REPOSITORY --password-file $RESTIC_PASSWORD_FILE
    echo "Repository initialised."
fi

echo "Backing up files..."
restic backup $RESTIC_BACKUP_TARGET_DIR/*.zip

restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune

echo "Cleaning up temporary files..."
find "$RESTIC_BACKUP_TARGET_DIR" -mindepth 1 -exec rm -rf {} +

echo "Restic backup finished!"

#!/bin/bash
set -euo pipefail

if [ ! -f ".env.restic" ]; then
    echo ".env.restic not found!"
    exit 1
fi
source .env.restic

echo "Backing up files..."
restic backup $BACKUP_TARGET_DIR/*.zip

restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune

echo "Cleaning up temporary files..."
find "$BACKUP_TARGET_DIR" -mindepth 1 -exec rm -rf {} +

echo "Restic backup finished!"

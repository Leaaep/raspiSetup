#!/bin/bash
set -euo pipefail

# Load Mealie env
if [ ! -f .env.mealie ]; then
    echo ".env.mealie not found!"
    exit 1
fi
source .env.mealie

# Prepare backup directory
BACKUP_DIR="$BACKUP_TMP_DIR/mealie-backup-$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "Stopping Mealie container..."
docker stop "$CONTAINER_MEALIE"

echo "Backing up Mealie data..."
docker cp "$CONTAINER_MEALIE:$MEALIE_DATA_PATH" "$BACKUP_DIR/"

echo "Restarting Mealie container..."
docker start "$CONTAINER_MEALIE"

echo "Mealie backup complete. Files saved to $BACKUP_DIR"

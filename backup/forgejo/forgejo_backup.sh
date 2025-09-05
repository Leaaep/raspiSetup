#!/bin/bash
set -euo pipefail

# Load Forgejo env
if [ ! -f .env.forgejo ]; then
    echo ".env.forgejo not found!"
    exit 1
fi
source .env.forgejo

# Prepare backup directory
BACKUP_DIR="$BACKUP_TMP_DIR/forgejo-backup-$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "Stopping Forgejo container..."
docker stop "$CONTAINER_FORGEJO"

echo "Running Forgejo dump..."
DUMP_FILE="dump-$(date +%Y-%m-%d).tar"
docker exec "$CONTAINER_FORGEJO" forgejo dump "$FORGEJO_DUMP_PATH/$DUMP_FILE"
docker cp "$CONTAINER_FORGEJO:$FORGEJO_DUMP_PATH/$DUMP_FILE" "$BACKUP_DIR/forgejo-dump.tar"

echo "Copying SQLite database..."
docker cp "$CONTAINER_FORGEJO:$FORGEJO_SQLITE_PATH" "$BACKUP_DIR/forgejo.sqlite"

echo "Restarting Forgejo container..."
docker start "$CONTAINER_FORGEJO"

echo "Forgejo backup complete. Files saved to $BACKUP_DIR"

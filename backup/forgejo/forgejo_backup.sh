#!/bin/bash
set -euo pipefail

# Load Forgejo env
if [ ! -f .env ]; then
    echo ".env not found!"
    exit 1
fi
source .env

# Prepare backup directory
BACKUP_DIR="$BACKUP_TMP_DIR/forgejo-backup-$(date +%Y-%m-%d)"
mkdir -p "$BACKUP_DIR"

echo "Running Forgejo dump..."
DUMP_FILE="dump-$(date +%Y-%m-%d).tar"
docker exec "$CONTAINER_FORGEJO" forgejo dump "$FORGEJO_DUMP_PATH/$DUMP_FILE"
docker cp "$CONTAINER_FORGEJO:$FORGEJO_DUMP_PATH/$DUMP_FILE" "$BACKUP_DIR/forgejo-dump.tar"

echo "Stopping Forgejo container..."
docker stop "$CONTAINER_FORGEJO"

echo "Copying SQLite database..."
cp "$LOCAL_SQLITE_PATH" "$BACKUP_DIR/forgejo.sqlite"

echo "Restarting Forgejo container..."
docker start "$CONTAINER_FORGEJO"

echo "Forgejo backup complete. Files saved to $BACKUP_DIR"

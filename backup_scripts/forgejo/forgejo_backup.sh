#!/bin/bash
set -euo pipefail

FILE_NAME="forgejo-dump-$(date +%Y-%m-%d).zip"

# Load Forgejo env
if [ ! -f .env.forgejo ]; then
    echo ".env.forgejo not found!"
    exit 1
fi
source .env.forgejo

echo "Running Forgejo dump..."
docker exec --user 1000:1000 -w /data/gitea/tmp "$CONTAINER_NAME" forgejo dump --file "$FILE_NAME"

echo "Stopping Forgejo container..."
docker stop "$CONTAINER_NAME"

echo "Copying SQLite database..."
cp "$BACKUP_SRC_DIR/$FILE_NAME" "$BACKUP_TARGET_DIR/"

echo "Restarting Forgejo container..."
docker start "$CONTAINER_NAME"

echo "Cleaning up temp files"
rm -f "$BACKUP_SRC_DIR/$FILE_NAME"

echo "Forgejo backup complete. Files saved to $BACKUP_TARGET_DIR/$FILE_NAME"

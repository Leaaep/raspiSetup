#!/bin/bash
set -euo pipefail

# Load Forgejo env
if [ ! -f .env ]; then
    echo ".env not found!"
    exit 1
fi
source .env

echo "Running Forgejo dump..."
FILE_NAME="forgejo-dump-$(date +%Y-%m-%d).zip"
docker exec --user 1000:1000 -w /data/gitea/tmp "$CONTAINER_FORGEJO" forgejo dump --file "$FILE_NAME"

echo "Stopping Forgejo container..."
docker stop "$CONTAINER_FORGEJO"

echo "Copying SQLite database..."
cp "$LOCAL_SQLITE_PATH/$FILE_NAME" "$BACKUP_TMP_DIR/"

echo "Restarting Forgejo container..."
docker start "$CONTAINER_FORGEJO"

echo "Forgejo backup complete. Files saved to $BACKUP_TMP_DIR/$FILE_NAME"

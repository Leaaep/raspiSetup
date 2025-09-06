#!/bin/bash
set -euo pipefail

# Load Forgejo env
if [ ! -f .env.forgejo ]; then
    echo ".env.forgejo not found!"
    exit 1
fi
source .env.forgejo

echo "Unzipping forgejo dump zip"
unzip "$RESTORE_SRC_PATH/forgejo-dump-*.zip"

echo "Stopping forgejo container..."
docker stop "$CONTAINER_NAME"

echo "Loading backup data..."
cp -r $RESTORE_SRC_PATH/actions_artifacts/* $RESTORE_TARGET_PATH/actions_artifacts/
cp -r $RESTORE_SRC_PATH/actions_log/* $RESTORE_TARGET_PATH/actions_log/
cp -r $RESTORE_SRC_PATH/attachments/* $RESTORE_TARGET_PATH/attachments/
cp -r $RESTORE_SRC_PATH/avatars/* $RESTORE_TARGET_PATH/avatars/
cp -r $RESTORE_SRC_PATH/conf/* $RESTORE_TARGET_PATH/conf/
cp -r $RESTORE_SRC_PATH/home/* $RESTORE_TARGET_PATH/home/
cp -r $RESTORE_SRC_PATH/indexers/* $RESTORE_TARGET_PATH/indexers/
cp -r $RESTORE_SRC_PATH/jwt/* $RESTORE_TARGET_PATH/jwt/
cp -r $RESTORE_SRC_PATH/queues/* $RESTORE_TARGET_PATH/queues/
cp -r $RESTORE_SRC_PATH/repo-archive/* $RESTORE_TARGET_PATH/repo-archive/
cp -r $RESTORE_SRC_PATH/repo-avatars/* $RESTORE_TARGET_PATH/repo-avatars/
cp -r $RESTORE_SRC_PATH/tmp/* $RESTORE_TARGET_PATH/tmp/
cp $RESTORE_SRC_PATH/gitea.db $RESTORE_TARGET_PATH/gitea.db

echo "Starting forgejo container"
docker start "$CONTAINER_NAME"

echo "Cleaning up temp files"
rm -f "$RESTORE_SRC_PATH/forgejo-dump-*.zip"
rm -f "$RESTORE_SRC_PATH/*.sql"
rm -f "$RESTORE_SRC_PATH/app.ini"
rm -rf "$RESTORE_SRC_PATH/data/*"

echo "Restore complete"

#!/bin/bash
set -euo pipefail

# Load general backup env
if [ ! -f .env ]; then
    echo ".env not found!"
    exit 1
fi
source .env

DATE_STR=$(date +%Y-%m-%d)

# Sync backups to Synology
mkdir -p "$BACKUP_LOG_DIR"
RSYNC_LOG="$BACKUP_LOG_DIR/backup-$DATE_STR.log"
rsync -av "$BACKUP_TMP_DIR/" "$SSH_USER@$SSH_HOST:$SSH_DEST/backup-$DATE_STR/" > "$RSYNC_LOG" 2>&1
echo "Backup synced to Synology. Log: $RSYNC_LOG"

# Remove old backups on Synology
DELETE_LOG="$BACKUP_LOG_DIR/backup-delete-$DATE_STR.log"
ssh "$SSH_USER@$SSH_HOST" "find $SSH_DEST/ -maxdepth 1 -type d -name 'backup-*' -mtime +$BACKUP_RETENTION_DAYS -exec rm -rf {} \;" > "$DELETE_LOG" 2>&1
echo "Old backups deleted on Synology. Log: $DELETE_LOG"

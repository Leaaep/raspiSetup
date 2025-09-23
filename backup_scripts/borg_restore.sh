#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app_name>"
    exit 1
fi

app_name=$1

ENV_FILE="$SCRIPT_DIR/.env.borg"
if [ ! -f "$ENV_FILE" ]; then
    echo "$ENV_FILE not found!"
    exit 1
fi
source "$ENV_FILE"

export BORG_PASSPHRASE=${BORG_PASSPHRASE}

# generate backup name
BACKUP_NAME=$(borg list --last 1 --short ${BORG_REPO})

# restore
cd "${APPS_FOLDER}/${app_name}"

# delete old data
rm -rf "${app_name}_data"

# extract new data
borg extract ${BORG_REPO}::${BACKUP_NAME}

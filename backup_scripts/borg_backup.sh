#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app_name>"
    exit 1
fi

app_name=$1

ENV_FILE="$SCRIPT_DIR/.borg.env"
if [ ! -f "$ENV_FILE" ]; then
    echo "$ENV_FILE not found!"
    exit 1
fi
source "$ENV_FILE"

# export env var passphrase so script can use it
export BORG_PASSPHRASE=${BORG_PASSPHRASE}

# initialize repo if not done already
{
  borg init --encryption repokey ${BORG_REPO}
  echo "New Borg repo initalized"
} || {
  echo "Borg repo already exists"
}

# cleanup old backups
borg prune -v --list ${BORG_REPO} \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=6

cd "${APPS_FOLDER}/${app_name}" || exit 1

# backup data and create a backup in format app_name-dump-YYYY-MM-DD
borg create --stats ${BORG_REPO}::${app_name}-dump-$(date +%Y-%m-%d) "${app_name}_data"



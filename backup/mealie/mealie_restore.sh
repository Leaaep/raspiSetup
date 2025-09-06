#!/bin/bash
set -euo pipefail

# Load Mealie env
if [ ! -f .env.mealie ]; then
    echo ".env.mealie not found!"
    exit 1
fi
source .env.mealie



echo "Restore complete"

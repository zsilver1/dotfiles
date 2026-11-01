#!/bin/bash

set -e

# Load environment variables
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=
# export RESTIC_REPOSITORY=
# export RESTIC_PASSWORD=

source ~/.restic-env

echo "Starting backup: $(date)"
restic --verbose backup ~/Documents ~/Local
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
echo "Backup done: $(date)"

# Restore with
# restic -r *SOURCE* restore --target *TARGET_LOC* --dry-run latest

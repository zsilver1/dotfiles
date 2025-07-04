#!/bin/bash

set -e

# Load environment variables
source ~/.restic-env

echo "Starting backup: $(date)"
restic --verbose backup ~/Documents
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune
echo "Backup done: $(date)"

# Restore with
# restic -r *SOURCE* restore --target *TARGET_LOC* --dry-run latest

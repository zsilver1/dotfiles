#!/bin/bash

restic -r rclone:drive:BACKUPS --verbose backup ~/Documents

# Restore with
# restic -r rclone:drive:BACKUPS restore --target TARGET_LOC --dry-run latest

#!/bin/bash

restic -r rclone:drive:BACKUPS --verbose backup ~/Documents

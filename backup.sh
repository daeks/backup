#!/bin/bash

cd $BACKUP_TARGET_DIR

for backupflag in $(find $BACKUP_SOURCE_DIR -name "$BACKUP_FLAG"); do
  if [ -f $backupflag ]; then
    rsync -rtvph --exclude '.git' --exclude '*.log' $(dirname "$backupflag") $BACKUP_TARGET_DIR -delete
    
    git add .
    git commit -m "$(date +%s)"
    git push
  fi
done
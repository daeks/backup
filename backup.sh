#!/bin/bash

cd $BACKUP_TARGET_DIR

for backupflag in $(find $BACKUP_SOURCE_DIR -name "$BACKUP_FLAG"); do
  if [ -f $backupflag ]; then
    target=${backupflag#$BACKUP_SOURCE_DIR}
    mkdir -p "$BACKUP_TARGET_DIR$target"
    rsync -rtvph --exclude '.git' --exclude '*.log' --max-size=100m $(dirname "$backupflag") $target -delete
    
    git add .
    git commit -m "$(date +%s)"
    git push
  fi
done
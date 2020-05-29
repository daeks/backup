#!/bin/bash

cd $BACKUP_TARGET_DIR

for backupflag in $(find $BACKUP_SOURCE_DIR -name "$BACKUP_FLAG"); do
  backuppath=$(basename "$(dirname "$backupflag")") | sed -e "s/^$BACKUP_SOURCE_DIR//"
  
  mkdir -p "${BACKUP_TARGET_DIR}${backuppath}"
  rsync -rvpth $backuppath "${BACKUP_TARGET_DIR}${backuppath}" -delete
  git add .
  git commit -m "$(date +%s)"
  git push
done
#!/bin/bash

rm -rf $BACKUP_TARGET_DIR/*
cd $BACKUP_TARGET_DIR


for backupflag in $(find $BACKUP_SOURCE_DIR -name "$BACKUP_FLAG" ! -path "$BACKUP_SOURCE_DIR/var/lib/docker/volumes/*"); do
  if [ -f $backupflag ]; then
    backuppath=$(dirname "$backupflag")
    target=$(dirname "$BACKUP_TARGET_DIR${backuppath#$BACKUP_SOURCE_DIR}")
    mkdir -p $target
    echo $target
    rsync -rtvph --exclude '.git' --exclude '$BACKUP_FLAG' --exclude '*.log' --max-size=100m $backuppath "$BACKUP_TARGET$target" -delete
  fi
done

if [ ! -z "$EMAIL" ]; then
  git add .
  git commit -m "$(date +%Y%m%d%H%M%S-%Z)"
  git push
fi

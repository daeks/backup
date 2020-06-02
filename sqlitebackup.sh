#!/bin/bash

if [ -d $SQLITE_TARGET_DIR ]; then
  if [ ! -z "$RETENTION" ]; then
    find $SQLITE_TARGET_DIR -type f -mtime +$RETENTION -exec rm -f {} \;
  else
    rm -rf $SQLITE_TARGET_DIR/*
  fi
else
  mkdir -p $SQLITE_TARGET_DIR
fi

cd $SQLITE_TARGET_DIR

for backupflag in $(find $BACKUP_SOURCE_DIR -name "$BACKUP_FLAG" ! -path "*/_data/*'" &&\
  find $BACKUP_SOURCE_DIR -name "$BACKUP_FLAG" -path "*_data/_data/*" -path "*_backup/_data/*"); do
  if [ -f $backupflag ]; then
    backuppath=$(dirname "$backupflag")
    target=$(dirname "$SQLITE_TARGET_DIR${backuppath#$BACKUP_SOURCE_DIR}")
  
    for database in $(find $backuppath -name "*.sqlitedb" && find $backuppath -name "*.db"); do
      mkdir -p $target
      sqlite3 $database .dump > $target/$(basename "$database").sql
    done
  fi
done



source $BACKUP_WORK_DIR/commit.sh
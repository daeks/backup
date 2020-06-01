#!/bin/bash

if [ -d $MYSQL_TARGET_DIR ]; then
  if [ ! -z "$RETENTION" ]; then
    find $MYSQL_TARGET_DIR -type f -mtime +$RETENTION -exec rm -f {} \;
  else
    rm -rf $MYSQL_TARGET_DIR/*
  fi
else
  mkdir -p $MYSQL_TARGET_DIR
fi

cd $MYSQL_TARGET_DIR

if [ -d $MYSQL_WORK_DIR ]; then
  if [ ! -z "$MYSQL_HOSTNAME" ] && [ ! -z "$MYSQL_USERNAME" ] && [ ! -z "$MYSQL_PASSWORD" ]; then
    if [ ! -z "$MYSQL_DATABASE" ]; then
      $(which mysqldump) -h $MYSQL_HOSTNAME -u $MYSQL_USERNAME -p $MYSQL_PASSWORD -B $MYSQL_DATABASE \
        | $(which gzip) -b 100m -9 > $MYSQL_TARGET_DIR/$MYSQL_DATABASE-$(date +%Y%m%d%H%M%S-%Z).sql.gz 
    else
      $(which mysqldump) -h $MYSQL_HOSTNAME -u $MYSQL_USERNAME -p $MYSQL_PASSWORD -A \
        | $(which gzip) -b 100m -9 > $MYSQL_TARGET_DIR/$MYSQL_HOSTNAME-$(date +%Y%m%d%H%M%S-%Z).sql.gz
    fi
  fi
fi

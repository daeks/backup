#!/bin/bash

if [ -f /etc/cron/crontab ]; then
  crontab /etc/cron/crontab
  service rsyslog restart && service cron restart
fi

if [ "$GIT" != "OFF" ]; then
  if [ -d "$BACKUP_TARGET_DIR/.git" ]; then
    git fetch --all origin
    git reset --hard origin/master
    git pull
  else
    git config --global user.email $EMAIL
    git clone $GIT_URL $BACKUP_TARGET_DIR/
  fi
fi

/bin/bash

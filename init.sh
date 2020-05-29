#!/bin/bash

if [ -f /etc/cron/crontab ]; then
  printenv | grep -v "LANG" > /etc/environment
  crontab /etc/cron/crontab
  service rsyslog restart && service cron restart
fi

if [ "$GIT" != "OFF" ]; then
  if [ -d "$BACKUP_TARGET_DIR/.git" ]; then
    git fetch --all origin
    git reset --hard origin/master
    git pull
  else
    if [ ! -z "$EMAIL" ]; then
      git config --global user.email $EMAIL
    fi
    git clone $GIT_URL $BACKUP_TARGET_DIR/
  fi
fi

/bin/bash

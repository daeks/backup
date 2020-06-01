#!/bin/bash

if [ -f /etc/cron/crontab ]; then
  printenv > /etc/environment
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
    
    if [ -d $MYSQL_WORK_DIR ]; then
      git lfs install
    fi
    
    git clone $GIT_URL $BACKUP_TARGET_DIR/
    
    if [ -d $MYSQL_WORK_DIR ]; then
      cd $BACKUP_TARGET_DIR && git lfs track "*.gz"
      cd $BACKUP_WORKDIR_DIR
    fi
  fi
fi

/bin/bash

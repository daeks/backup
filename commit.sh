#!/bin/bash

cd $BACKUP_TARGET_DIR

if [ ! -z "$EMAIL" ]; then
  git add .
  git commit -m "$(date +%Y%m%d%H%M%S-%Z)"
  git push
fi

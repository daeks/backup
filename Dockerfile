FROM debian:buster-slim
LABEL maintainer="github.com/daeks"

ENV GIT OFF
ENV GIT_TOKEN <token>
ENV GIT_URL https://$GIT_TOKEN@github.com/<user>/<repo>.git

ENV BACKUP_FLAG .backup

ENV BACKUP_WORK_DIR /home/backup
ENV BACKUP_SOURCE_DIR $BACKUP_WORK_DIR/source
ENV BACKUP_TARGET_DIR $BACKUP_WORK_DIR/target

ENV FILE_TARGET_DIR $BACKUP_TARGET_DIR/file

ENV MYSQL_WORK_DIR /var/lib/mysql
ENV MYSQL_TARGET_DIR $BACKUP_TARGET_DIR/sql

ENV DEBIAN_FRONTEND noninteractive

RUN set -x &&\
  apt-get update && apt-get -y upgrade &&\
  apt-get install -y --no-install-recommends --no-install-suggests \
    nano rsyslog cron ca-certificates git rsync mariadb-client &&\
  mkdir -p $BACKUP_SOURCE_DIR && mkdir -p $FILE_TARGET_DIR && mkdir -p $MYSQL_TARGET_DIR

COPY ./crontab /etc/cron/crontab

COPY ./*.sh $BACKUP_WORK_DIR/
RUN chmod +x $BACKUP_WORK_DIR/*.sh

RUN set -x &&\
  apt-get clean autoclean &&\
  apt-get autoremove -y &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*^

WORKDIR $BACKUP_WORK_DIR
VOLUME $BACKUP_WORK_DIR

ENTRYPOINT $BACKUP_WORK_DIR/init.sh

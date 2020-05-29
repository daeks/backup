FROM debian:buster-slim
LABEL maintainer="github.com/daeks"

ENV GIT OFF
ENV GIT_TOKEN <token>
ENV GIT_URL https://$GIT_TOKEN@github.com/<user>/<repo>.git

ENV BACKUP_FLAG .backup

ENV BACKUP_WORK_DIR /home/backup
ENV BACKUP_SOURCE_DIR $BACKUP_WORK_DIR/source
ENV BACKUP_TARGET_DIR $BACKUP_WORK_DIR/target

ENV DEBIAN_FRONTEND noninteractive

RUN set -x &&\
  apt-get update && apt-get -y upgrade &&\
  apt-get install -y --no-install-recommends --no-install-suggests \
    procps nano rsyslog cron ca-certificates git rsync &&\
  mkdir -p $BACKUP_SOURCE_DIR && mkdir -p $BACKUP_TARGET_DIR

COPY ./crontab /etc/cron/crontab

COPY ./init.sh $BACKUP_WORK_DIR/init.sh
RUN chmod +x $BACKUP_WORK_DIR/init.sh

COPY ./backup.sh $BACKUP_WORK_DIR/backup.sh
RUN chmod +x $BACKUP_WORK_DIR/backup.sh

RUN set -x &&\
  apt-get clean autoclean &&\
  apt-get autoremove -y &&\
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*^

WORKDIR $BACKUP_WORK_DIR
VOLUME $BACKUP_WORK_DIR

ENTRYPOINT $BACKUP_WORK_DIR/init.sh

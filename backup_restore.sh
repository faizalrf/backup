#!/bin/bash
#Dated: 20th October 2023
#Faisal Saeed
#GNU 2.0 Free to use but absolutely no guarantees

#Load the Secrets File
. ./.secrets

if [ $# -ne 1 ]
then
    echo "Incorrect arguments..."
    echo "Please specify the backup directory to restore from"
    echo "Usage:"
    echo "shell> backup_restore.sh 20231020-1107"
    echo
    exit 1
fi

CURR_DATE=$1
BASE_PATH=${BASE_DIR}
TARGET_DIR=${BASE_PATH}/${CURR_DATE}
DATA_DIR=${DATA_DIRECTORY}
LOG_FILE=${BASE_PATH}/restore_${CURR_DATE}.out
USER=${USER_NAME}
PASSWD=${USER_PASSWD}

function log {
   echo $1
   echo "$(date) - $1" >> ${LOG_FILE}
}

if [ ! -d ${TARGET_DIR} ]
then
   log "Backup ${TARGET_DIR} does not exist"
   exit 1
fi

if [ ! -d ${DATA_DIR} ]
then
   log "Data Directory ${DATA_DIR} does not exist"
   exit 1
else
    if find ${DATA_DIR} -maxdepth 0 -empty | read v; 
    then 
        log "${DATA_DIR} is empty, safe to restore...";
    else
        log "${DATA_DIR} is not empty, please clean it up before restoring...";
        exit 1 
    fi
    log "Stopping MariaDB service"
    systemctl stop mariadb
    retval=$?

    if [ ${retval} -ne 0 ]
    then
       echo "Failed to stop MariaDB service, please review server logs."
       exit 1
    fi
fi

log "===================================="
log "Started Restore: $(date +%Y-%m-%d\ %H:%M:%S)"
log "------------------------------------"

mariabackup --copy-back --target-dir=${TARGET_DIR} --datadir=${DATA_DIR} 2>>${LOG_FILE}
retval=$?

if [ ${retval} -ne 0 ]
then
   echo "Failed to restore, please review ${LOG_FILE}"
   exit 1
fi

log "Changing ownership of the restored ${DATA_DIR}"
chown -R mysql:mysql ${DATA_DIR}

log "Starging MariaDB Service"
systemctl restart mariadb
retval=$?

if [ ${retval} -ne 0 ]
then
   echo "Failed to start MariaDB service, please review server logs."
   exit 1
fi

log "--------------------------------------"
log "Backup Completed: $(date +%Y-%m-%d\ %H:%M:%S)"
log "--------------------------------------"
exit 0

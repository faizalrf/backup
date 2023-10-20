#!/bin/bash
#Dated: 19th October 2023
#Faisal Saeed
#GNU 2.0 Free to use but absolutely no guarantees

#Load the Secrets File
. ./.secrets

CURR_DATE="$(date +%Y%m%d-%H%M)"
BASE_PATH=${BASE_DIR}
TARGET_DIR=${BASE_PATH}/${CURR_DATE}
DATA_DIR=${DATA_DIRECTORY}
TARGET_FILE=${TARGET_DIR}/full_backup_${CURR_DATE}.gz
LOG_FILE=${BASE_PATH}/backup_${CURR_DATE}.out
USER=${USER_NAME}
PASSWD=${USER_PASSWD}

function log {
   echo $1
   echo "$(date) - $1" >> ${LOG_FILE}
}

if [ ! -d ${TARGET_DIR} ]
then
   mkdir -p ${TARGET_DIR}
   [ ! -f ${LOG_FILE} ] && touch ${LOG_FILE}
   chmod -R 750 ${TARGET_DIR}
   log "Created ${TARGET_DIR} as desination folder"
else
   log "Backup folder ${TARGET_DIR} already exists"
   exit 1
fi

log "===================================="
log "Started Backup: $(date +%Y-%m-%d\ %H:%M:%S)"
log "------------------------------------"

mariabackup --backup --user=${USER} --password=${PASSWD} --target-dir=${TARGET_DIR} --datadir=${DATA_DIR} 2>>${LOG_FILE}
retval=$?

if [ ${retval} -ne 0 ]
then
   echo "Failed to execute mariabackup, please review ${LOG_FILE}"
   exit 1
fi

log "Preparing backup at ${TARGET_DIR}"
mariabackup --prepare --user=${USER} --password=${PASSWD} --target-dir=${TARGET_DIR} 2>>${LOG_FILE}
retval=$?

if [ ${retval} -ne 0 ]
then
   echo "Failed to prepare backup, please review ${LOG_FILE}"
   exit 1
fi

log "--------------------------------------"
log "Backup Completed: $(date +%Y-%m-%d\ %H:%M:%S)"
log "--------------------------------------"
exit 0

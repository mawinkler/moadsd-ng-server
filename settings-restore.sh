#!/bin/bash
BACKUP_DIR=$1
WORK_DIR=workdir
AWS=.aws
GCP=.config

echo "Restoring Backup ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}/.ssh"
mkdir -p "${BACKUP_DIR}/moadsd-ng"

cp ${BACKUP_DIR}/.ssh/id_rsa.pub ${WORK_DIR}/.ssh/id_rsa.pub
cp ${BACKUP_DIR}/.ssh/id_rsa ${WORK_DIR}/.ssh/id_rsa
if test -d "${BACKUP_DIR}/${AWS}"; then
  cp -r ${BACKUP_DIR}/${AWS} ${WORK_DIR}/
fi
if test -f "${BACKUP_DIR}/.ssh/moadsd-ng"; then
  cp ${BACKUP_DIR}/.ssh/moadsd-ng ${WORK_DIR}/.ssh/moadsd-ng
fi
if test -d "${BACKUP_DIR}/${GCP}"; then
  cp -r ${BACKUP_DIR}/${GCP} ${WORK_DIR}/
fi
if test -f "${BACKUP_DIR}/ansible.json"; then
  cp ${BACKUP_DIR}/ansible.json ${WORK_DIR}/ansible.json
fi
cp ${BACKUP_DIR}/moadsd-ng/configuration.yml ${WORK_DIR}/moadsd-ng/
cp ${BACKUP_DIR}/.vault-pass.txt ${WORK_DIR}/

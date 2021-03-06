#!/bin/bash
BACKUP_DIR="backup-$(date '+%Y-%m-%d_%H-%M')"
WORK_DIR=workdir
AWS=.aws
GCP=.config

echo "Creating Backup to ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}/.ssh"
mkdir -p "${BACKUP_DIR}/moadsd-ng"

cp ./${WORK_DIR}/.ssh/id_rsa.pub ${BACKUP_DIR}/.ssh/id_rsa.pub
cp ./${WORK_DIR}/.ssh/id_rsa ${BACKUP_DIR}/.ssh/id_rsa
if test -f "${WORK_DIR}/.gitconfig"; then
  cp ${WORK_DIR}/.gitconfig ${BACKUP_DIR}/.gitconfig
fi

# MOADSD-NG
cp ${WORK_DIR}/moadsd-ng/configuration.yml ${BACKUP_DIR}/moadsd-ng/
cp ${WORK_DIR}/.vault-pass.txt ${BACKUP_DIR}/

# AWS
if test -d "${WORK_DIR}/${AWS}"; then
  cp -r ${WORK_DIR}/${AWS} ${BACKUP_DIR}/
fi
# if test -f "${WORK_DIR}/.ssh/moadsd-ng\*"; then
  cp ${WORK_DIR}/.ssh/moadsd-ng* ${BACKUP_DIR}/.ssh/
# fi
if test -d "${WORK_DIR}/moadsd-ng/site_aws"; then
  cp -r ${WORK_DIR}/moadsd-ng/site_aws ${BACKUP_DIR}/moadsd-ng/
fi

# GCP
if test -d "${WORK_DIR}/${GCP}"; then
  cp -r ${WORK_DIR}/${GCP} ${BACKUP_DIR}/
fi
if test -f "${WORK_DIR}/ansible.json"; then
  cp ${WORK_DIR}/ansible.json ${BACKUP_DIR}/ansible.json
fi
if test -d "${WORK_DIR}/moadsd-ng/site_gcp"; then
  cp -r ${WORK_DIR}/moadsd-ng/site_gcp ${BACKUP_DIR}/moadsd-ng/
fi

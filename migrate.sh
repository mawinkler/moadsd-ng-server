#!/bin/bash
echo "Containerizing MOADSD-NG"
# Adapt the locations of MOADSD-NG and MOADSD-NG-SERVER if required
LOCAL=~/moadsd-ng
SERVER=~/moadsd-ng-server
AWS=~/.aws
GCP=~/.config

echo "Migrating from ${LOCAL} to ${SERVER}/workdir"

cp ~/.ssh/id_rsa.pub ${SERVER}/workdir/.ssh/id_rsa.pub
cp ~/.ssh/id_rsa ${SERVER}/workdir/.ssh/id_rsa

if test -d "${AWS}"; then
  cp -r ${AWS} ${SERVER}/workdir/
  cp ~/.ssh/moadsd-ng ${SERVER}/workdir/.ssh/moadsd-ng
fi
if test -d "${GCP}"; then
  cp -r ${GCP} ${SERVER}/workdir/
  cp ~/ansible.json ${SERVER}/workdir/
fi
cp -r ${LOCAL} ${SERVER}/workdir/
cp ~/.vault-pass.txt ${SERVER}/workdir/

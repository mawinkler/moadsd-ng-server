#!/bin/bash
echo "Containerizing MOADSD-NG"
LOCAL=~/moadsd-ng
SERVER=~/moadsd-ng-server

echo "Migrating from ${LOCAL} to ${SERVER}/workdir"
sleep 200

rm -Rf ${SERVER}/workdir/
mkdir -p ${SERVER}/workdir/.ssh
chmod 700 ${SERVER}/workdir/.ssh

cp ~/.ssh/id_rsa.pub ${SERVER}/workdir/.ssh/id_rsa.pub
cp ~/.ssh/id_rsa ${SERVER}/workdir/.ssh/id_rsa
cp ~/.ssh/moadsd-ng ${SERVER}/workdir/.ssh/moadsd-ng
cp -r ~/.aws ${SERVER}/workdir/
cp -r ~/.config ${SERVER}/workdir/
cp ~/ansible.json ${SERVER}/workdir/
cp -r ${LOCAL} ${SERVER}/workdir/
cp ~/.vault-pass.txt ${SERVER}/workdir/

#!/bin/bash
echo "Building MOADSD-NG-SERVER Container Image"
docker-compose build

echo $'\nStarting MOADSD-NG-SERVER Container'
docker run -d --rm --name=moadsd-ng-server moadsd-ng-server_moadsd-ng-server -c "/bin/sleep 60"

echo $'\nFetch Home Directory from Container'
docker cp moadsd-ng-server:/tmp/ansible.tgz .

echo $'\nStopping MOADSD-NG-SERVER Container'
docker stop $(docker ps --format "{{.Names}}" | grep moadsd-ng-server)

echo $'\nPopulating workdir'
mkdir -p workdir
tar xpzf ansible.tgz --strip-components=2 -C ./workdir
rm ansible.tgz

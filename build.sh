#!/bin/bash
echo "Building MOADSD-NG-SERVER Container Image"
docker-compose build

echo $'\nStarting MOADSD-NG-SERVER Container'
IMAGE=$(docker images --format "{{.Repository}}" | grep moadsd-ng-server)
docker run -d --rm --name=moadsd-ng-server ${IMAGE} -c "/bin/sleep 60"

echo $'\nFetch Home Directory from Container'
CONTAINER=$(docker ps --format "{{.Names}}" | grep moadsd-ng-server)
docker cp ${CONTAINER}:/tmp/ansible.tgz .

echo $'\nStopping MOADSD-NG-SERVER Container'
docker stop ${CONTAINER}

echo $'\nPopulating workdir'
mkdir -p workdir
tar xpzf ansible.tgz --strip-components=2 -C ./workdir
rm ansible.tgz

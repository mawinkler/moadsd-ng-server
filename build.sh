#!/bin/bash
echo "Generating Environment File"
echo "UID=$(id -u)" > .env
echo "GID=$(id -g)" >> .env

#echo "Building MOADSD-NG-SERVER Container Image"
docker-compose build moadsd-ng-server

IMAGE=$(docker images --format "{{.Repository}}" | grep moadsd-ng-server)
echo "Starting MOADSD-NG-SERVER Container from image ${IMAGE}"
docker run -d --rm --name=moadsd-ng-server ${IMAGE} -c "/bin/sleep 60"

echo "Fetch Home Directory from Container"
CONTAINER=$(docker ps --format "{{.Names}}" | grep moadsd-ng-server)
docker cp ${CONTAINER}:/tmp/ansible.tgz .

echo "Stopping MOADSD-NG-SERVER Container"
docker stop ${CONTAINER}

echo "Populating workdir"
mkdir -p workdir
tar xpzf ansible.tgz --strip-components=2 -C ./workdir
rm ansible.tgz

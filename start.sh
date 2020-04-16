#!/bin/bash
CONTAINER=$(docker ps --format "{{.Names}}" | grep moadsd-ng-server)

if [ ${CONTAINER} ]
then
  echo Attaching to Running Instance
  docker attach ${CONTAINER}
else
  echo Creating new Instance
  docker-compose run moadsd-ng-server
fi

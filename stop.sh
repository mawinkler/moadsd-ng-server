#!/bin/bash
CONTAINER=$(docker ps --format "{{.Names}}" | grep moadsd-ng-server)
docker stop ${CONTAINER} && \
  docker rm $(docker ps -a --format "{{.Names}}" | grep moadsd-ng-server)

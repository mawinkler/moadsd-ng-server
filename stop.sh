#!/bin/bash
docker stop $(docker ps --format "{{.Names}}" | grep moadsd-ng-server) && \
  docker rm $(docker ps -a --format "{{.Names}}" | grep moadsd-ng-server)

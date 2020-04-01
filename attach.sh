#!/bin/bash
docker attach $(docker ps --format "{{.Names}}" | grep moadsd-ng-server)

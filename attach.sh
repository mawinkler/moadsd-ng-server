#!/bin/bash
mkdir -p workdir/.ssh
touch ./workdir/.ssh/id_rsa
touch ./workdir/.ssh/id_rsa.pub
touch ./workdir/moadsd-ng
touch ./workdir/ansible.json
touch ./workdir/.vault-pass.txt
docker attach $(docker ps --format "{{.Names}}" | grep moadsd-ng-server)

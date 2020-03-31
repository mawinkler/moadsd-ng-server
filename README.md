# moadsd-ng-server
Server Image for MOADSD-NG
## Prepare
The user inside the docker container is unprivileged but needs access to some files like then ansible.json from the host. To enable access the uid and gid of the ansible user inside the container must match the uid and gid of the user on the host.

Prerequisites:
* Linux with Docker engine and Docker-Compose

First, find your current uid and gid of your logged in user
```shell
id
```
```
uid=1001(ansible) gid=1001(ansible) groups=1001(ansible),118(docker)
```
The ids to put into the `docker-compose.yaml` are `1001` and `1001`
```
    build:
      context: .
      args:
        uid: 1001
        gid: 1001
```
## Build
If you only want to build the container image
```shell
docker-compose build
```

## Run
Run the server by (even without building it before)
```shell
docker-compose run moadsd-ng-server /bin/bash
```

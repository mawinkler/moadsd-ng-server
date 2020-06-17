# moadsd-ng-server
This repository provides a server container image for MOADSD-NG. The core components of that image are:

* Ansible running with Python3
* `gcloud` CLI for Google
* `aws` CLI for AWS
* plus all required dependencies to run MOADSD-NG from within a container

Persistence is provided by a mapped working directory on your docker host. That means, you can easily destroy and rebuild the image whenever needed. If you want to move your setup, simply tar / zip your local repo directory including the workdir.

Please follow the instructions on the MOADSD-NG Wiki chapter
[The MOADSD-NG-SERVER](https://github.com/mawinkler/moadsd-ng/wiki/MOADSD-NG-SERVER)

## Prerequisites
Docker & Docker-Compose

Tested with
* Linux,
* Mac OS X with *Docker for Desktop* and
* AWS Cloud9

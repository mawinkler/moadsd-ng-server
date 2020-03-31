# moadsd-ng-server
This repository provides a server container image for MOADSD-NG. The core components of that image are:

* Ansible running with Python3
* `gcloud` CLI for Google
* `aws` CLI for AWS
* plus all required dependencies to run MOADSD-NG from within a container

Persistence is provided by a mapped working directory on your docker host. That means, you can easily destroy and rebuild the image whenever needed. If you want to move your setup, simply tar / zip your local repo directory including the workdir.

## Prerequisites
* Docker Engine and
* Docker-Compose

## Get the MOADSD-NG-SERVER
Either download it directly from GitHub
```
https://github.com/mawinkler/moadsd-ng-server/archive/master.zip
```
or do a
```shell
git clone https://github.com/mawinkler/moadsd-ng-server.git
```
## Prepare the Build
The user inside the docker container is *unprivileged* but needs read / write access to the workfir on the host. To enable this access the uid and gid of the ansible user inside the container must match the uid and gid of the user on the host.

First, find your current uid and gid of your logged in user
```shell
id
```
```
uid=1001(ansible) gid=1001(ansible) groups=1001(ansible),118(docker)
```
--> The ids to put into the `docker-compose.yaml` are `1001` and `1001`
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
## Preexitsing MOADSD-NG, AWS or GCP Configuration Available
If you already have played with MOADSD-NG and followed the Wiki or have AWS and / or GCP already setup on your host, you can easily reuse these configurations by copying them into the `workdir` of moadsd-ng-server. Otherwise follow the steps below to create them with the available tool set within the moadsd-ng-server later on.

### Reuse AWS Configuration
```shell
cp -r ~/.aws ~/moadsd-ng-server/workdir/
cp ~/.ssh/moadsd-ng ~/moadsd-ng-server/workdir/.ssh/moadsd-ng
```

### Reuse GCP Configuration
```shell
cp -r ~/.config ~/moadsd-ng-server/workdir/
```

### Reuse MOADSD-NG Configuration
```shell
cp -r ~/moadsd-ng ~/moadsd-ng-server/workdir/
cp .vault-pass.txt ~/moadsd-ng-server/workdir/
cp ansible.json ~/moadsd-ng-server/workdir/
```

## Run
Run the server by (even without building it before)
```shell
docker-compose run moadsd-ng-server /bin/bash
```

## Preparations Required when Starting from Scratch
If you're starting from scratch you need to connect to your cloud account(s) now.

### Google
Now, we're connecting to your Google Cloud account and create a project.

```shell
$ gcloud init
```
You will be asked to pick the project you're willing to use or simply create a new one
```
Pick cloud project to use:
 [1] erudite-variety-696969
 [2] Create a new project
Please enter numeric choice or text value (must exactly match list
item):  2
```
Finally configure the default GCE region name.

Next, we will create a service account with owner permissions for the project.

```shell
$ gcloud iam service-accounts create ansible \
    --display-name "Ansible Account"
$ gcloud iam service-accounts keys create ~/ansible.json \
    --iam-account=ansible@<project id>.iam.gserviceaccount.com
$ gcloud projects add-iam-policy-binding <project id> \
    --member='serviceAccount:ansible@<project id>.iam.gserviceaccount.com' \
    --role='roles/owner'
```
Now, we need to enable billing and afterwards the compute API within our project. For that, we first need to look up available billing accounts.
```shell
$ gcloud alpha billing accounts list
```
```
ACCOUNT_ID            NAME                 OPEN  MASTER_ACCOUNT_ID
019XXX-6XXXX9-4XXXX1  My Billing Account   True
```
We now link that billing account to our project.
```shell
$ gcloud alpha billing projects link <project id> \
    --billing-account 019XXX-6XXXX9-4XXXX1
```
```
billingAccountName: billingAccounts/019XXX-6XXXX9-4XXXX1
billingEnabled: true
name: projects/<project id>/billingInfo
projectId: <project id>
```
And finally enable the API.
```shell
$ gcloud services enable compute.googleapis.com
```
```
Operation "operations/acf.6dd93cb1-644b-44a1-b85c-6388f4dd288e" finished successfully.
```

**Next Step:** [Google GCP](https://github.com/mawinkler/moadsd-ng/wiki/Google-GCP)

### AWS
Use the configure option to continue with the AWS CLI configuration:
```shell
$ aws configure
```
```
AWS Access Key ID [None]: <access key>
AWS Secret Access Key [None]: <secret key>
Default region name [None]: <default region>
Default output format [None]: json
```
Example for the default region would be `eu-central-1` or `eu-west-1`.

**Next Step:** [Amazon AWS](https://github.com/mawinkler/moadsd-ng/wiki/Amazon-AWS)

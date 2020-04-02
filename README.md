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

First, find your current uid of your logged in user
```shell
# Example from a linux environment
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
```shell
# Example from a Mac OS X environment
id
```
```
uid=501(markus) gid=20(staff) groups=20(staff), ...
```
--> The ids to put into the `docker-compose.yaml` are `1001` and `1001`
```
    build:
      context: .
      args:
        uid: 501
        gid: 20
```
## Build
To build the container image run
```shell
./build.sh
```
This script will build the container image, fetch the generated `/home/ansible`-directory and finally populates the `./workdir`.

## Get it up and Running
Depending on whether you start from scratch or have already played with MOADSD-NG the following two chapters will guide you. First is applicable, if you're alredy using MOADSD-NG, second when you're going to start from scratch.

### Preexitsing MOADSD-NG, AWS or GCP Configuration Available
If you already have played with MOADSD-NG and followed the Wiki or have AWS and / or GCP already setup on your host, you can easily reuse these configurations by copying them into the `workdir` of moadsd-ng-server. Otherwise skip this chapter and proceed with the `Run`-chapter. Then follow the steps below to create the credentials and logins with the available tool set within the moadsd-ng-server later on.

**Migration**
```shell
./migrate.sh
```

**Run moadsd-ng-server**

Run the server with
```shell
./start.sh
```

For more information on the moadsd-ng-server see the **House Keeping** chapter below.

## Preparations Required when Starting from Scratch
If you're starting from scratch you need to connect to your cloud account(s) now.

**Run moadsd-ng-server**

First, run the server with
```shell
./start.sh
```

For more information on the moadsd-ng-server see the **House Keeping** chapter below.

**Get MOADSD-NG**

Do a
```shell
git clone -b configurator https://github.com/mawinkler/moadsd-ng.git
cd moadsd-ng
```

**Ansible Vault**

For all credentials, the `ansible-vault` is used.
Create a file called `.vault-pass.txt` in the home directory of the `ansible`user with a secret password.
```shell
echo '<YOUR VERY STRONG PASSWORD>' > ~/.vault-pass.txt
chmod 600 ~/.vault-pass.txt
```
**Google**

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
export PROJECT_ID=<project-id>
gcloud iam service-accounts create ansible \
  --display-name "Ansible Account"
gcloud iam service-accounts keys create ~/ansible.json \
  --iam-account=ansible@${PROJECT_ID}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:ansible@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/owner"
```
Now, we need to enable billing and afterwards the compute API within our project. For that, we first need to look up available billing accounts.
```shell
gcloud alpha billing accounts list
```
```
ACCOUNT_ID            NAME                 OPEN  MASTER_ACCOUNT_ID
019XXX-6XXXX9-4XXXX1  My Billing Account   True
```
We now link that billing account to our project.
```shell
gcloud alpha billing projects link ${PROJECT_ID} \
  --billing-account 019XXX-6XXXX9-4XXXX1
```
```
billingAccountName: billingAccounts/019XXX-6XXXX9-4XXXX1
billingEnabled: true
name: projects/<project-id>/billingInfo
projectId: <project-id>
```
And finally enable the API which may take a minute or two.
```shell
gcloud services enable compute.googleapis.com
```
```
Operation "operations/acf.6dd93cb1-644b-44a1-b85c-6388f4dd288e" finished successfully.
```

*Next Step:* [Google GCP](https://github.com/mawinkler/moadsd-ng/wiki/Google-GCP)

**AWS**

Use the configure option to continue with the AWS CLI configuration:
```shell
aws configure
```
```
AWS Access Key ID [None]: <access key>
AWS Secret Access Key [None]: <secret key>
Default region name [None]: <default region>
Default output format [None]: json
```
Example for the default region would be `eu-central-1` or `eu-west-1`.

When using windows instances within AWS EC2 we need to have an keypair to do an initial password change for the administrator. To create it do the following:
```shell
aws ec2 create-key-pair --key-name moadsd-ng | \
  jq -r '.KeyMaterial' > ~/.ssh/moadsd-ng
chmod 600 ~/.ssh/moadsd-ng
```
If AWS complains that the keypair already exists simply change the `--key-name moadsd-ng` to something different like `--key-name moadsd-ng-server`.
We now have a private key which allows us to authenticate to the instances.

**Configurator**

Last step for the preparation is to configure MOADSD-NG. We do that by the use of the build-in configurator.

First, we create our `configuration.yml` file.
```shell
cp configuration.yml.sample configuration.yml
vi configuration.yml
```
Within the sample configuration, a standard Kubernets cluster is defined to which Smart Check, Jenkins, Prometheus and Grafana are getting deployed. Minimal settings to be defined by you are marked with **MANDATORY**.
All other settings available for the configurator can be reviewed within the default-file.
```
cat roles/configurator/defaults/main.yml
```
*Please, do not change that file!!*

To change settings for your MOADSD-NG overwrite the values as required within your `configuration.yml` and rerun the configurator.

To run the configurator call the menu of MOADSD-NG, select the cloud and choose configurator.
```shell
./menu.sh
Please choose the target environment:
1) gcp		  3) esx	          5) switch_to_gcp  7) switch_to_esx
2) aws		  4) site_secrets   6) switch_to_aws
#? 1
Please choose the playbook:
1) site				                 6) pause
2) deploy			                 7) resume
3) deploy_endpoints		         8) terminate
4) jenkins_create_credentials	 9) terminate_site
5) deploy_gitlab_runners	    10) configurator
#? 10
```


## House Keeping
Assuming you are within the `moadsd-ng-server`directory.

**Run moadsd-ng-server**

Run the server with
```shell
./start.sh
```

You are now directly within your server environment where you can work with MOADSD-NG as before, but within an isolated and easy to move container.

**Exit from moadsd-ng-server**

To exit the container environment press `^d`, the container will stay alive.

**Stop moadsd-ng-server**

To stop a running instance run
```shell
./stop.sh
```

**Backup and Restore**

Simply tar / zip the moadsd-ng-server directory. It contains everything which is required to restore or relocate the environment.

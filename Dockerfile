FROM ubuntu:18.04

ARG VERSION=0.1
ARG user=ansible
ARG group=ansible
ARG uid
ARG gid

# root context
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN addgroup -gid ${gid} ${group} || true
RUN useradd -m -s /bin/bash -d /home/${user} -u ${uid} -g ${gid} ${user}

LABEL Description="This is the Ansible Server for MOADSD-NG"

ARG WORKDIR=/home/${user}

COPY add-apt-repository /usr/bin

RUN apt update && \
    apt install -y sudo vim jq figlet wget curl ssh python3 software-properties-common git locales-all libffi6 libffi-dev libssl-dev && \
    add-apt-repository universe && \
    apt update && \
    apt install -y python3-pip

RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/custom-users && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    figlet "MOADSD-NG Server" > /etc/motd

# user context
USER ${user}
WORKDIR /home/${user}

RUN pip3 install ansible netaddr pywinrm --user

RUN echo 'export PATH=$PATH:$HOME/.local/bin' >> /home/${user}/.bashrc && \
    echo 'export LC_CTYPE=en_US.UTF-8' >> /home/${user}/.bashrc && \
    wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -O .ansible.cfg && \
    sed -i 's/^#stdout_callback = yaml/stdout_callback = yaml/g' .ansible.cfg && \
    sed -i 's/^#display_skipped_hosts = True/display_skipped_hosts = False/g' .ansible.cfg && \
    sed -i 's/^#control_path_dir = \~\/\.ansible\/cp/control_path = \/dev\/shm\/cp%%h-%%p-%%r/g' .ansible.cfg && \
    sed -i '23 a force_valid_group_names = ignore' .ansible.cfg && \
    mkdir -p ~/.ssh && chmod 700 ~/.ssh && ssh-keygen -q -f ~/.ssh/id_rsa  -P ""

# Google
RUN pip3 install requests google-auth --user && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    sudo apt-get update && \
    sudo apt-get install -y google-cloud-sdk

# AWS
RUN DEBIAN_FRONTEND="noninteractive" sudo apt install -y awscli && \
    pip3 install boto boto3 --user

#RUN git clone https://github.com/mawinkler/moadsd-ng.git
RUN tar cpzf /tmp/ansible.tgz /home/ansible && \
    echo "cat /etc/motd" >> .bashrc

WORKDIR /home/${user}

ENTRYPOINT ["/bin/bash"]

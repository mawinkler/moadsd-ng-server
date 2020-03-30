FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION=0.1
ARG user=ansible
ARG group=ansible
ARG uid=1000
ARG gid=1000
ARG vault_password=TrendM1cr0

RUN addgroup -gid ${gid} ${group}
RUN useradd -m -s /bin/bash -d /home/${user} -u ${uid} -g ${gid} ${user}

LABEL Description="This is the Ansible Server for MOADSD-NG"

ARG WORKDIR=/home/${user}

# RUN mkdir -p /usr/bin/
COPY add-apt-repository /usr/bin

RUN apt update && \
    apt install -y sudo vim jq wget curl ssh python3 software-properties-common git && \
    add-apt-repository universe && \
    apt update && \
    apt install -y python3-pip

RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/custom-users

USER ${user}
WORKDIR /home/${user}

RUN pip3 install ansible --user
#&& \
RUN echo 'export PATH=$PATH:$HOME/.local/bin' >> /home/${user}/.bashrc && \
    echo 'export LC_CTYPE=en_US.UTF-8' >> /home/${user}/.bashrc && \
    wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg -O .ansible.cfg && \
    sed -i 's/^#stdout_callback = yaml/stdout_callback = yaml/g' .ansible.cfg && \
    sed -i 's/^#display_skipped_hosts = True/display_skipped_hosts = False/g' .ansible.cfg && \
    sed -i '23 a force_valid_group_names = ignore' .ansible.cfg && \
    mkdir -p ~/.ssh && chmod 700 ~/.ssh && ssh-keygen -q -f ~/.ssh/id_rsa  -P "" && \
    echo 'TrendM1cr0' > ~/.vault-pass.txt && chmod 600 ~/.vault-pass.txt

RUN sudo apt install -y locales-all

RUN pip3 install netaddr --user
#RUN sudo apt install -y libffi6 libffi-dev libssl-dev
#RUN pip3 install pywinrm --user --no-binary :all:

# Google
RUN pip3 install requests google-auth --user && \
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    sudo apt-get update && \
    sudo apt-get install -y google-cloud-sdk

# AWS
#RUN sudo apt install -y awscli && \
#    pip3 install boto boto3 --user


#RUN git clone https://github.com/mawinkler/moadsd-ng.git

WORKDIR /home/${user}

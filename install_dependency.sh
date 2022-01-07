#!/bin/bash

cd /tmp

# 1. Install docker
sudo apt-get update

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io


# 2.Install docker-compose
sudo apt-get install python-pip  python3-pip python-dev libffi-dev openssl libssl-dev gcc libc-dev make

# Base on ubuntu x86_64
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo docker-compose version


# 3.Install EMQ-X Broker
wget https://repos.emqx.io/install_emqx.sh 
sudo bash install_emqx.sh
sudo systemctl start emqx
sudo systemctl enable emqx
sudo systemctl status emqx

cd -
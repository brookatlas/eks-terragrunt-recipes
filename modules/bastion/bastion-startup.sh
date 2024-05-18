#!/bin/bash

# install git
sudo yum install git -y

# remove old aws-cli
sudo yum remove awscli
sudo rm -rf /bin/aws /usr/bin/aws

# install new-aws-cli
cd /home/ec2-user
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -s /usr/local/bin/aws /usr/bin/aws

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/bin/kubectl
sudo chmod +x /usr/bin/kubectl

# install terraform
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform-1.6.6-1.x86_64

# install terragrunt
sudo wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.55.19/terragrunt_linux_amd64
sudo mv ./terragrunt_linux_amd64 /usr/local/bin/terragrunt
sudo chmod u+x /usr/local/bin/terragrunt
sudo ln -s /usr/local/bin/terragrunt /usr/bin/terragrunt


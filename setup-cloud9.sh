# install terraform if not exists
echo "checking if terraform is installed."
if [ ! -f /usr/local/bin/terraform ]; then
    echo "installing terraform"
    wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
    unzip terraform_1.6.6_linux_amd64.zip
    sudo mv terraform /usr/local/bin
    rm -f ./terraform_1.6.6_linux_amd64.zip
else
    echo "terraform is already installed. continuing"
fi

# install terragrunt if not exists
echo "checking if terragrunt is installed."
if [ ! -f /usr/local/bin/terragrunt ]; then
    echo "installing terragrunt"
    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.57.9/terragrunt_linux_amd64
    mv terragrunt_linux_amd64 terragrunt
    sudo chmod u+x terragrunt
    sudo mv terragrunt /usr/local/bin
else
    echo "terragrunt is already installed. continuing"
fi
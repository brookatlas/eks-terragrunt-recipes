### description

an example terragrunt stack for deploying a eks cluster, with the following basic add-ons:
* vpc-cni
* coredns
* alb-ingress-controller
* external-dns

I will also add the following examples to deployment:
1. karpenter
2. jenkins as a service
3. grafana
4. grafana's tempo


## how to use
1. run the initial terragrunt run only on the following modules:
* base/network
* cloud9

2. then connect to the created cloud9 environment, and clone this repository:
* eks/cluster

<<<<<<< Updated upstream
2. get the kubeconfig via the following command:
aws eks update-kubeconfig --region region-code --name my-cluster

3. happy k8s operations!
=======
3. run the "setup-cloud9.sh" script
4. you may now run "terragrunt run-all apply"
5. add the eks api server security group to the cloud9 ec2 manually for now
6. get the kubeconfig via the following command:
aws eks update-kubeconfig --region region-code --name my-cluster

7. happy k8s operations!


# notes on accessing github:
1. make sure to config your username:
git config --global user.name GITHUB_USERNAME
git config --global user.email GITHUB_EMAIL
2. create a github access token for your service account user(classic)
3. set it up in the following way:
git remote set-url origin https://<GITHUB_TOKEN>@github.com/<REPO_OWNER>/<REPO_NAME>.git

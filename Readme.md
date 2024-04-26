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
* https://github.com/brookatlas/eks-terragrunt-recipes.git

3. run the "setup-cloud9.sh" script
4. you may now run "terragrunt run-all apply"
5. get the kubeconfig via the following command:
aws eks update-kubeconfig --region region-code --name my-cluster

6. happy k8s operations!


# notes on accessing github:
1. make sure to config your username:
git config --global user.name GITHUB_USERNAME
git config --global user.email GITHUB_EMAIL
2. when pushing a new branch, use the following scheme:
git push --set-upstream origin BRANCH_NAME brookatlas GITHUB_TOKEN
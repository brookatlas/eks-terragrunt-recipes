### description

an example terragrunt stack for deploying a eks cluster, with the following basic add-ons:
* vpc-cni
* coredns
* alb-ingress-controller
* external-dns
* ebs-csi
* karpenter


## how to use
1. run the initial terragrunt run only on the live paths:
* base/network
* eks/cluster
2. then, make sure you have access to the cluster(able run the following 2 commands):
aws eks update-kubeconfig --region region-code --name my-cluster
kubectl get pods
3. then run the rest of the modules under "cluster/controllers"
4. happy k8s operations!


### what is wip
* external-dns


# notes on accessing github:
1. make sure to config your username:
git config --global user.name GITHUB_USERNAME
git config --global user.email GITHUB_EMAIL
2. create a github access token for your service account user(classic)
3. set it up in the following way:
git remote set-url origin https://<GITHUB_TOKEN>@github.com/<REPO_OWNER>/<REPO_NAME>.git
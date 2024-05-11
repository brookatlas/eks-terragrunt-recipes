### description

an example terragrunt stack for deploying a eks cluster, with the following basic add-ons:
* vpc-cni
* coredns
* alb-ingress-controller
* external-dns
* ebs-csi controller
* efs-csi controller
* karpenter


## how to use
1. run the initial terragrunt run only on the live paths:
* base/network
* eks/bastion
* eks/cluster

2. then, connect to the bastion host via ssm manager
3. then, make sure you have access to the cluster(able run the following 2 commands):
aws eks update-kubeconfig --region region-code --name my-cluster
kubectl get pods
4. clone the repo to the bastion host
5. then run the rest of the modules under "cluster/controllers" from the bastion host
6. happy k8s operations!


example diagram of the deployed architecture:
![Alt text](./eks-terragrunt-recipes-diagram.svg)
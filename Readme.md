### description
a production ready terragrunt stack for deploying a Production ready, Private EKS on AWS.

## what this stack do?
the cluster includes the most popular/used sets of extensions/controllers:
* vpc-cni - for configuring network security between workloads/pods
* coredns - mandatory
* alb-ingress-controller - for configuring inbound access to services(load balancer/app load balancer)
* external-dns - for configuring dns across services
* ebs-csi controller - for allocating EBS volumes via EKS
* efs-csi controller - for allocating EFS volumes via EKS
* karpenter - for fast and cost effective provisioning, allocation and management of EKS nodes


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


### example diagram of the deployed architecture


![Alt text](./eks-terragrunt-recipes-diagram.svg)
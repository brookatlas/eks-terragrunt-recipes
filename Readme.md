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

2. then, make sure you have access to the cluster(able run the following 2 commands):
aws eks update-kubeconfig --region region-code --name my-cluster
kubectl get pods

3. then run the rest of the modules under "cluster/controllers"
4. happy k8s operations!
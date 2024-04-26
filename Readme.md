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

2. get the kubeconfig via the following command:
aws eks update-kubeconfig --region region-code --name my-cluster

3. happy k8s operations!

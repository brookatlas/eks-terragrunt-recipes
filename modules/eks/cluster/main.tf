module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  count = var.create ? 1 : 0

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id


  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  enable_cluster_creator_admin_permissions = true

  subnet_ids                      = var.subnet_ids


  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_groups = { for node_group_name, node_group_config in var.managed_node_groups : node_group_name => node_group_config }
}
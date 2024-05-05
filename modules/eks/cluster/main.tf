module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  count = var.create ? 1 : 0

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id


  cluster_endpoint_private_access = var.private_access
  cluster_endpoint_public_access  = var.public_access

  cluster_endpoint_public_access_cidrs = local.public_access_cidr_blocks
  enable_cluster_creator_admin_permissions = true

  subnet_ids                      = var.subnet_ids


  cluster_addons = {
    coredns = {
      most_recent = true,
      configuration_values = jsonencode({
        computeType = "Fargate"
        resources = {
          limits = {
            cpu = "0.25"
            memory = "256M"
          }
          requests = {
            cpu = "0.25"
            memory = "256M"
          }
        }
      })
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

  fargate_profile_defaults = {
    node_iam_role_additional_policies = {
      additional = ""
    }
  }

  fargate_profiles = {
    karpenter = {
      selectors = [
        {
          namespace = "karpenter"
        }
      ]
    },
    kube-system = {
      selectors = [
        {
          namespace = "kube-system"
        }
      ]
    }
  }

  eks_managed_node_groups = { for node_group_name, node_group_config in var.managed_node_groups : node_group_name => node_group_config }

  tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
}
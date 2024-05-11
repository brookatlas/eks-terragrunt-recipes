module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  count = var.create ? 1 : 0

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id


  cluster_endpoint_private_access = var.private_access
  cluster_endpoint_public_access  = var.public_access

  cluster_endpoint_public_access_cidrs = var.allow_current_ip_public_access ? concat(["${chomp(data.http.myip[count.index].response_body)}/32"], var.public_access_cidr_blocks) : var.public_access_cidr_blocks
  enable_cluster_creator_admin_permissions = true
  create_cluster_primary_security_group_tags = false

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

  access_entries = {
    bastion_host = {
      principal_arn = var.bastion_role_arn
      kubernetes_groups = []
      type = "EC2_LINUX"
    }
  }

  cluster_security_group_additional_rules = {
    allow_ingress_bastion = {
      type = "ingress"
      to_port = 443
      from_port = 443
      protocol = "TCP"
      source_security_group_id = var.bastion_security_group_id
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
terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 15
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", var.cluster_name]
  }
}

module "karpenter" {
  count = var.create ? 1 : 0

  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.8.4"

  cluster_name = var.cluster_name

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  enable_irsa = true
  irsa_oidc_provider_arn = var.cluster_oidc_provider_arn
}

resource "helm_release" "karpenter" {
  namespace           = "karpenter"
  create_namespace    = true
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = "0.35.1"
  wait                = false

  values = [
    templatefile("${path.module}/karpenter-values.yaml", {
      clusterName: var.cluster_name,
      clusterEndpoint: var.cluster_endpoint,
      interruptionQueue: module.karpenter[0].queue_name,
      karpenterRoleArn: module.karpenter[0].iam_role_arn
    })
  ]
}

resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = templatefile("${path.module}/nodeclasses/default-node-class.yaml", {
    nodeIamRoleName: module.karpenter[0].node_iam_role_name,
    clusterName: var.cluster_name,
    securityGroupId: var.cluster_primary_security_group_id
  })

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = templatefile("${path.module}/nodepools/default-node-pool.yaml", {})

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}


resource "kubectl_manifest" "karpenter_addons_node_class" {
  yaml_body = templatefile("${path.module}/nodeclasses/addons-node-class.yaml", {
    nodeIamRoleName: module.karpenter[0].node_iam_role_name,
    clusterName: var.cluster_name,
  })

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_addons_node_pool" {
  yaml_body = templatefile("${path.module}/nodepools/kube-addons-node-pool.yaml", {})

  depends_on = [
    kubectl_manifest.karpenter_addons_node_class
  ]
}
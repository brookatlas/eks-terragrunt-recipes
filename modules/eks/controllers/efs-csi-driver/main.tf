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
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  load_config_file = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

resource "aws_iam_role" "role_for_efs_csi_controller" {
  count = var.create ? 1 : 0
  name  = "efs-csi-driver-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : var.cluster_oidc_provider_arn,
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${local.cluster_oidc_issuer_without_https}:aud" : "sts.amazonaws.com",
            "${local.cluster_oidc_issuer_without_https}:sub" : "system:serviceaccount:${var.namespace}:efs-csi-*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_efs_csi_driver_policy_to_role" {
  count      = var.create ? 1 : 0
  name       = "attach-efs-csi-driver-policy-to-role"
  policy_arn = data.aws_iam_policy.amazon_efs_csi_driver_policy[count.index].arn
  roles      = [aws_iam_role.role_for_efs_csi_controller[count.index].name]
}


resource "helm_release" "aws_efs_csi_driver" {
  count = var.create ? 1 : 0
  chart      = "aws-efs-csi-driver"
  name       = "aws-efs-csi-driver"
  namespace  = var.namespace
  create_namespace = true
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/eks/aws-efs-csi-driver"
  }

  set {
    name = "controller.nodeselector.type"
    value = "karpenter-addons-nodepool"
  }

  set {
    name  = "controller.serviceAccount.create"
    value = true
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.role_for_efs_csi_controller[count.index].arn
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }
}
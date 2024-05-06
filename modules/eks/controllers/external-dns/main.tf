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
resource "aws_iam_policy" "policy_for_external_dns" {
  count = var.create ? 1 : 0
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets"
        ],
        "Resource" : [
          "arn:aws:route53:::hostedzone/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "role_for_external_dns" {
  count = var.create ? 1 : 0
  name  = "external-dns-controller-role"
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
            "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${var.cluster_oidc_issuer_url}:aud" : "sts.amazonaws.com",
            "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${var.cluster_oidc_issuer_url}:sub" : "system:serviceaccount:${var.namespace}:external-dns"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_external_dns_policy_to_role" {
  count      = var.create ? 1 : 0
  name       = "attach-external-dns-policy-to-role"
  policy_arn = aws_iam_policy.policy_for_external_dns[count.index].arn
  roles      = [aws_iam_role.role_for_external_dns[count.index].name]
}

resource "kubectl_manifest" "external_dns_service_account" {
  count = var.create ? 1 : 0
  yaml_body = templatefile("external-dns-service-account.yaml", {
    serviceAccountName=var.service_account_name,
    namespace=var.namespace,
    serviceAccountRoleArn=aws_iam_role.role_for_external_dns[count.index].arn
  })
}

resource "kubectl_manifest" "external_dns_cluster_role" {
  count = var.create ? 1 : 0
  yaml_body = templatefile("external-dns-cluster-role.yaml", {})
}

resource "kubectl_manifest" "external_dns_cluster_role_binding" {
  count = var.create ? 1 : 0
  yaml_body = file("external-dns-cluster-role-binding.yaml")

  depends_on = [ kubectl_manifest.external_dns_cluster_role ]
}

resource "kubectl_manifest" "external_dns_deployment" {
  count = var.create ? 1 : 0
  yaml_body = templatefile("external-dns-deployment.yaml", {
    domainFilter=var.domain_filter,
    awsRegion=data.aws_region.current.name
  })
  depends_on = [ kubectl_manifest.external_dns_service_account ]
}

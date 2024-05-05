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

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
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
          "arn:aws:route53:::hostedzone/"
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
          ""
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


resource "kubernetes_manifest" "external_dns_service_account" {
  count = var.create ? 1 : 0
  manifest = {
    apiVersion = "v1",
    kind       = "ServiceAccount",
    metadata = {
      name      = var.service_account_name,
      namespace = "kube-system",
      annotations = {
        "eks.amazonaws.com/role-arn" : aws_iam_role.role_for_external_dns[count.index].arn
      }
    }
  }

}

resource "helm_release" "aws-alb-ingress-controller" {
  count      = var.create ? 1 : 0
  name       = var.service_account_name
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [
    templatefile("${path.module}/alb-controller-values.yaml", {
      clusterName          = var.cluster_name,
      serviceAccountName   = var.service_account_name,
      createServiceAccount = false
      vpcId                = var.vpc_id
    })
  ]

  depends_on = [kubernetes_manifest.aws_load_balancer_controller_service_account]
}

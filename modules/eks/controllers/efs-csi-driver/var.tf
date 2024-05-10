variable "create" {
    type = bool
    description = "install the efs csi driver or not. set as bool"
}

variable "cluster_name" {
    type = string
    description = "name of cluster the controller is installed onto"
}

variable "cluster_oidc_issuer_url" {
    type = string
    description = "openid connect issuer URL of EKS cluster"
}

variable "cluster_oidc_provider_arn" {
    type = string
    description = "openid connect provider ARN of EKS cluster"
}

variable "service_account_name" {
    type = string
    description = "service account name for efs csi driver"
    default = "efs-csi-driver"
}

variable "namespace" {
    type = string
    description = "name of namespace to install the efs csi driver onto"
    default = "kube-addons"
}

variable "cluster_endpoint" {
    type = string
    description = "eks cluster https endpoint"
}

variable "cluster_ca_certificate" {
    type = string
    description = "eks cluster ca certificate"
}

locals {
    cluster_oidc_issuer_without_https = replace(var.cluster_oidc_issuer_url, "https://", "")
}
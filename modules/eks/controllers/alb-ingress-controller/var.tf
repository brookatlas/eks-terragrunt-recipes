variable "create" {
    type = bool
    description = "create the alb controller or not. set as bool"
}

variable "cluster_name" {
    type = string
    description = "name of cluster the controller is installed onto"
}

variable "service_account_name" {
    type = string
    description = "service account name for the aws load balancer controller"
    default = "aws-load-balancer-controller"
}

variable "namespace" {
    type =  string
    description = "namespace where the alb load balancer controller will be installed in."
    default = "kube-system"
}

variable "cluster_endpoint" {
    type = string
    description = "eks cluster https endpoint"
}

variable "cluster_ca_certificate" {
    type = string
    description = "eks cluster ca certificate"
}

variable "cluster_oidc_provider_arn" {
    type = string
    description = "openid connect provider ARN of EKS cluster"
}

variable "cluster_oidc_issuer_url" {
    type = string
    description = "openid connect issuer URL of EKS cluster"
}

variable "vpc_id" {
    type = string
    description = "vpc_id used for the installation of alb controller"
}


locals {
  cluster_oidc_issuer_without_https = replace(var.cluster_oidc_issuer_url, "https://", "")
}
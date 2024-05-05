variable "create" {
    type = bool
    description = "create the alb controller or not. set as bool"
}

variable "cluster_name" {
    type = string
    description = "name of cluster the controller is installed onto"
}

variable "cluster_oidc_issuer_url" {
    type = string
    description = "openid connect issuer URL of EKS cluster"
}

variable "domain_filter" {
    type = string
    description = "domain filter for external dns, to match specific domain zone"
}

variable "cluster_oidc_provider_arn" {
    type = string
    description = "openid connect provider ARN of EKS cluster"
}

variable "service_account_name" {
    type = string
    description = "service account name for external-dns"
    default = "external-dns"
}

variable "namespace" {
    type = string
    description = "name of namespace to install the external-dns onto"
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

variable "vpc_id" {
    type = string
    description = "vpc id where eks cluster is deployed onto"
}
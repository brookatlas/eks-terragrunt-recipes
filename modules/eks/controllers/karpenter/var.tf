variable "create" {
    type = bool
}

variable "cluster_name" {
    type = string
}

variable "cluster_primary_security_group_id" {
    type = string
}

variable "cluster_oidc_issuer_url" {
    type = string
    description = "openid connect issuer URL of EKS cluster"
}

variable "cluster_oidc_provider_arn" {
    type = string
    description = "openid connect provider ARN of EKS cluster"
}

variable "cluster_endpoint" {
    type = string
    description = "eks cluster https endpoint"
}

variable "cluster_ca_certificate" {
    type = string
    description = "eks cluster ca certificate"
}
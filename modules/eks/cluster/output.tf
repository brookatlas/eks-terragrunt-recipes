output "cluster_name" {
    value = module.eks[0].cluster_name
}

output "cluster_primary_security_group_id" {
    value = module.eks[0].cluster_primary_security_group_id
}

output "cluster_oidc_issuer_url" {
    value = module.eks[0].cluster_oidc_issuer_url
}


output "cluster_oidc_provider_arn" {
    value = module.eks[0].oidc_provider_arn
}

output "cluster_ca_certificate" {
    value = module.eks[0].cluster_certificate_authority_data
}

output "cluster_endpoint" {
    value = module.eks[0].cluster_endpoint
}
output "cluster_name" {
    value = module.eks[0].cluster_name
}

output "cluster_primary_security_group_id" {
    value = module.eks[0].cluster_primary_security_group_id
}
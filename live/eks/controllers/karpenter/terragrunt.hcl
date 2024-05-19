include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/eks/controllers/karpenter"
}

dependency "eks" {
    config_path = "../../../../live/eks/cluster"
    mock_outputs = {
        cluster_name = "some-cluster-name"
        cluster_oidc_issuer_url = "some_oidc_issuer_url"
        cluster_ca_certificate = "c29tZV9jbHVzdGVyX2NhX2NlcnRpZmljYXRl"
        cluster_endpoint = "some_cluster_endpoint"
        cluster_oidc_provider_arn = "some_oidc_provider_arn"
        cluster_primary_security_group_id = "some-cluster-primary-security-group-id"
    }
}

inputs = {
  create = true
  cluster_name = dependency.eks.outputs.cluster_name
  cluster_oidc_issuer_url = dependency.eks.outputs.cluster_oidc_issuer_url
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.eks.outputs.cluster_ca_certificate
  cluster_oidc_provider_arn = dependency.eks.outputs.cluster_oidc_provider_arn
  cluster_primary_security_group_id = dependency.eks.outputs.cluster_primary_security_group_id
}
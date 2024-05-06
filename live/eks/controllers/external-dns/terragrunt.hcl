include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/eks/controllers/external-dns"
}


dependency "network" {
  config_path = "../../../../live/base/network"
  mock_outputs = {
    vpc_id = "some-vpc-id"
    public_subnet_ids = ["public-subnet-id-1", "public-subnet-id-2", "public-subnet-id-3"]
    private_subnet_ids = ["private-subnet-id-1", "private-subnet-id-2", "private-subnet-id-3", "private-subnet-id-4", "private-subnet-id-5", "private-subnet-id-6"]
  }
}

dependency "eks" {
    config_path = "../../../../live/eks/cluster"
    mock_outputs = {
        cluster_name = "some-cluster-name"
        cluster_oidc_issuer_url = "some_oidc_issuer_url"
        cluster_ca_certificate = "c29tZV9jbHVzdGVyX2NhX2NlcnRpZmljYXRl"
        cluster_endpoint = "some_cluster_endpoint"
        cluster_oidc_provider_arn = "some_oidc_provider_arn"
    }
}

inputs = {
  create = true
  cluster_name = dependency.eks.outputs.cluster_name
  cluster_oidc_issuer_url = dependency.eks.outputs.cluster_oidc_issuer_url
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.eks.outputs.cluster_ca_certificate
  cluster_oidc_provider_arn = dependency.eks.outputs.cluster_oidc_provider_arn
  domain_filter = "testme-brookatlas.com"
  vpc_id = dependency.network.outputs.vpc_id
}
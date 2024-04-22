terraform {
  source = "../../../modules/eks/bastion"
}


dependency "network" {
  config_path = "../../../live/base/network"
  mock_outputs = {
    vpc_id = "some-vpc-id"
    public_subnet_ids = ["public-subnet-id-1"]
    private_subnet_ids = ["private-subnet-id-1", "private-subnet-id-2"]
  }
}

dependency "eks_cluster" {
  config_path = "../../../live/eks/cluster"
  mock_outputs = {
    cluster_name = "some-cluster-name"
    cluster_primary_security_group_id = "some-cluster-primary-security-group-id"
  }
}


inputs = {
  create = true
  cluster_name = dependency.eks_cluster.outputs.cluster_name
  cluster_security_group_id = dependency.eks_cluster.outputs.cluster_primary_security_group_id
  instance_name = "eks-bastion"
  vpc_id = dependency.network.outputs.vpc_id
  subnet_id = dependency.network.outputs.private_subnet_ids[0]
}
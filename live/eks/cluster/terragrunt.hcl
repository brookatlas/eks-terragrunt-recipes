terraform {
  source = "../../../modules/eks/cluster"
}


dependency "network" {
  config_path = "../../../live/base/network"
  mock_outputs = {
    vpc_id = "some-vpc-id"
    public_subnet_ids = ["public-subnet-id-1", "public-subnet-id-2"]
    private_subnet_ids = ["private-subnet-id-1", "private-subnet-id-2"]
  }
}

inputs = {
  create = true
  cluster_name = "my-cluster-test"
  cluster_version = "1.29"

  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = [dependency.network.outputs.private_subnet_ids[0], dependency.network.outputs.private_subnet_ids[1]]

  managed_node_groups = {
    test_private = {
      min_size     = 1
      max_size     = 10
      desired_size = 2

      instance_types = ["t3a.large", "t3.large"]
      
      capacity_type  = "SPOT"
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" 
      }
    }
  }
}
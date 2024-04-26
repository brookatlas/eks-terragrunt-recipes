include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/cloud9"
}


dependency "network" {
  config_path = "../../live/base/network"
  mock_outputs = {
    vpc_id = "some-vpc-id"
    public_subnet_ids = ["public-subnet-id-1", "public-subnet-id-2"]
    private_subnet_ids = ["private-subnet-id-1", "private-subnet-id-2", "private-subnet-id-3"]
  }
}

inputs = {
  create = true
  environment_name = "eks-cloud9-environment"
  subnet_id = dependency.network.outputs.private_subnet_ids[2]
}
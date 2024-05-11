include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/bastion"
}

dependency "network" {
  config_path = "../../live/base/network"
  mock_outputs = {
    vpc_id = "some-vpc-id"
    public_subnet_ids = ["public-subnet-id-1", "public-subnet-id-2"]
    private_subnet_ids = ["private-subnet-id-1", "private-subnet-id-2"]
  }
}

inputs = {
  create = true
  environment_name = "test"
  vpc_id = dependency.network.outputs.vpc_id
  subnet_id = dependency.network.outputs.public_subnet_ids[0]
}
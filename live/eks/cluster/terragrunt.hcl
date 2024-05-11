include "root" {
  path = find_in_parent_folders()
}

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

dependency "bastion" {
  config_path = "../../../live/bastion"
  mock_outputs = {
    bastion_role_arn = "some-role-arn"
    bastion_security_group_id = "some-security-group-id"
  }
}

inputs = {
  create = true
  cluster_name = "my-cluster-test"
  cluster_version = "1.29"

  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = [dependency.network.outputs.private_subnet_ids[0], dependency.network.outputs.private_subnet_ids[1]]
  public_access = false
  private_access = true
  allow_current_ip_public_access = false
  bastion_role_arn = dependency.bastion.outputs.bastion_role_arn
  bastion_security_group_id = dependency.bastion.outputs.bastion_security_group_id

  managed_node_groups = {}
}
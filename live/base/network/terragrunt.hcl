include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/base/network"
}

inputs = {
  create = true
  cidr_block = "172.1.0.0/16"
  cluster_name = "my-cluster-test"
  vpc_name = "eks-vpc"
  enable_nat_gateway = true
  enable_internet_gateway = true
  auto_assign_public_ip_address_to_public_subnets = true
  public_subnet_configurations = [
    {
        name = "public-subnet-a",
        cidr_block = "172.1.1.0/24"
        availability_zone = "il-central-1a"
    },
    {
        name = "public-subnet-b",
        cidr_block = "172.1.2.0/24"
        availability_zone = "il-central-1b"
    }
  ]

  private_subnet_configurations = [
    {
        name = "private-subnet-a",
        cidr_block = "172.1.10.0/24"
        availability_zone = "il-central-1a"
    },
    {
        name = "private-subnet-b",
        cidr_block = "172.1.11.0/24"
        availability_zone = "il-central-1b"
    },
    {
      name = "private-subnet-c"
      cidr_block = "172.1.12.0/24"
      availability_zone = "il-central-1c"
    }
  ]
}
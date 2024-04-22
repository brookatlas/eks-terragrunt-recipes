terraform {
  source = "../../../../modules/eks/controllers/alb-ingress-controller"
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
    }
}

inputs = {
  create = false
  cluster_name = dependency.eks.outputs.cluster_name
}
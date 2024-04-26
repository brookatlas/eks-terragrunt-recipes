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
    }
}

inputs = {
  create = true
  cluster_name = dependency.eks.outputs.cluster_name
}
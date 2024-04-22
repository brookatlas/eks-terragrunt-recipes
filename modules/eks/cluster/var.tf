variable "create" {
  type        = bool
  description = "create cluster or not"
}

variable "public_access" {
    type = bool
    description = "enable public access point for eks cluster"
    default = false
}


variable "private_access" {
    type = bool
    description = "enable private access for eks cluster"
    default = true
}

variable "managed_node_groups" {
  type = map(object({
    min_size = number
    max_size = number
    desired_size = number
    capacity_type = string
    instance_types = list(string)
  }))
}

variable "cluster_name" {
  type        = string
  description = "name of eks cluster"
}

variable "cluster_version" {
  type        = string
  description = "version of cluster"
}

variable "vpc_id" {
  type        = string
  description = "id of vpc to deploy the cluster onto"
}

variable "subnet_ids" {
  type        = list(string)
  description = "list of subnet id's where the pods will be scheduled onto"
}

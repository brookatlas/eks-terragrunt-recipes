variable "create" {
    type = bool
    description = "to create the bastion module or not."
}

variable "cluster_name" {
    type = string
}

variable "vpc_id" {
    type = string
    description = "id of vpc to deploy bastion onto"
}

variable "instance_type" {
    type = string
    description = "instance type of bastion to create"
    default = "t3a.micro"
}

variable "subnet_id" {
    type = string
    description = "id of public subnet to deploy bastion onto"
}

variable "instance_name" {
    type = string
    description = "name of instance to be served as bastion host"
}

variable "cluster_security_group_id" {
    type = string
}
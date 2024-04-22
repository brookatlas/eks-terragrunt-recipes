variable "create" {
    type = bool
    description = "to create the vpc or not."
}


variable "cluster_name" {
    type = string
}

variable "vpc_name" {
    type = string
    description = "name of vpc to create"
}

variable "cidr_block" {
    type = string
    description = "cidr block of the vpc to be created"
}


variable auto_assign_public_ip_address_to_public_subnets {
    type = bool
    description = "automatically assign public ip addresses to resources on public subnets"
    default = false
}

variable public_subnet_configurations {
    type = list(object({
      name = string
      cidr_block = string
      availability_zone = string
    }))
    description = "configuration of public subnets"
}

variable private_subnet_configurations {
    type = list(object({
      name = string
      cidr_block = string
      availability_zone = string
    }))
    description = "configuration of private subnets"
}

variable enable_nat_gateway {
    type = bool
    default = false
    description = "enable nat gateway in private subnet to public or not in case of outbound to 0.0.0.0."
}

variable enable_internet_gateway {
    type = bool
    default = false
    description = "enable internet gateway, to enable direct internet access from public subnets."
}
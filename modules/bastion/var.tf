variable "create" {
  type    = bool
  default = true
}
variable "environment_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}
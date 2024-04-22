variable "create" {
    type = bool
    description = "create the alb controller or not. set as bool"
}

variable "cluster_name" {
    type = string
    description = "name of cluster the controller is installed onto"
}

variable "service_account_name" {
    type = string
    description = "service account name for the aws load balancer controller"
    default = "aws-load-balancer-controller"
}
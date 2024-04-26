data "aws_ami" "ubuntu" {
  count = var.create ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


data "aws_security_group" "eks_main_security_group" {
  count = var.create ? 1 : 0
  id = var.cluster_security_group_id
}
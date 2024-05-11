data "aws_region" "current" {}

data "aws_ami" "amazon_linux_latest" {
  count = var.create ? 1 : 0
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}
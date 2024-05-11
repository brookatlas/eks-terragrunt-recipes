resource "aws_instance" "eks_bastion" {
  count = var.create ? 1 : 0
  instance_type = var.instance_type

  ami = data.aws_ami.amazon_linux_latest[count.index].id
  subnet_id = var.subnet_id

  tags = {
    "created-by" = "terraform",
    "Name" = var.environment_name 
  }

  iam_instance_profile = aws_iam_instance_profile.bastion_ec2_instance_profile[count.index].name
  vpc_security_group_ids = [
    aws_security_group.eks_bastion_security_group[count.index].id
  ]


  user_data = file("${path.module}/bastion-startup.sh")
}

resource "aws_security_group" "eks_bastion_security_group" {
  count =  var.create ? 1 : 0
  name = "${var.environment_name}-eks-bastion-security-group"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
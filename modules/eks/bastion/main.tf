resource "aws_instance" "bastion" {
  count = var.create ? 1 : 0
  ami           = data.aws_ami.ubuntu[count.index].id
  instance_type = var.instance_type
  subnet_id = var.subnet_id

  tags = {
    Name = var.instance_name
  }

  iam_instance_profile = aws_iam_instance_profile.bastion-instance-profile[count.index].name

  vpc_security_group_ids = [
    aws_security_group.bastion-sg[count.index].id
  ]

  user_data = "${file("user_data.sh")}"
}

resource "aws_iam_instance_profile" "bastion-instance-profile" {
    count = var.create ? 1 : 0
    name = "${aws_iam_role.bastion_role[count.index].name}-instance-profile"
    role = aws_iam_role.bastion_role[count.index].name
}

resource "aws_security_group" "bastion-sg" {
  count = var.create ? 1 : 0
  name = "bastion-sg"
  vpc_id = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "TCP"
    from_port = 0
    to_port = 65535
  }
}
resource "aws_cloud9_environment_ec2" "eks_cloud9_ec2" {
  count = var.create ? 1 : 0
  instance_type = var.instance_type
  name          = var.environment_name
  image_id      = "amazonlinux-2023-x86_64"
  subnet_id     = var.subnet_id
  connection_type = "CONNECT_SSM"


  depends_on = [ 
    aws_iam_instance_profile.AWSCloud9SSMInstanceProfile
  ]
}


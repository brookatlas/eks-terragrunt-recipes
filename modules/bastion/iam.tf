data "aws_iam_policy" "base_ssm_ec2_policy" {
  count = var.create ? 1 : 0
  name  = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "allow_eks_access" {
  count = var.create ? 1 : 0
  name  = "AWSEC2EksAccess"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "bastion_ec2_role" {
  count = var.create ? 1 : 0
  name  = "BastionEC2Role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : ["ec2.amazonaws.com"]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
    }
  )
  managed_policy_arns = [
    data.aws_iam_policy.base_ssm_ec2_policy[count.index].arn,
    aws_iam_policy.allow_eks_access[count.index].arn
  ]
}

resource "aws_iam_instance_profile" "bastion_ec2_instance_profile" {
  count = var.create ? 1 : 0
  name  = "BastionEC2InstanceProfile"
  role  = aws_iam_role.bastion_ec2_role[count.index].name
}

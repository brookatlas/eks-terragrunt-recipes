data "aws_iam_policy" "AWSCloud9SSMInstanceProfile" {
  name = "AWSCloud9SSMInstanceProfile"
}

resource "aws_iam_role" "AWSCloud9SSMAccessRole" {
    name = "AWSCloud9SSMAccessRole"
    assume_role_policy = jsonencode({
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": ["ec2.amazonaws.com","cloud9.amazonaws.com"]      
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    )
    path = "/service-role/"
    managed_policy_arns = [ data.aws_iam_policy.AWSCloud9SSMInstanceProfile.arn ]
}

resource "aws_iam_instance_profile" "AWSCloud9SSMInstanceProfile" {
  name = "AWSCloud9SSMInstanceProfile"
  role = aws_iam_role.AWSCloud9SSMAccessRole.name
  path = "/cloud9/"
}
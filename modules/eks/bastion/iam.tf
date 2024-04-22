resource "aws_iam_role" "bastion_role" {
  count = var.create ? 1 : 0
  name  = "bastion-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        }
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    "managed-by" : "terraform"
  }
}

resource "aws_iam_policy" "access_eks" {
  count = var.create ? 1 : 0
  name  = "bastionPolicyForEKS"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "eks:AccessKubernetesApi",
          "eks:ListFargateProfiles",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:DescribeFargateProfile",
          "eks:ListTagsForResource",
          "eks:ListUpdates",
          "eks:DescribeUpdate",
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion-ssm-policy" {
  count      = var.create ? 1 : 0
  role       = aws_iam_role.bastion_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "bastion-eks-access-policy" {
  count = var.create ? 1 : 0
  role = aws_iam_role.bastion_role[count.index].name
  policy_arn = aws_iam_policy.access_eks[count.index].arn
}



resource "aws_eks_access_entry" "bastion_access_entry" {
  count         = var.create ? 1 : 0
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.bastion_role[count.index].arn
}

resource "aws_eks_access_policy_association" "bastion_admin_role" {
  count        = var.create ? 1 : 0
  cluster_name = var.cluster_name
  access_scope {
    type = "cluster"
  }
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = aws_iam_role.bastion_role[count.index].arn
}

data "aws_iam_policy" "amazon_efs_csi_driver_policy" {
  count = var.create ? 1 : 0
  name = "AmazonEFSCSIDriverPolicy"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

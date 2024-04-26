output "cloud9_url" {
  value = "https://${data.aws_region.current.name}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.eks_cloud9_ec2[0].id}"
}

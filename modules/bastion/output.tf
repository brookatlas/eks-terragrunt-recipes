output "bastion_role_arn" {
  value = aws_iam_role.bastion_ec2_role[0].arn
}

output "bastion_security_group_id" {
    value = aws_security_group.eks_bastion_security_group[0].id
}
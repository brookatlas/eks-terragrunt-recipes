resource "aws_security_group_rule" "eks_cluster_allow_inbound_from_bastion" {
  count = var.create ? 1 : 0
  security_group_id = var.cluster_security_group_id
  protocol = "TCP"
  source_security_group_id = aws_security_group.bastion-sg[count.index].id
  type = "ingress"
  from_port = 443
  to_port = 443
}
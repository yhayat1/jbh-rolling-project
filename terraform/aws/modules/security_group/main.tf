resource "aws_security_group" "allow_ssh_tcp_5001" {
  name        = "yossih-builder-sg"
  description = "Terraform provisioned SG for builder EC2 instance"
  vpc_id      = data.aws_vpc.vpc_id.id

  tags = {
    Name = "yossih-builder-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tcp_5001.id
  cidr_ipv4         = var.allowed_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_5001_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tcp_5001.id
  cidr_ipv4         = var.allowed_cidr
  from_port         = 5001
  ip_protocol       = "tcp"
  to_port           = 5001
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tcp_5001.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

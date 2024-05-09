resource "aws_security_group" "sec-grp" {
  name = "sec-grp-${count.index}"
  vpc_id = var.vpc_ids[count.index]
  count = length(var.vpc_ids)
  tags = {Name = "sec-grp-${count.index}"}
}

resource "aws_security_group_rule" "ingress_http" {
  security_group_id = aws_security_group.sec-grp[count.index].id
  count = length(aws_security_group.sec-grp)
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  type = ingress
}

resource "aws_security_group_rule" "ingress_https" {
  security_group_id = aws_security_group.sec-grp[count.index].id
  count = length(aws_security_group.sec-grp)
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  type = ingress
}

resource "aws_security_group_rule" "ingress_ssh" {
  security_group_id = aws_security_group.sec-grp[count.index].id
  count = length(aws_security_group.sec-grp)
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  type = ingress
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.sec-grp[count.index].id
  count = length(aws_security_group.sec-grp)
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  type = egress
}

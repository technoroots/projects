resource "aws_security_group" "tf-eks-master" {
  name   = join("-", [local.cluster_name, "master-sg"])
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  tags = {
    Name = join("-", [local.cluster_name, "master-sg"])
  }
}

resource "aws_security_group_rule" "cluster_ingress_22" {
  security_group_id = aws_security_group.tf-eks-master.id
  from_port         = 0
  to_port           = 0
  type              = "ingress"
  protocol          = -1
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "internal access to the cluster"
}

resource "aws_security_group_rule" "cluster_ingress_443" {
  security_group_id = aws_security_group.tf-eks-master.id
  from_port         = 443
  to_port           = 443
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "https port"
}


resource "aws_security_group_rule" "cluster_ingress_80" {
  security_group_id = aws_security_group.tf-eks-master.id
  from_port         = 80
  to_port           = 80
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "http port"
}

resource "aws_security_group_rule" "cluster_egress" {
  security_group_id = aws_security_group.tf-eks-master.id
  from_port         = 0
  to_port           = 0
  type              = "egress"
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "tf-eks-node" {
  name   = join("-", [local.cluster_name, "worker-sg"])
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  tags = {
    Name = join("-", [local.cluster_name, "worker-sg"])
  }
}

resource "aws_security_group_rule" "worker_ingress" {
  security_group_id = aws_security_group.tf-eks-node.id
  from_port         = 0
  to_port           = 0
  type              = "ingress"
  protocol          = -1
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "internal access to the cluster"
}

resource "aws_security_group_rule" "worker_egress" {
  security_group_id = aws_security_group.tf-eks-node.id
  from_port         = 0
  to_port           = 0
  type              = "egress"
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "prv-sg" {
  name        = "prv-sg"
  description = "Private SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "prv-sg"
  }
}

resource "aws_instance" "prv1" {
  ami                    = var.amis[var.aws_region]
  availability_zone      = "us-west-1a"
  instance_type          = "t2.small"
  key_name               = "ssh-key"
  vpc_security_group_ids = [aws_security_group.prv-sg.id]
  subnet_id              = aws_subnet.us-west-1a-private.id
  source_dest_check      = false

  tags = {
    Name = "Private Server"
  }
}


resource "aws_security_group" "pub-sg" {
  name        = "vpc_pub"
  description = "Public SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "pub-sg"
  }
}

resource "aws_instance" "pub1" {
  ami                         = var.amis[var.aws_region]
  availability_zone           = "us-west-1c"
  instance_type               = "t2.small"
  key_name                    = "ssh-key"
  vpc_security_group_ids      = [aws_security_group.pub-sg.id]
  subnet_id                   = aws_subnet.us-west-1c-public.id
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "Pub server"
  }
}


resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-aws-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    "Name" = "igw-1"
  }
}

#resource "aws_eip" "nat_eip" {
#  vpc = true
#  tags = {
#    Name = "nat-eip"
#  }
#}

resource "aws_eip" "default" {
  vpc = true
  tags = {
    Name = "nat-eip"
  }
}


resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id     = aws_subnet.us-west-1c-public.id
  depends_on    = [aws_internet_gateway.default]
}

resource "aws_subnet" "us-west-1a-private" {
  vpc_id = aws_vpc.default.id

  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-west-1a"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "us-west-1a-private" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.default.id
  }

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "us-west-1a-private" {
  subnet_id      = aws_subnet.us-west-1a-private.id
  route_table_id = aws_route_table.us-west-1a-private.id
}

resource "aws_subnet" "us-west-1c-public" {
  vpc_id = aws_vpc.default.id

  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-west-1c"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "us-west-1c-public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "us-west-1c-public" {
  subnet_id      = aws_subnet.us-west-1c-public.id
  route_table_id = aws_route_table.us-west-1c-public.id
}


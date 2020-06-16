# TODO too much? consider moving peering into its own module

variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "zones" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "region" {
  type = string
}


# Define the VPC itself
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name      = var.name
    terraform = "true"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}

# Build subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.zones, count.index)
  cidr_block              = element(var.public_subnets, count.index)

  tags = {
    Name = format(
      "pub-%s-%s-%s",
      var.name,
      element(var.zones, count.index),
      floor(count.index / length(var.zones)),
    )
    immutable_metadata = "{ \"purpose\": \"public-${var.name}\" }"
    terraform          = "true"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = element(var.zones, count.index)
  cidr_block              = element(var.private_subnets, count.index)

  tags = {
    Name = format(
      "priv-%s-%s-%s",
      var.name,
      element(var.zones, count.index),
      floor(count.index / length(var.zones)),
    )
    immutable_metadata = "{ \"purpose\": \"private-${var.name}\" }"
    terraform          = "true"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}


# Create gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "igw-${var.name}"
    terraform = "true"
  }
}

resource "aws_eip" "nat_eips" {
  count = length(var.zones)
  vpc   = "true"
}

resource "aws_nat_gateway" "nats" {
  count         = length(var.zones)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat_eips.*.id, count.index)
  depends_on    = [aws_internet_gateway.igw]
}

# Create route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "rt-${var.name}-public"
    terraform = "true"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.zones)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format(
      "rt-%s-private-%s-%s",
      var.name,
      element(var.zones, count.index),
      floor(count.index / length(var.zones)),
    )
    terraform = "true"
  }
}


# Associate gateways to route tables as default routes
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.public.id
}

resource "aws_route" "private" {
  count                  = length(var.zones)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nats.*.id, count.index)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
}

# Associate subnets to route tables
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
}

resource "aws_vpc_endpoint" "s3-vpc-endpoint" {
  vpc_id          = aws_vpc.vpc.id
  service_name    = format("com.amazonaws.%s.s3", var.region)
  route_table_ids = flatten([aws_route_table.public.*.id, aws_route_table.private.*.id])
}

data "aws_iam_policy_document" "flow_log_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["vpc-flow-logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "flow_log_policy" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogGroups", "logs:DescribeLogStreams"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy" "flow_log_policy" {
  name   = "${var.name}_flow_log_policy"
  role   = aws_iam_role.flow_log.id
  policy = data.aws_iam_policy_document.flow_log_policy.json
}

resource "aws_iam_role" "flow_log" {
  name               = "${var.name}_vpc_flow_logs"
  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_role_policy.json
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = "${var.name}_flow_log_group"
}

resource "aws_flow_log" "flow_log" {
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  iam_role_arn    = aws_iam_role.flow_log.arn
  vpc_id          = aws_vpc.vpc.id
  traffic_type    = "ALL"
}

# Outputs needed by other resources
output "id" {
  value = aws_vpc.vpc.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "private_route_tables" {
  value = aws_route_table.private.*.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "public_route_table" {
  value = aws_route_table.public.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "nat_eips" {
  value = aws_eip.nat_eips.*.public_ip
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}


# outputs

output "private_route_tables" {
  value = {
    "${module.k8s_usw2_vpc.id}"     = module.k8s_usw2_vpc.private_route_tables
  }
}

output "private_subnets" {
  value = {
    "${module.k8s_usw2_vpc.id}"     = module.k8s_usw2_vpc.private_subnets
  }
}

output "public_route_tables" {
  value = {
    "${module.k8s_usw2_vpc.id}"     = module.k8s_usw2_vpc.public_route_table
  }
}

output "public_subnets" {
  value = {
    "${module.k8s_usw2_vpc.id}"     = module.k8s_usw2_vpc.public_subnets
  }
}

output "vpcs" {
  value = {
    "hub"     = module.k8s_usw2_vpc.id
  }
}

output "vpc_cidrs" {
  value = {
    "hub"     = var.vpc_cidr_map["hub"]
  }
}

output "vpc_cidr_list" {
  value = var.vpc_cidr_list
}

output "vpc_nat_eips" {
  value = {
    "hub"     = module.k8s_usw2_vpc.nat_eips
  }
}

output "vpc_igw_ids" {
  value = {
    "hub"     = module.k8s_usw2_vpc.igw_id
  }
}

output "hub_subnet_cidrs" {
  value = var.hub_vpc
}

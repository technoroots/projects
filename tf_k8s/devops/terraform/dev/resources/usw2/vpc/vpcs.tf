# start

module "k8s_usw2_vpc" {
   source = "../../../../module_terraform/vpc_default"

  name       = "k8s-usw2"
  cidr_block = var.vpc_cidr_map["hub"]
  region     = var.region
  zones      = var.region_zones

  private_subnets = var.hub_vpc["private_subnets"]
  public_subnets  = var.hub_vpc["public_subnets"]

}

# end

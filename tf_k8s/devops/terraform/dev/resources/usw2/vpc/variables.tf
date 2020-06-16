#

variable "region" {
  default = "us-west-2"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "region_zones" {
  type    = list(string)
  default = ["us-west-1a", "us-west-1c"]
}

variable "vpc_cidr_list" {
  type    = list(string)
  default = ["10.150.0.0"]
}

variable "vpc_cidr_map" {
  type = map(string)

  default = {
    hub     = "10.150.0.0/16"
  }
}

variable "hub_vpc" {
  type = map(list(string))

  default = {
    public_subnets  = ["10.150.255.0/24", "10.150.254.0/24"]
    private_subnets = ["10.150.12.0/22", "10.150.16.0/22"]
  }
}

# end

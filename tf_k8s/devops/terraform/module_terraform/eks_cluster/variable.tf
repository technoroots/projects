variable "account" {
  type    = string
}

#variable "aws_profile" {
#  type    = "string"
#}

#variable "account_ids" {
#  type = "map"
#
#}

#############################

variable "region" {
  type    = string
}

variable "region_code" {
  type    = string
}


variable "eks_cluster_name" {
  type    = string
}

variable "vpc_id" {
  type    = string
}

variable "vpc_zone_identifier" {
  type  = list
}
variable "subnet_ids" {
  type  = list
}

variable "worker_nodes" {
  type  = list
  default = []
}
variable "worker_names" {
  type  = list
}
variable "user_access" {
  type = list(map(string))
}


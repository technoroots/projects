###################

variable "account" {
  default = "dev"
}


#############################

variable "region" {
  default = "us-west-2"
}

variable "region_code" {
  default = "usw2"
}
variable "eks_cluster_name" {
  type    = string
  default = "eks-app"
}

variable "eks_arn" {
  default = "arn:aws:iam::*******:policy/eks-cluster-autoscaling-policy"
}

locals {
  
  worker_names = [ "app", "db"]
  worker_nodes = list(
    map("name", "app",
      "ami_id", "ami-0c13bb9cbfd007e56",
      "instance_type", "t2.micro",
      "min_size", 0,
      "max_size", 2,
      "desired_size", 2,
      "volume_type", "gp2",
      "volume_size", "10",
      "delete_on_termination", "true",
      "key_name", "dev-master",
    ),
    map("name", "client",
      "instance_type", "t2.micro",
      "ami_id", "ami-0c13bb9cbfd007e56",
      "min_size", 0,
      "max_size", 2,
      "desired_size", 1,
      "volume_type", "gp2",
      "volume_size", "10",
      "delete_on_termination", "true",
      "key_name", "dev-master",
    ),
  )

user_access  = [
 {
  name = "test@email.com"
  arn  = "arn:aws:iam::*******:user/test@email.com"
  group = "system:masters"
 },
]
}

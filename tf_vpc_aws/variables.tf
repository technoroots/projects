variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_key_path" {
}

variable "ssh-key" {
}

variable "aws_key_name" {
  type = "string"
  default = "ssh-key"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-west-1"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    us-west-1 = "ami-0dbf5ea29a7fc7e05" # ubuntu 16.04 LTS
  }
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "192.168.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "192.168.2.0/24"
}


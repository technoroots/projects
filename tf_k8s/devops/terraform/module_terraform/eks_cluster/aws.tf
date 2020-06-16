# Setup data source to get amazon-provided AMI for EKS nodes
locals {

cluster_name = join("-", [ var.eks_cluster_name, var.region_code ])

}
provider "aws" {
  region              = var.region
  version             = "~> 2.7"
}
provider "kubernetes" {
  host                   = aws_eks_cluster.tf_eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.tf_eks.certificate_authority[0].data)
  token                  = data.external.aws_iam_authenticator.result.token
  load_config_file       = false
  version                = "~> 1.5"
}

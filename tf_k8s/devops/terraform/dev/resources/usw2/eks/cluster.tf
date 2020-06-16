module "eks_cluster" {
  source              = "../../../../module_terraform/eks_cluster"
  eks_cluster_name    = var.eks_cluster_name
  account             = var.account
  region              = var.region
  region_code         = var.region_code
  vpc_zone_identifier = data.aws_subnet.private.*.id
  subnet_ids          = data.aws_subnet.private.*.id
  vpc_id              = data.aws_vpc.hub.id
  worker_names        = local.worker_names
  worker_nodes        = local.worker_nodes
  user_access         = local.user_access
}

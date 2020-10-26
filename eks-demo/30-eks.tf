# eks

module "eks" {
  source  = "nalbam/eks/aws"
  version = "0.12.70"

  region = var.region

  name = var.name

  kubernetes_version = var.kubernetes_version

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  cluster_log_types             = var.cluster_log_types
  cluster_log_retention_in_days = var.cluster_log_retention_in_days

  allow_ip_address = var.allow_ip_address

  workers = local.workers

  roles = local.roles
  users = local.users

  irsa_enabled = var.irsa_enabled
  efs_enabled  = var.efs_enabled

  tags = {}
}

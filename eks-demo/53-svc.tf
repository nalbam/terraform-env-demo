# svc

module "svc" {
  source  = "nalbam/eks-worker/aws"
  version = "0.12.39"

  region = var.region

  name = format("%s-svc", module.eks.name)

  cluster_name = module.eks.name

  worker_role_name = module.eks.worker_role_name

  worker_security_group_ids = [module.eks.worker_security_group_id]

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  subnet_azs = data.terraform_remote_state.vpc.outputs.private_subnet_azs

  allow_ip_address = var.allow_ip_address

  launch_configuration_enable = var.launch_configuration_enable
  launch_template_enable      = var.launch_template_enable

  launch_each_subnet          = var.launch_each_subnet
  associate_public_ip_address = var.associate_public_ip_address

  # autoscale_enable = true

  instance_type   = var.instance_type
  mixed_instances = var.mixed_instances

  volume_type = var.volume_type
  volume_size = var.volume_size

  min = var.min
  max = var.max

  on_demand_base = var.on_demand_base
  on_demand_rate = var.on_demand_rate

  key_name = var.key_name
  key_path = var.key_path

  tags = {
    "node.kubernetes.io/role" = "svc"
  }

  node_labels = "node-role=svc,node.kubernetes.io/role=svc"
  # node_taints = ""
}

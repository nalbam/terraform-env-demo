# output

output "region" {
  value = var.region
}

output "cluster_name" {
  value = module.eks.name
}

output "eks_version" {
  value = module.eks.version
}

output "eks_endpoint" {
  value = module.eks.endpoint
}

# output "eks_certificate_authority" {
#   value = module.eks.certificate_authority
# }

# output "eks_token" {
#   value = module.eks.token
# }

output "eks_oidc_issuer" {
  value = module.eks.oidc_issuer
}

output "eks_oidc_arn" {
  value = module.eks.oidc_arn
}

output "vpc_config" {
  value = module.eks.vpc_config
}

# output "vpc_id" {
#   value = module.eks.vpc_id
# }

# output "subnet_ids" {
#   value = module.eks.subnet_ids
# }

output "efs_id" {
  value = module.eks.efs_id
}

# output "cluster_role_arn" {
#   value = module.eks.cluster_role_arn
# }

output "cluster_role_name" {
  value = module.eks.cluster_role_name
}

output "cluster_security_groups" {
  value = module.eks.cluster_security_groups
}

# output "worker_ami_id" {
#   value = module.eks.worker_ami_id
# }

# output "worker_iam_role_arn" {
#   value = module.eks.iam_role_arn
# }

output "worker_role_name" {
  value = module.eks.worker_role_name
}

output "worker_security_groups" {
  value = module.eks.worker_security_groups
}

# output "update_kubeconfig" {
#   value = "aws eks update-kubeconfig --name ${module.eks.name} --alias ${module.eks.name}"
# }

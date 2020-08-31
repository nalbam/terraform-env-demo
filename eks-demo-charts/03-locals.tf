# locals

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  root_domain = var.root_domain != "" ? var.root_domain : data.terraform_remote_state.eks.outputs.root_domain
  base_domain = var.base_domain != "" ? var.base_domain : data.terraform_remote_state.eks.outputs.base_domain

  acm_arn = var.acm_arn != "" ? var.acm_arn : data.terraform_remote_state.eks.outputs.acm_arn

  hostname = "*.${local.base_domain}"

  efs_id = var.efs_id != "" ? var.efs_id : data.terraform_remote_state.eks.outputs.efs_id

  storage_class = local.efs_id == "" ? "default" : "efs"

  admin_username = data.aws_ssm_parameter.admin_username.value
  admin_password = data.aws_ssm_parameter.admin_password.value

  slack_token =  data.aws_ssm_parameter.slack_token.value
  slack_url   = format("%s%s", "https://hooks.slack.com/services/", local.slack_token)
}

locals {
  domain = {
    jenkins     = var.jenkins_enabled ? "jenkins.${local.base_domain}" : ""
    chartmuseum = var.chartmuseum_enabled ? "chartmuseum.${local.base_domain}" : ""
    registry    = var.registry_enabled ? "registry.${local.base_domain}" : ""
    harbor      = var.harbor_enabled ? "harbor-core.${local.base_domain}" : ""
    archiva     = var.archiva_enabled ? "archiva.${local.base_domain}" : ""
    nexus       = var.nexus_enabled ? "nexus.${local.base_domain}" : ""
    sonarqube   = var.sonarqube_enabled ? "sonarqube.${local.base_domain}" : ""
  }
}

locals {
  tags = {
    "KubernetesCluster"                         = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# resource "local_file" "kube-config" {
#   content  = data.template_file.kube-config.rendered
#   filename = "${path.module}/.kube/config"
# }

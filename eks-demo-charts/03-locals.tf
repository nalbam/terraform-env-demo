# locals

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  vpc_id = var.vpc_id != "" ? var.vpc_id : data.terraform_remote_state.eks.outputs.vpc_config[0].vpc_id

  efs_id = var.efs_id != "" ? var.efs_id : data.terraform_remote_state.eks.outputs.efs_id

  acm_arn = var.acm_arn != "" ? var.acm_arn : data.terraform_remote_state.eks.outputs.acm_arn

  domain_name = var.domain_name != "" ? var.domain_name : data.terraform_remote_state.eks.outputs.domain_name

  domain_public   = local.domain_name # format("pub.%s", local.domain_name)
  domain_internal = format("in.%s", local.domain_name)

  hostname_public   = format("*.%s", local.domain_public)
  hostname_internal = format("*.%s", local.domain_internal)

  storage_class = local.efs_id == "" ? "default" : "efs"

  admin_username = data.aws_ssm_parameter.admin_username.value
  admin_password = data.aws_ssm_parameter.admin_password.value

  slack_token = data.aws_ssm_parameter.slack_token.value
  slack_url   = format("%s%s", "https://hooks.slack.com/services/", local.slack_token)
}

locals {
  domain = {
    jenkins     = var.jenkins_enabled ? "jenkins.${local.domain_public}" : ""
    chartmuseum = var.chartmuseum_enabled ? "chartmuseum.${local.domain_public}" : ""
    registry    = var.registry_enabled ? "registry.${local.domain_public}" : ""
    harbor      = var.harbor_enabled ? "harbor-core.${local.domain_public}" : ""
    archiva     = var.archiva_enabled ? "archiva.${local.domain_public}" : ""
    nexus       = var.nexus_enabled ? "nexus.${local.domain_public}" : ""
    sonarqube   = var.sonarqube_enabled ? "sonarqube.${local.domain_public}" : ""
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

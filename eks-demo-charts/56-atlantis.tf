# atlantis

locals {
  atlantis_domain = format("atlantis.%s", local.domain_public)
}

resource "helm_release" "atlantis" {
  count = var.atlantis_enabled ? 1 : 0

  repository = "https://charts.helm.sh/stable"
  chart      = "atlantis"
  version    = var.stable_atlantis

  namespace = "atlantis"
  name      = "atlantis"

  values = [
    file("./values/atlantis/atlantis.yaml")
  ]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_atlantis.arn
  }

  set {
    name  = "github.user"
    value = data.aws_ssm_parameter.github_user.value
  }

  set {
    name  = "github.token"
    value = data.aws_ssm_parameter.github_token.value
  }

  set {
    name  = "github.secret"
    value = data.aws_ssm_parameter.github_secret.value
  }

  create_namespace = true
}

output "atlantis_webhook_url" {
  value = var.atlantis_enabled ? format("https://atlantis.%s/events", local.atlantis_domain) : ""
}

output "atlantis_webhook_secret" {
  value = var.atlantis_enabled ? data.aws_ssm_parameter.github_secret.value : ""
}

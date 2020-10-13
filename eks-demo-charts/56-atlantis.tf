# atlantis

locals {
  atlantis_url = format("https://atlantis.%s", local.base_domain)
}

resource "helm_release" "atlantis" {
  count = var.atlantis_enabled ? 1 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
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
  value = var.atlantis_enabled ? format("https://%s/events", local.atlantis_url) : ""
}

output "atlantis_webhook_secret" {
  value = var.atlantis_enabled ? data.aws_ssm_parameter.github_secret.value : ""
}

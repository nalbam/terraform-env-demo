# atlantis

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
    name  = "github.user"
    value = data.aws_ssm_parameter.github_user.value
  }

  set {
    name  = "github.token"
    value = data.aws_ssm_parameter.github_token.value
  }

  set {
    name  = "github.secret"
    value = join("", random_id.webhook.*.hex)
  }

  create_namespace = true
}

resource "random_id" "webhook" {
  byte_length = "64"
}

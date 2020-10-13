# grafana

resource "helm_release" "grafana" {
  count = var.grafana_enabled ? 1 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "grafana"
  version    = var.stable_grafana

  namespace = "monitor"
  name      = "grafana"

  values = [
    file("./values/monitor/grafana.yaml"),
    var.sso == "google" ? local.grafana_auth_google : "",
    var.sso == "github" ? local.grafana_auth_github : "",
  ]

  set {
    name  = "adminUser"
    value = local.admin_username
  }

  set {
    name  = "adminPassword"
    value = local.admin_password
  }

  set {
    name  = "persistence.storageClassName"
    value = local.storage_class
  }

  set {
    name  = "grafana\\.ini.auth\\.generic_oauth.enabled"
    value = var.sso == "keycloak" ? true : false
  }

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.efs-provisioner,
  ]
}

locals {
  grafana_auth_google = yamlencode(
    {
      "grafana.ini" = {
        "auth.google" = {
          enabled         = true
          client_id       = data.aws_ssm_parameter.google_client_id.value
          client_secret   = data.aws_ssm_parameter.google_client_secret.value
          allowed_domains = var.sso_allowed_domains
        }
      }
    }
  )

  grafana_auth_github = yamlencode(
    {
      "grafana.ini" = {
        "auth.github" = {
          enabled               = true
          client_id             = data.aws_ssm_parameter.github_client_id.value
          client_secret         = data.aws_ssm_parameter.github_client_secret.value
          allowed_organizations = var.sso_allowed_organizations
          team_ids              = var.sso_team_ids
        }
      }
    }
  )
}

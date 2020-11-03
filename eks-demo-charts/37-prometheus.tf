# prometheus

resource "helm_release" "prometheus-operator" {
  count = var.prometheus_enabled ? 1 : 0

  repository = "https://charts.helm.sh/stable"
  chart      = "prometheus-operator"
  version    = var.stable_prometheus_operator

  namespace = "monitor"
  name      = "prometheus-operator"

  values = [
    file("./values/monitor/prometheus-operator.yaml")
  ]

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = local.storage_class
  }

  set {
    name  = "alertmanager.config.global.slack_api_url"
    value = local.slack_url
  }

  create_namespace = true

  depends_on = [
    helm_release.efs-provisioner,
  ]
}

resource "helm_release" "prometheus-alert-rules" {
  count = var.prometheus_enabled ? 1 : 0

  repository = "https://charts.helm.sh/incubator"
  chart      = "raw"

  namespace = "monitor"
  name      = "prometheus-alert-rules"

  values = [
    file("./values/monitor/prometheus-alert-rules.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

resource "helm_release" "prometheus-adapter" {
  count = var.prometheus_enabled ? 1 : 0

  repository = "https://charts.helm.sh/stable"
  chart      = "prometheus-adapter"
  version    = var.stable_prometheus_adapter

  namespace = "monitor"
  name      = "prometheus-adapter"

  values = [
    file("./values/monitor/prometheus-adapter.yaml")
  ]

  wait = false

  create_namespace = true
}

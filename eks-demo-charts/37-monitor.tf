# monitor

resource "helm_release" "grafana" {
  count = var.grafana_enabled ? 1 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "grafana"
  version    = var.stable_grafana

  namespace = "monitor"
  name      = "grafana"

  values = [
    file("./values/monitor/grafana.yaml")
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

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.efs-provisioner,
  ]
}

resource "helm_release" "prometheus-operator" {
  count = var.prometheus_enabled ? 1 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
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

  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
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

  repository = "https://kubernetes-charts.storage.googleapis.com"
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

resource "helm_release" "datadog" {
  count = var.datadog_enabled ? 1 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "datadog"
  version    = var.stable_datadog

  namespace = "monitor"
  name      = "datadog"

  values = [
    file("./values/monitor/datadog.yaml")
  ]

  set {
    name  = "datadog.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "datadog.apiKey"
    value = data.aws_ssm_parameter.datadog_api_key.value
  }

  set {
    name  = "datadog.appKey"
    value = data.aws_ssm_parameter.datadog_app_key.value
  }

  wait = false

  create_namespace = true
}

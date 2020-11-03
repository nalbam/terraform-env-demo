# datadog

resource "helm_release" "datadog" {
  count = var.datadog_enabled ? 1 : 0

  repository = "https://charts.helm.sh/stable"
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

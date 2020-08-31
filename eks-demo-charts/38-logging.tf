# logging

variable "fluentd_enabled" {
  default = true
}

resource "helm_release" "fluentd-logzio" {
  count = var.fluentd_enabled ? data.aws_ssm_parameter.logzio_token.value != "" ? 1 : 0 : 0

  repository = "https://opspresso.github.io/helm-charts/"
  chart      = "fluentd-logzio"
  version    = var.opspresso_fluentd_logzio

  namespace = "logging"
  name      = "fluentd-logzio"

  values = [
    file("./values/logging/fluentd-logzio.yaml")
  ]

  set {
    name  = "logzio.token"
    value = data.aws_ssm_parameter.logzio_token.value
  }

  wait = false

  create_namespace = true
}

resource "helm_release" "fluentd-elasticsearch" {
  count = var.fluentd_enabled ? data.aws_ssm_parameter.logzio_token.value == "" ? 1 : 0 : 0

  repository = "https://kiwigrid.github.io"
  chart      = "fluentd-elasticsearch"
  version    = var.kiwigrid_fluentd_elasticsearch

  namespace = "logging"
  name      = "fluentd-elasticsearch"

  values = [
    file("./values/logging/fluentd-elasticsearch.yaml")
  ]

  wait = false

  create_namespace = true
}

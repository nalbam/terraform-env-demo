# argo-events

resource "helm_release" "argo-events" {
  count = var.argo_events_enabled ? 1 : 0

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-events"
  version    = var.argo_argo_events

  namespace = "argo-events"
  name      = "argo-events"

  values = [
    file("./values/argo/argo-events.yaml")
  ]

  # wait = false

  create_namespace = true
}

resource "helm_release" "argo-events-webhook" {
  count = var.argo_enabled ? var.argo_events_enabled ? 1 : 0 : 0

  repository = "https://charts.helm.sh/incubator"
  chart      = "raw"

  namespace = "argo-events"
  name      = "argo-events-webhook"

  values = [
    file("./values/argo/argo-events-webhook.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.argo,
    helm_release.argo-events,
  ]
}

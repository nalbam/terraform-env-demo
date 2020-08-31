# argo-cd & argo-rollouts

resource "helm_release" "argo-rollouts" {
  count = var.argo_cd_enabled ? 1 : 0

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-rollouts"
  version    = var.argo_argo_rollouts

  namespace = "argo-rollouts"
  name      = "argo-rollouts"

  values = [
    file("./values/argo/argo-rollouts.yaml")
  ]

  create_namespace = true
}

resource "helm_release" "argo-cd" {
  count = var.argo_cd_enabled ? 1 : 0

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_argo_cd

  namespace = "argo-cd"
  name      = "argocd"

  values = [
    file("./values/argo/argo-cd.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

resource "helm_release" "argo-cd-apps" {
  count = var.argo_cd_enabled ? var.argo_cd_apps_enabled ? 1 : 0 : 0

  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "raw"

  namespace = "argo-cd"
  name      = "argocd-apps"

  values = [
    file("./values/argo/argo-cd-apps.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.argo-cd,
    helm_release.argo-rollouts,
  ]
}

# istio

# istioctl manifest apply --set profile=demo --set values.kiali.dashboard.auth.strategy=anonymous
# istioctl manifest generate --set profile=demo | kubectl delete -f -

resource "helm_release" "kiali-gatekeeper" {
  count = var.keycloak_enabled ? var.kiali_gatekeeper ? 1 : 0 : 0

  repository = "https://gabibbo97.github.io/charts/"
  chart      = "keycloak-gatekeeper"
  version    = var.gabibbo97_keycloak_gatekeeper

  namespace = "istio-system"
  name      = "kiali-gatekeeper"

  values = [
    file("./values/istio/kiali-gatekeeper.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.keycloak,
  ]
}

resource "helm_release" "tracing-gatekeeper" {
  count = var.keycloak_enabled ? var.tracing_gatekeeper ? 1 : 0 : 0

  repository = "https://gabibbo97.github.io/charts/"
  chart      = "keycloak-gatekeeper"
  version    = var.gabibbo97_keycloak_gatekeeper

  namespace = "istio-system"
  name      = "tracing-gatekeeper"

  values = [
    file("./values/istio/tracing-gatekeeper.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.keycloak,
  ]
}

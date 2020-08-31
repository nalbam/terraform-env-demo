# keycloak

resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

resource "kubernetes_secret" "keycloak-admin" {
  metadata {
    namespace = "keycloak"
    name      = "keycloak-admin"
  }

  type = "Opaque"

  data = {
    "username" = local.admin_username
    "password" = local.admin_password
  }

  depends_on = [
    kubernetes_namespace.keycloak,
  ]
}

resource "kubernetes_secret" "keycloak-realm" {
  metadata {
    namespace = "keycloak"
    name      = "keycloak-realm"
  }

  type = "Opaque"

  data = {
    "demo.json" = file("${path.module}/template/keycloak-realm.json")
  }

  depends_on = [
    kubernetes_namespace.keycloak,
  ]
}

resource "helm_release" "keycloak" {
  repository = "https://codecentric.github.io/helm-charts"
  chart      = "keycloak"
  version    = "8.3.0" # var.codecentric_keycloak

  namespace = "keycloak"
  name      = "keycloak"

  values = [
    file("./values/keycloak/keycloak-v8.yaml")
  ]

  set {
    name  = "keycloak.username"
    value = local.admin_username
  }

  set {
    name  = "keycloak.password"
    value = local.admin_password
  }

  set {
    name  = "postgresql.persistence.storageClass"
    value = local.storage_class
  }

  depends_on = [
    kubernetes_secret.keycloak-admin,
    kubernetes_secret.keycloak-realm,
    helm_release.efs-provisioner,
    helm_release.prometheus-operator,
  ]
}

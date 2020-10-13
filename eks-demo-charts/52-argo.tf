# argo

variable "argo_gatekeeper" {
  default = true
}

resource "helm_release" "argo" {
  count = var.argo_enabled ? 1 : 0

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo"
  version    = var.argo_argo

  namespace = "argo"
  name      = "argo"

  values = [
    file("./values/argo/argo.yaml")
  ]

  # set {
  #   name  = "controller.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
  #   value = module.irsa_asg.arn
  # }

  # set {
  #   name  = "server.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
  #   value = module.irsa_asg.arn
  # }

  set {
    name  = "server.ingress.enabled"
    value = var.argo_gatekeeper ? false : true
  }

  set {
    name  = "artifactRepository.s3.bucket"
    value = "${var.cluster_name}-argo-${local.account_id}"
  }

  set {
    name  = "artifactRepository.s3.region"
    value = var.region
  }

  create_namespace = true

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

resource "helm_release" "argo-gatekeeper" {
  count = var.argo_enabled ? var.keycloak_enabled ? var.argo_gatekeeper ? 1 : 0 : 0 : 0

  repository = "https://gabibbo97.github.io/charts/"
  chart      = "keycloak-gatekeeper"
  version    = var.gabibbo97_keycloak_gatekeeper

  namespace = "argo"
  name      = "argo-gatekeeper"

  values = [
    file("./values/argo/argo-gatekeeper.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.argo,
    helm_release.keycloak,
  ]
}

resource "aws_s3_bucket" "argo" {
  count = var.argo_enabled ? 1 : 0

  bucket = "${var.cluster_name}-argo-${local.account_id}"

  acl = "private"

  force_destroy = true

  tags = merge(
    {
      "Name" = "${var.cluster_name}-argo-${local.account_id}"
    },
    local.tags,
  )
}

resource "kubernetes_cluster_role_binding" "admin-argo-default" {
  count = var.argo_enabled ? 1 : 0

  metadata {
    name = "admin:argo:default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  subject {
    kind      = "ServiceAccount"
    namespace = "argo"
    name      = "default"
  }

  depends_on = [
    helm_release.argo,
  ]
}

resource "kubernetes_cluster_role_binding" "edit-default-default" {
  count = var.argo_enabled ? 1 : 0

  metadata {
    name = "edit:default:default"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "ServiceAccount"
    namespace = "default"
    name      = "default"
  }
}

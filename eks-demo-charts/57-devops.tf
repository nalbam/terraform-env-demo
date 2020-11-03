# devops

resource "kubernetes_namespace" "devops" {
  count = var.cluster_role == "devops" ? 1 : 0

  metadata {
    name = "devops"
    labels = {
      name = "devops"
    }
  }
}

resource "aws_s3_bucket" "chartmuseum" {
  count = var.cluster_role == "devops" ? var.chartmuseum_enabled ? 1 : 0 : 0

  bucket = "${var.cluster_name}-chartmuseum-${local.account_id}"

  acl = "private"

  force_destroy = true

  tags = merge(
    {
      "Name" = "${var.cluster_name}-chartmuseum-${local.account_id}"
    },
    local.tags,
  )
}

resource "helm_release" "chartmuseum" {
  count = var.cluster_role == "devops" ? var.chartmuseum_enabled ? 1 : 0 : 0

  repository = "https://charts.helm.sh/stable"
  chart      = "chartmuseum"
  version    = var.stable_chartmuseum

  namespace = "devops"
  name      = "chartmuseum"

  values = [
    file("./values/devops/chartmuseum.yaml")
  ]

  set {
    name  = "env.open.STORAGE_AMAZON_BUCKET"
    value = "${var.cluster_name}-chartmuseum-${local.account_id}"
  }

  set {
    name  = "env.open.STORAGE_AMAZON_REGION"
    value = var.region
  }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    aws_s3_bucket.chartmuseum,
    helm_release.efs-provisioner,
  ]
}

resource "aws_s3_bucket" "docker-registry" {
  count = var.cluster_role == "devops" ? var.registry_enabled ? 1 : 0 : 0

  bucket = "${var.cluster_name}-registry-${local.account_id}"

  acl = "private"

  force_destroy = true

  tags = merge(
    {
      "Name" = "${var.cluster_name}-registry-${local.account_id}"
    },
    local.tags,
  )
}

resource "helm_release" "docker-registry" {
  count = var.cluster_role == "devops" ? var.registry_enabled ? 1 : 0 : 0

  repository = "https://charts.helm.sh/stable"
  chart      = "docker-registry"
  version    = var.stable_docker_registry

  namespace = "devops"
  name      = "docker-registry"

  values = [
    file("./values/devops/docker-registry.yaml")
  ]

  set {
    name  = "s3.bucket"
    value = "${var.cluster_name}-registry-${local.account_id}"
  }

  set {
    name  = "s3.region"
    value = var.region
  }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    aws_s3_bucket.docker-registry,
    helm_release.efs-provisioner,
  ]
}

resource "helm_release" "archiva" {
  count = var.cluster_role == "devops" ? var.archiva_enabled ? 1 : 0 : 0

  repository = "https://xetus-oss.github.io/helm-charts/"
  chart      = "xetusoss-archiva"
  version    = "0.1.8"

  namespace = "devops"
  name      = "archiva"

  values = [
    file("./values/devops/archiva.yaml")
  ]

  set {
    name  = "persistence.storageClass"
    value = local.storage_class
  }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    helm_release.efs-provisioner,
  ]
}

resource "helm_release" "sonarqube" {
  count = var.cluster_role == "devops" ? var.sonarqube_enabled ? 1 : 0 : 0

  repository = "https://oteemo.github.io/charts"
  chart      = "sonarqube"
  version    = var.oteemo_sonarqube

  namespace = "devops"
  name      = "sonarqube"

  values = [
    file("./values/devops/sonarqube.yaml")
  ]

  set {
    name  = "persistence.storageClass"
    value = local.storage_class
  }

  set {
    name  = "postgresql.persistence.storageClass"
    value = local.storage_class
  }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    helm_release.efs-provisioner,
  ]
}

resource "helm_release" "sonatype-nexus" {
  count = var.cluster_role == "devops" ? var.nexus_enabled ? 1 : 0 : 0

  repository = "https://oteemo.github.io/charts"
  chart      = "sonatype-nexus"
  version    = var.oteemo_sonatype_nexus

  namespace = "devops"
  name      = "sonatype-nexus"

  values = [
    file("./values/devops/sonatype-nexus.yaml")
  ]

  set {
    name  = "persistence.storageClass"
    value = local.storage_class
  }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    helm_release.efs-provisioner,
  ]
}

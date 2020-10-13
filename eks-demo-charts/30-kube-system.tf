# kube-system

resource "helm_release" "cluster-autoscaler" {
  # repository = "https://kubernetes.github.io/autoscaler"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "cluster-autoscaler"
  version    = var.stable_cluster_autoscaler

  namespace = "kube-system"
  name      = "cluster-autoscaler"

  values = [
    file("./values/kube-system/cluster-autoscaler.yaml")
  ]

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_cluster_autoscaler.arn
  }

  wait = false

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

resource "helm_release" "efs-provisioner" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "efs-provisioner"
  version    = var.stable_efs_provisioner

  namespace = "kube-system"
  name      = "efs-provisioner"

  values = [
    file("./values/kube-system/efs-provisioner.yaml")
  ]

  set {
    name  = "efsProvisioner.awsRegion"
    value = var.region
  }

  set {
    name  = "efsProvisioner.efsFileSystemId"
    value = local.efs_id
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_efs_provisioner.arn
  }
}

resource "helm_release" "k8s-spot-termination-handler" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "k8s-spot-termination-handler"
  version    = var.stable_k8s_spot_termination_handler

  namespace = "kube-system"
  name      = "k8s-spot-termination-handler"

  values = [
    file("./values/kube-system/k8s-spot-termination-handler.yaml")
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_k8s_spot_termination_handler.arn
  }

  set {
    name  = "slackUrl"
    value = local.slack_url
  }

  wait = false
}

resource "helm_release" "metrics-server" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "metrics-server"
  version    = var.stable_metrics_server

  namespace = "kube-system"
  name      = "metrics-server"

  values = [
    file("./values/kube-system/metrics-server.yaml")
  ]

  wait = false
}

# resource "helm_release" "external-secrets" {
#   repository = "https://godaddy.github.io/kubernetes-external-secrets/"
#   chart      = "kubernetes-external-secrets"
#   version    = var.external_secrets_kubernetes_external_secrets

#   namespace = "kube-system"
#   name      = "external-secrets"

#   values = [
#     file("./values/kube-system/external-secrets.yaml")
#   ]

#   set {
#     name  = "env.AWS_REGION"
#     value = var.region
#   }

#   set {
#     name  = "env.AWS_DEFAULT_REGION"
#     value = var.region
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = module.irsa_external_secrets.arn
#   }

#   wait = false
# }

# resource "helm_release" "kube-state-metrics" {
#   repository = "https://kubernetes-charts.storage.googleapis.com"
#   chart      = "kube-state-metrics"
#   version    = var.stable_kube_state_metrics

#   namespace = "kube-system"
#   name      = "kube-state-metrics"

#   values = [
#     file("./values/kube-system/kube-state-metrics.yaml")
#   ]

#   wait = false
# }

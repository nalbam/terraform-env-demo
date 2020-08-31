# default

resource "helm_release" "cluster-overprovisioner" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "cluster-overprovisioner"
  version    = var.stable_cluster_overprovisioner

  namespace = "default"
  name      = "cluster-overprovisioner"

  values = [
    file("./values/default/cluster-overprovisioner.yaml"),
    yamlencode(
      {
        deployments = [
          {
            name         = "sample"
            replicaCount = 1
            resources = {
              requests = {
                cpu    = "100m"
                memory = "128Mi"
              }
            }
          },
        ]
      }
    )
  ]

  # set {
  #   name  = "deployments.0.replicaCount"
  #   value = 1
  # }

  wait = false
}

# for jenkins
resource "kubernetes_config_map" "jenkins-env" {
  metadata {
    namespace = "default"
    name      = "jenkins-env"
  }

  data = {
    # "groovy" = file("${path.module}/template/jenkins-env.groovy")
    "groovy" = data.template_file.jenkins-env.rendered
  }
}

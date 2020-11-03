# chaos

resource "helm_release" "chaoskube" {
  count = var.chaoskube_enabled ? 1 : 0

  repository = "https://charts.helm.sh/stable"
  chart      = "chaoskube"
  version    = var.stable_chaoskube

  namespace = "chaos"
  name      = "chaoskube"

  values = [
    file("./values/chaos/chaoskube.yaml")
  ]

  create_namespace = true
}

# resource "helm_release" "chaos-mesh" {
#   count = var.chaos_mesh_enabled ? 1 : 0

#   # repository = "https://charts.helm.sh/stable"
#   repository = "https://opspresso.github.io/helm-charts/"
#   chart      = "chaos-mesh"
#   version    = "v0.1.2" # var.chaos_mesh_chaos_mesh

#   namespace = "chaos"
#   name      = "chaos-mesh"

#   values = [
#     file("./values/chaos/chaos-mesh.yaml")
#   ]

#   create_namespace = true
# }

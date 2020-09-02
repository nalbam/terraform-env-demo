# # demo-dev

# resource "kubernetes_namespace" "demo-dev" {
#   count = var.argo_cd_enabled ? 1 : 0

#   metadata {
#     labels = {
#       istio-injection = "enabled"
#     }

#     name = "demo-dev"
#   }
# }

# # for argo-rollouts
# resource "helm_release" "demo-dev-http-benchmark" {
#   count = var.argo_cd_enabled ? 1 : 0

#   repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
#   chart      = "raw"

#   namespace = "demo-dev"
#   name      = "http-benchmark"

#   values = [
#     file("./values/argo/http-benchmark.yaml")
#   ]

#   depends_on = [
#     kubernetes_namespace.demo-dev,
#     helm_release.argo-rollouts,
#   ]
# }

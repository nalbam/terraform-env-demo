# # demo-prod

# resource "kubernetes_namespace" "demo-prod" {
#   count = var.argo_cd_enabled ? 1 : 0

#   metadata {
#     labels = {
#       istio-injection = "enabled"
#     }

#     name = "demo-prod"
#   }
# }

# # for argo-rollouts
# resource "helm_release" "demo-prod-http-benchmark" {
#   count = var.argo_cd_enabled ? 1 : 0

#   repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
#   chart      = "raw"

#   namespace = "demo-prod"
#   name      = "http-benchmark"

#   values = [
#     file("./values/argo/http-benchmark.yaml")
#   ]

#   depends_on = [
#     kubernetes_namespace.demo-prod,
#     helm_release.argo-rollouts,
#   ]
# }

# appmesh

# https://aws.amazon.com/ko/blogs/containers/getting-started-with-app-mesh-and-eks/
# https://github.com/aws/eks-charts/blob/master/stable/appmesh-controller/values.yaml

resource "helm_release" "appmesh-controller" {
  count = var.appmesh_enabled ? 1 : 0

  repository = "https://aws.github.io/eks-charts"
  chart      = "appmesh-controller"
  version    = var.aws_appmesh_controller

  namespace = "appmesh-system"
  name      = "appmesh-controller"

  values = [
    file("./values/appmesh/appmesh-controller.yaml")
  ]

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_appmesh.arn
  }

  create_namespace = true
}

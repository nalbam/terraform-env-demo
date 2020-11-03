# kube-ingress

resource "helm_release" "alb-ingress" {
  repository = "http://storage.googleapis.com/kubernetes-charts-incubator"
  chart      = "aws-alb-ingress-controller"
  version    = var.incubator_aws_alb_ingress_controller

  namespace = "kube-ingress"
  name      = "alb-ingress"

  values = [
    file("./values/kube-ingress/alb-ingress.yaml")
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_alb_ingress.arn
  }

  wait = false

  create_namespace = true
}

resource "helm_release" "ingress-nginx" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_ingress_nginx

  namespace = "kube-ingress"
  name      = "ingress-nginx"

  values = [
    file("./values/kube-ingress/ingress-nginx.yaml")
  ]

  set {
    name  = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = local.hostname_public
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = local.acm_arn
  }

  set {
    name  = "controller.service.internal.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = local.hostname_internal
  }

  set {
    name  = "controller.service.internal.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = local.acm_arn
  }

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

# resource "helm_release" "nginx-ingress" {
#   repository = "https://charts.helm.sh/stable"
#   chart      = "nginx-ingress"
#   version    = var.stable_nginx_ingress

#   namespace = "kube-ingress"
#   name      = "nginx-ingress"

#   values = [
#     file("./values/kube-ingress/nginx-ingress.yaml")
#   ]

#   set {
#     name  = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
#     value = local.hostname
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
#     value = local.acm_arn
#   }

#   wait = false

#   create_namespace = true

#   depends_on = [
#     helm_release.prometheus-operator,
#   ]
# }

resource "helm_release" "external-dns" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.bitnami_external_dns

  namespace = "kube-ingress"
  name      = "external-dns"

  values = [
    file("./values/kube-ingress/external-dns.yaml")
  ]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_external_dns.arn
  }

  wait = false

  create_namespace = true
}

# resource "helm_release" "cert-manager" {
#   count = var.cert_manager_enabled ? 1 : 0

#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = var.jetstack_cert_manager

#   namespace = "kube-ingress"
#   name      = "cert-manager"

#   values = [
#     file("./values/kube-ingress/cert-manager.yaml")
#   ]

#   create_namespace = true

#   depends_on = [
#     helm_release.prometheus-operator,
#   ]
# }

# resource "helm_release" "cert-manager-issuers" {
#   count = var.cert_manager_enabled ? 1 : 0

#   repository = "https://charts.helm.sh/incubator"
#   chart      = "raw"

#   namespace = "kube-ingress"
#   name      = "cert-manager-issuers"

#   values = [
#     file("./values/kube-ingress/cert-manager-issuers.yaml")
#   ]

#   wait = false

#   create_namespace = true

#   depends_on = [
#     helm_release.cert-manager,
#   ]
# }

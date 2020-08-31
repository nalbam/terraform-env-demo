# kube-ingress

resource "helm_release" "nginx-ingress" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "nginx-ingress"
  version    = var.stable_nginx_ingress

  namespace = "kube-ingress"
  name      = "nginx-ingress"

  values = [
    file("./values/kube-ingress/nginx-ingress.yaml")
  ]

  set {
    name  = "controller.service.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
    value = local.hostname
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-ssl-cert"
    value = local.acm_arn
  }

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

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
    value = module.irsa_dns.arn
  }

  wait = false

  create_namespace = true
}

resource "helm_release" "cert-manager" {
  count = var.cert_manager_enabled ? 1 : 0

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.jetstack_cert_manager

  namespace = "kube-ingress"
  name      = "cert-manager"

  values = [
    file("./values/kube-ingress/cert-manager.yaml")
  ]

  create_namespace = true

  depends_on = [
    helm_release.prometheus-operator,
  ]
}

resource "helm_release" "cert-manager-issuers" {
  count = var.cert_manager_enabled ? 1 : 0

  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "raw"

  namespace = "kube-ingress"
  name      = "cert-manager-issuers"

  values = [
    file("./values/kube-ingress/cert-manager-issuers.yaml")
  ]

  wait = false

  create_namespace = true

  depends_on = [
    helm_release.cert-manager,
  ]
}

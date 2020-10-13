# iam policy

module "irsa_atlantis" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-atlantis"

  cluster_name = var.cluster_name

  kube_namespace      = "atlantis"
  kube_serviceaccount = "atlantis"

  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}

module "irsa_cluster_autoscaler" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-cluster-autoscaler"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "cluster-autoscaler"

  policy_document = file("./policy/asg.json")

  # policy_arns = [
  #   "arn:aws:iam::aws:policy/AutoScalingFullAccess",
  # ]
}

module "irsa_k8s_spot_termination_handler" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-k8s-spot-termination-handler"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "k8s-spot-termination-handler"

  policy_document = file("./policy/asg.json")

  # policy_arns = [
  #   "arn:aws:iam::aws:policy/AutoScalingFullAccess",
  # ]
}

module "irsa_efs_provisioner" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-efs-provisioner"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "efs-provisioner"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess",
  ]
}

module "irsa_external_secrets" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-external-secrets"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "external-secrets"

  policy_arns = [
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
  ]
}

module "irsa_alb_ingress" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-alb-ingress"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-ingress"
  kube_serviceaccount = "alb-ingress"

  policy_document = file("./policy/alb.json")

  # policy_arns = [
  #   "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
  # ]
}

module "irsa_external_dns" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-external-dns"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-ingress"
  kube_serviceaccount = "external-dns"

  policy_document = file("./policy/dns.json")

  # policy_arns = [
  #   "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
  # ]
}

module "irsa_appmesh" {
  source  = "nalbam/eks-irsa/aws"
  version = "0.12.3"

  region = var.region

  name = "${var.cluster_name}-irsa-appmesh"

  cluster_name = var.cluster_name

  kube_namespace      = "appmesh-system"
  kube_serviceaccount = "appmesh-controller"

  policy_arns = [
    "arn:aws:iam::aws:policy/AWSAppMeshFullAccess",
    "arn:aws:iam::aws:policy/AWSCloudMapFullAccess",
  ]
}

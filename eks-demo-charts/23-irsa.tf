# iam policy

module "irsa_asg" {
  source = "github.com/nalbam/terraform-aws-eks-irsa?ref=v0.12.3"
  # source = "../../../terraform-aws-eks-irsa"

  region = var.region

  name = "${var.cluster_name}-irsa-asg"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "cluster-autoscaler"

  policy_document = data.aws_iam_policy_document.asg.json
}

module "irsa_efs" {
  source = "github.com/nalbam/terraform-aws-eks-irsa?ref=v0.12.3"
  # source = "../../../terraform-aws-eks-irsa"

  region = var.region

  name = "${var.cluster_name}-irsa-efs"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "efs-provisioner"

  policy_document = data.aws_iam_policy_document.efs.json
}

module "irsa_ssm" {
  source = "github.com/nalbam/terraform-aws-eks-irsa?ref=v0.12.3"
  # source = "../../../terraform-aws-eks-irsa"

  region = var.region

  name = "${var.cluster_name}-irsa-ssm"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-system"
  kube_serviceaccount = "external-secrets"

  policy_document = data.aws_iam_policy_document.ssm.json
}

module "irsa_dns" {
  source = "github.com/nalbam/terraform-aws-eks-irsa?ref=v0.12.3"
  # source = "../../../terraform-aws-eks-irsa"

  region = var.region

  name = "${var.cluster_name}-irsa-dns"

  cluster_name = var.cluster_name

  kube_namespace      = "kube-ingress"
  kube_serviceaccount = "external-dns"

  policy_document = data.aws_iam_policy_document.dns.json
}

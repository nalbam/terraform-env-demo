# locals

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  name = "${var.name}"

  workers = [
    "arn:aws:iam::${local.account_id}:role/eks-demo-worker",
  ]

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${local.account_id}:role/dev-bastion"
      username = "iam-role-eks-bastion"
      groups   = ["system:masters"]
    },
  ]

  map_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/ops"
      username = "ops"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/bruce"
      username = "bruce"
      groups   = ["system:masters"]
    },
    # {
    #   userarn  = "arn:aws:iam::${local.account_id}:user/developer"
    #   username = "developer"
    #   groups   = []
    # },
    # {
    #   userarn  = "arn:aws:iam::${local.account_id}:user/readonly"
    #   username = "readonly"
    #   groups   = []
    # },
  ]
}

# locals

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  name = var.name

  workers = [
    format("%s-worker", var.name),
  ]

  roles = [
    {
      name = "dev-bastion"
      groups = ["system:masters"]
    },
  ]

  users = [
    {
      name = "bruce"
      groups = ["system:masters"]
    },
    {
      name = "developer"
      groups = []
    },
    {
      name = "readonly"
      groups = []
    },
  ]
}

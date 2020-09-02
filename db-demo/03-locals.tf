# locals

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  # https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )

  db_username = local.db_creds.username != "" ? local.db_creds.username : var.db_username
  db_password = local.db_creds.password != "" ? local.db_creds.password : var.db_username
}

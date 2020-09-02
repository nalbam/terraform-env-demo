# data

data "aws_caller_identity" "current" {
}

data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = var.name
}

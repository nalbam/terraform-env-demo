# ssm

resource "aws_ssm_parameter" "address" {
  name  = format("/rds/%s/%s", var.name, "address")
  type  = "SecureString"
  value = module.db.address
}

resource "aws_ssm_parameter" "port" {
  name  = format("/rds/%s/%s", var.name, "port")
  type  = "SecureString"
  value = module.db.port
}

resource "aws_ssm_parameter" "endpoint" {
  name  = format("/rds/%s/%s", var.name, "endpoint")
  type  = "SecureString"
  value = module.db.endpoint
}

resource "aws_ssm_parameter" "dbname" {
  name  = format("/rds/%s/%s", var.name, "dbname")
  type  = "SecureString"
  value = var.db_name
}

resource "aws_ssm_parameter" "username" {
  name  = format("/rds/%s/%s", var.name, "username")
  type  = "SecureString"
  value = var.db_username
}

resource "aws_ssm_parameter" "password" {
  name  = format("/rds/%s/%s", var.name, "password")
  type  = "SecureString"
  value = var.db_password
}

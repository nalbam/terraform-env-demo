# rds

module "db" {
  source = "github.com/nalbam/terraform-aws-rds?ref=v0.12.8"
  # source = "../../../terraform-aws-rds"

  region = var.region

  identifier = var.name

  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_type

  storage_type      = var.db_storage_type
  allocated_storage = var.db_allocated_storage
  storage_encrypted = var.db_storage_encrypted

  # kms_key_id = "arm:aws:kms:<region>:<account id>:key/<kms key id>"

  name     = var.db_name
  username = local.db_username
  password = local.db_password
  port     = var.db_port

  publicly_accessible = var.publicly_accessible

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  # security group
  allow_ip_address = data.terraform_remote_state.vpc.outputs.private_subnet_cidr

  # subnet group
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  # parameter group
  family = var.db_family

  # option group
  major_engine_version = var.db_major_engine_version

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.name}-snapshot"

  maintenance_window = "Mon:02:00-Mon:03:00"
  backup_window      = "04:00-05:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  # enhanced monitoring
  monitoring_interval = 10

  # cloudwatch
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Database Deletion Protection
  deletion_protection = false

  tags = {
    Owner       = "bruce"
    Environment = "dev"
  }
}

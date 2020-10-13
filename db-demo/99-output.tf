# output

output "region" {
  value = var.region
}

output "address" {
  value = module.db.address
}

output "port" {
  value = module.db.port
}

output "endpoint" {
  value = module.db.endpoint
}

output "name" {
  value = module.db.name
}

output "username" {
  value = local.db_username
}

output "password" {
  value = local.db_password
}

output "security_group_id" {
  value = module.db.security_group_id
}

output "allow_ip_address" {
  value = local.allow_ip_address
}

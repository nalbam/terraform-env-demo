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

output "security_group_id" {
  value = module.db.security_group_id
}

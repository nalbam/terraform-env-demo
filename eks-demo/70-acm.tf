# acm

data "aws_route53_zone" "this" {
  count = var.root_domain != "" ? 1 : 0

  name = var.root_domain
}

resource "aws_acm_certificate" "this" {
  count = var.root_domain != "" ? var.base_domain != "" ? 1 : 0 : 0

  domain_name = var.base_domain

  subject_alternative_names = [
    "*.${var.base_domain}",
  ]

  validation_method = "DNS"
}

resource "aws_route53_record" "this" {
  count = var.root_domain != "" ? var.base_domain != "" ? 1 : 0 : 0

  zone_id = data.aws_route53_zone.this.0.id
  name    = element(concat(aws_acm_certificate.this.0.domain_validation_options.*.resource_record_name, [""]), 0)
  type    = element(concat(aws_acm_certificate.this.0.domain_validation_options.*.resource_record_type, [""]), 0)
  ttl     = 300

  records = [
    element(concat(aws_acm_certificate.this.0.domain_validation_options.*.resource_record_value, [""]), 0),
  ]

  depends_on = [
    aws_acm_certificate.this,
  ]
}

resource "aws_acm_certificate_validation" "this" {
  count = var.root_domain != "" ? var.base_domain != "" ? 1 : 0 : 0

  certificate_arn = aws_acm_certificate.this.0.arn

  validation_record_fqdns = [
    aws_route53_record.this.0.fqdn,
  ]

  depends_on = [
    aws_route53_record.this,
  ]
}

output "root_domain" {
  value = var.root_domain
}

output "base_domain" {
  value = var.base_domain
}

output "acm_arn" {
  # value = aws_acm_certificate.this.*.arn
  value = element(concat(aws_acm_certificate.this.*.arn, [""]), 0)
}

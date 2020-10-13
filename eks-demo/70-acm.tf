# acm

data "aws_route53_zone" "this" {
  count = var.domain_name != "" ? 1 : 0

  name = var.domain_name
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  # version = "~> v2.0"

  domain_name  = data.aws_route53_zone.this.0.name
  zone_id      = data.aws_route53_zone.this.0.zone_id

  subject_alternative_names = [
    format("*.%s", var.domain_name),
    format("*.in.%s", var.domain_name),
    format("*.pub.%s", var.domain_name),
  ]

  tags = {
    Name = var.domain_name
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}

output "domain_name" {
  value = var.domain_name
}

output "domain_names" {
  value = module.acm.distinct_domain_names
}

output "acm_arn" {
  value = module.acm.this_acm_certificate_arn
}

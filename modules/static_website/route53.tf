data "aws_route53_zone" "existing_hosted_zone" {
  name = var.domain
  private_zone = false
}

# verification record for api domain
resource "aws_route53_record" "domain_verification_record_api" {
  for_each = {
    for dvo in aws_acm_certificate.api_certification.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.existing_hosted_zone.id
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

# verification record for domain name
resource "aws_route53_record" "domain_verification_record" {
  for_each = {
    for dvo in aws_acm_certificate.domain_name_certification.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = data.aws_route53_zone.existing_hosted_zone.id
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}
resource "aws_route53_record" "domain_name" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.id
  name    = var.domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.portfolio_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  
}
resource "aws_route53_record" "www_domain_name" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.id
  name    = "www.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.portfolio_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "Api" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.id
  name = "api.${var.domain}"
  type = "A"
  alias {
    name = aws_api_gateway_domain_name.ivanravic_domain.cloudfront_domain_name
    zone_id = aws_api_gateway_domain_name.ivanravic_domain.cloudfront_zone_id
    evaluate_target_health = false
  }
}
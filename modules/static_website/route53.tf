data "aws_route53_zone" "existing_hosted_zone" {
  name = "ivanravic.com"
  private_zone = false
}

# verification record for api domain
resource "aws_route53_record" "domain_verification_record_api" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
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

# verification record for s3 domain
resource "aws_route53_record" "domain_verification_record_s3" {
  for_each = {
    for dvo in aws_acm_certificate.s3_certification.domain_validation_options : dvo.domain_name => {
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
# route53 records for api
resource "aws_route53_record" "ivanravic_www_api_dns" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.id
  name    = "www"
  type    = "CNAME"

  records = [aws_api_gateway_domain_name.ivanravic_domain.cloudfront_domain_name]
  ttl = 300
}

provider "aws"{
  alias = "us-east-1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "api_certification" {
  provider = aws.us-east-1
  domain_name       = "api.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "domain_name_certification" {
  provider = aws.us-east-1
  domain_name       = var.domain
  validation_method = "DNS"

  subject_alternative_names = [ "*.${var.domain}" ]
  lifecycle {
    create_before_destroy = true
  }
}
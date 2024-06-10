provider "aws"{
  alias = "us-east-1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "domain_cert" {
  provider = aws.us-east-1
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "s3_certification"{
  provider = aws.us-east-1
  domain_name       = var.subdomain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
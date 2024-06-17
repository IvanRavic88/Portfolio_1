resource "aws_cloudfront_distribution" "portfolio_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_document

  origin {
    domain_name = aws_s3_bucket.portfolio_bucket.bucket_regional_domain_name
    origin_id   = var.bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_oai.cloudfront_access_identity_path
    }
  }

 

  aliases = [ var.domain, "www.${var.domain}"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD", "OPTIONS","POST", "PUT", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.portfolio_bucket.bucket
    compress = true

    forwarded_values {
      query_string = false
      headers = [ "Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.domain_name_certification.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  
}

resource "aws_cloudfront_origin_access_identity" "website_oai" {
  comment = "OAI for my website bucket"
  
}
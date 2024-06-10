resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "website_bucket_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = var.default_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "website_bucket_policy_document" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    effect  = "Allow"
    resources = [
      "${aws_s3_bucket.website_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
 
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.website_bucket_policy_document.json
}

resource "null_resource" "sync_files" {
  provisioner "local-exec" {
    command = "aws s3 sync ./templates s3://${aws_s3_bucket.website_bucket.bucket}/"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ./static s3://${aws_s3_bucket.website_bucket.bucket}/static --recursive"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ./Ivan's Resume.pdf s3://${aws_s3_bucket.website_bucket.bucket}"
  }
}

# records for s3 subdomain routing
resource "aws_route53_record" "s3_subdomain" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.id
  name = var.subdomain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
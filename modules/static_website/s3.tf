resource "aws_s3_bucket" "portfolio_bucket" {
  bucket = var.bucket_name

  force_destroy = true


  }

resource "aws_s3_bucket_cors_configuration" "portfolio_bucket_cors" {
  bucket = aws_s3_bucket.portfolio_bucket.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://api.${var.domain}"]
    expose_headers  = ["GET","POST", "OPTIONS"]
    max_age_seconds = 60
  }
  
}

resource "aws_s3_bucket_website_configuration" "portfolio_bucket_config" {
  bucket = aws_s3_bucket.portfolio_bucket.bucket

  index_document {
    suffix = var.default_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_bucket_public_access_block" "portfolio_bucket_access" {
  bucket = aws_s3_bucket.portfolio_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "portfolio_bucket_policy_document" {
  statement {
    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.website_oai.iam_arn]
    }
    actions = ["s3:GetObject"]
    effect  = "Allow"
    resources = [
      "${aws_s3_bucket.portfolio_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "portfolio_bucket_policy" {
 
  bucket = aws_s3_bucket.portfolio_bucket.id
  policy = data.aws_iam_policy_document.portfolio_bucket_policy_document.json
}

resource "null_resource" "sync_files" {
  provisioner "local-exec" {
    command = "aws s3 sync ./templates s3://${aws_s3_bucket.portfolio_bucket.bucket}/"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ./static s3://${aws_s3_bucket.portfolio_bucket.bucket}/static --recursive"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ./Ivan\\'s\\ Resume.pdf s3://${aws_s3_bucket.portfolio_bucket.bucket}"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ./dist s3://${aws_s3_bucket.portfolio_bucket.bucket}/dist --recursive"
  }
}


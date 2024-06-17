# sending mail with AWS SES
provider "aws" {
  region = var.region
}

resource "aws_ses_email_identity" "mail_for_sending" {
  email = var.email_for_sending
}

resource "aws_ses_email_identity" "mail_for_receiving" {
  email = var.email_for_receiving
}


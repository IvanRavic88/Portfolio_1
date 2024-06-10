resource "aws_ssm_parameter" "secret_key" {
  name  = "/portfolio/secret_key"
  type  = "SecureString"
  value = var.secret_key
}

resource "aws_ssm_parameter" "mail_username" {
  name  = "/portfolio/mail_username"
  type  = "SecureString"
  value = var.mail_username
}

resource "aws_ssm_parameter" "mail_password" {
  name  = "/portfolio/mail_password"
  type  = "SecureString"
  value = var.mail_password
}
resource "aws_ssm_parameter" "email_for_sending" {
  name  = "/portfolio/email_for_sending"
  type  = "String"
  value = var.email_for_sending
}

resource "aws_ssm_parameter" "email_for_receiving" {
  name  = "/portfolio/email_for_receiving"
  type  = "String"
  value = var.email_for_receiving
}
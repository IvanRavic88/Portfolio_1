module "website" {
  source = "./modules/static_website"

  bucket_name = "${var.my_name}-website-${var.stage}"
  domain = var.domain_name
  subdomain = var.subdomain
  secret_key = var.secret_key
  mail_username = var.mail_username
  mail_password = var.mail_password
}
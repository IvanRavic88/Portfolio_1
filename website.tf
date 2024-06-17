module "website" {
  source = "./modules/static_website"

  bucket_name = "${var.my_name}-website-${var.stage}"
  domain = var.domain_name
  subdomain = var.subdomain
  email_for_receiving = var.email_for_receiving
  email_for_sending = var.email_for_sending

}
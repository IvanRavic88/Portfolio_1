variable "bucket_name" {
  description = "The bucket name where the static website will be hosted."
  type        = string
}

variable "domain" {
  description = "The website's domain name."
  type        = string
}
variable "subdomain" {
  description = "The subdomain for static files and s3 bucket."
  type        = string
}


variable "default_document" {
  description = "The web app's default document to be served."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The web app's default error document."
  type        = string
  default     = "404.html"
}


variable "region" {
  default = "eu-central-1"
}

variable "email_for_sending" {
  description = "The email address from which the emails will be sent."
}

variable "email_for_receiving" {
  description = "The email address to which the emails will be sent."
  
}
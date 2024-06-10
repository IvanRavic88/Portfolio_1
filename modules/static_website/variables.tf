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

variable "secret_key" {
  type = string
  description = "Value of the secret for mail sending"
  
}

variable "mail_username" {
  type = string
  description = "Value of the mail username"
  
}

variable "mail_password" {
  type = string
  description = "Value of the mail password"
  
  }
variable "domain_name" {
  default = "ivanravic.com"
}

variable "subdomain" {
  default = "static.ivanravic.com"
}

variable "my_name" {
  default = "ivan-ravic"
}

variable "profile" {
  default = "default"
}

variable "stage"{
  default = "dev"
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
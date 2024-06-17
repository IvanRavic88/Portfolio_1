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

variable "email_for_receiving" {
  description = "Email address to receive notifications"
  
}

variable "email_for_sending" {
  description = "Email address to send notifications"
  
}
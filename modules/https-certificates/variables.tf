variable "env" {}

variable "config_path" {}

variable "cert_manager_version" {
  default = "v0.8.0"
}

variable "nginx_ingress_version" {
  default = "1.6.8"
}

variable "issuer_certificate_version" {
  default = "0.0.2"
}

variable "dictybase_ingress_version" {
  default = "2.1.0"
}


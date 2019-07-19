# Variables
variable "env" {}

variable "gcloud_account" {}

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

variable "kubeless_version" {
  default = "2.0.6"
}

variable "apps" {
  default = ["minio", "redis"]
}

variable "env_value_files"  {
  default = ["dev.yaml", "staging.yaml", "prod.yaml"]
}

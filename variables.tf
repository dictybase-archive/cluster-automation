# Variables
variable "cert_manager_version" {
  default = "v0.8.0"
}

variable "nginx_ingress_version" {
  default = "1.6.8"
}

variable "redis_version" {
  default = "3.7.3"
}

variable "kubeless_version" {
  default = "2.0.6"
}

variable "gcloud_account" {}

variable "config_path" {}

variable "apps" {
  default = ["minio", "redis"]
}

variable "env" {}

variable "env_value_files" {
  default = ["dev.yaml", "staging.yaml", "prod.yaml"]
}


# Variables
variable "cert_manager_version" {
  default = "v0.8.0"
}

variable "nginx_ingress_version" {
  default = "1.6.8"
}

variable "gcloud_account" {}

variable "config_path" {}

variable "apps" {
  default = ["minio", "redis"]
}

variable "env_value_files"  {
  default = ["dev.yaml", "staging.yaml", "prod.yaml"]
}


# Variables
variable "env" {}

variable "gcloud_account" {}

variable "config_path" {}

variable "kubeless_version" {
  default = "2.0.6"
}

variable "apps" {
  default = ["minio", "redis"]
}

variable "env_value_files"  {
  default = ["dev.yaml", "staging.yaml", "prod.yaml"]
}

# Variables
variable "env" {}

variable "gcloud_account" {}

variable "config_path" {}

variable "apps" {
  default = ["minio", "redis"]
}

variable "env_value_files"  {
  default = ["dev.yaml", "staging.yaml", "prod.yaml"]
}

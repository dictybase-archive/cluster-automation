# Variables
variable "config_path" {}

variable "env" {}

variable "redis_version" {
  default = "3.7.3"
}

variable "nats_version" {
  default = "0.0.2"
}

variable "nats_operator_version" {
  default = "0.0.2"
}

variable "minio_version" {
  default = "2.4.14"
}

variable "dictycontent_postgres_version" {
  default = "2.0.1"
}

variable "arango_chart_version" {
  default = "0.3.11"
}

variable "dictybase_arangodb_version" {
  default = "0.5.0"
}

variable  "arangodb_storage_size" {
  default = "50Gi"
}


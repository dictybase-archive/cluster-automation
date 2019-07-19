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

variable "issuer_certificate_version" {
  default = "0.0.2"
}

variable "dictybase_ingress_version" {
  default = "2.1.0"
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

variable "dictycontent_schema_version" {
  default = "1.1.0"
}

variable "dictyuser_schema_version" {
  default = "3.1.0"
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

variable "dictybase_arango_create_db_version" {
  default = "0.0.3"
}

variable "argo_events_version" {
  default = "0.4.2"
}

variable "argo_workflow_version" {
  default = "0.4.0"
}

variable  "arangodb_storage_size" {
  default = "50Gi"
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

variable "env_value_files"  {
  default = ["dev.yaml", "staging.yaml", "prod.yaml"]
}

variable "argo_namespace" {
  default = "argo"
}

variable "argo_service_account" {
  default = "argo-workflow"
}

variable "minio_secret" {
  default = "minio-secret"
}


variable "docker_secret" {
  default = "docker-secret"
}

variable "docker_config_path" {
  default = "~/.docker/config.json"
}

variable "slack_secret" {
  default = "slack-secret"
}

variable "github_secret" {
  default = "github-access"
}

variable "slack_secret_data" {}

variable "github_token_path" {
  default = "~/.github-webhook"
}

variable "github_organization" {
  default = "dictyBase"
}

variable "github_repositories" {
  default = [
    "dicty-stock-center",
    "dicty-frontpage",
    "genomepage",
    "dictyaccess",
    "publication",
    "modware-stock",
    "modware-order",
    "modware-annotation",
    "modware-identity",
    "modware-user",
    "modware-content",
    "graphql-server",
  ]
}

# Variables
variable "config_path" {}

variable "env" {}

variable "slack_secret_data" {}

variable "github_organization" {}

variable "github_token_path" {}

variable "argo_events_version" {
  default = "0.4.2"
}

variable "argo_workflow_version" {
  default = "0.4.0"
}

variable "argo_github_pipeline_version" {
  default = "0.4.0"
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

variable "dictybase_ontology_repo" {
  default = "migration-data"
}

variable "argo_ontology_pipeline_version" {
  default = "0.0.1"
}

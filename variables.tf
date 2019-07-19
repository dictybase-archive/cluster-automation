# Variables
variable "env" {}

variable "gcloud_account" {}

variable "config_path" {}

variable "slack_secret_data" {}

variable "github_organization" {
  default = "dictyBase"
}

variable "github_token_path" {
  default = "~/.github-webhook"
}

provider "kubernetes" {}
provider "helm" {
  kubernetes {}
}

provider "github" {
  token        = local.github_token_data
  organization = "${var.github_organization}"
}

data "local_file" "github_token" {
  filename = pathexpand("${var.github_token_path}")
}

locals {
  github_token_data = trimspace("${data.local_file.github_token.content}")
}

## -- cluster admin
resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "dictyadmin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "${var.gcloud_account}"
    api_group = "rbac.authorization.k8s.io"
  }
}


module "storage-services" {
  source      = "./modules/storage-services"
  config_path = "${var.config_path}"
  env         = "${var.env}"
}

module "https-certificates" {
  source      = "./modules/https-certificates"
  config_path = "${var.config_path}"
  env         = "${var.env}"
}

module "backend-api" {
  source      = "./modules/backend-api"
  config_path = "${var.config_path}"
  env         = "${var.env}"
}

module "frontend-app" {
  source      = "./modules/frontend-app"
  config_path = "${var.config_path}"
  env         = "${var.env}"
}



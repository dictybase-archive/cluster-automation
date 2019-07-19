terraform {
  required_version = ">= 0.12"
}

provider "kubernetes" {}
provider "helm" {
    kubernetes {}
}

data "local_file" "github_token" {
  filename = pathexpand("${var.github_token_path}")
}

locals {
  github_token_data = trimspace("${data.local_file.github_token.content}")
}

provider "github" {
  token = local.github_token_data
  organization = "${var.github_organization}"
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

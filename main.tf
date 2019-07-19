terraform {
  required_version = ">= 0.12"
}

provider "kubernetes" {}
provider "helm" {
    kubernetes {}
}

provider "github" {
  token = local.github_token_data
  organization = "${var.github_organization}"
}

data "helm_repository" "stable" {
  name = "stable"
  url = "http://storage.googleapis.com/kubernetes-charts"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url = "https://charts.jetstack.io"
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

## -- kubeless
resource "helm_release" "kubeless" {
  name = "kubeless"
  chart = "incubator/kubeless"
  version =  "${var.kubeless_version}"
  namespace = "kubeless"

  set {
    name = "rbac.create"
    value = "true"
  }
}


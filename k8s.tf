provider "kubernetes" {}
provider "helm" {
    kubernetes {}
}

data "helm_repository" "stable" {
  name = "stable"
  url = "http://storage.googleapis.com/kubernetes-charts"
}


data "helm_repository" "dictybase" {
  name = "dictybase"
  url = "https://dictybase-docker.github.io/kubernetes-charts"
}

data "helm_repository" "incubator" {
  name = "incubator"
  url = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

data "helm_repository" "argo" {
  name = "argo"
  url = "https://argoproj.github.io/argo-helm"
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url = "https://charts.jetstack.io"
}



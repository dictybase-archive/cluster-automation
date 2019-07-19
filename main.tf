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

## -- nginx ingress controller
resource "helm_release" "nginx-ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  version =  "${var.nginx_ingress_version}"
}

## -- cert-manager for lets encrypt based https access
resource "null_resource" "cert-manager" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://githubusercontent.com/jetstack/cert-manager/${var.cert_manager_version}/deploy/manifests/00-crds.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl create ns cert-manager"
  }
  provisioner "local-exec" {
    command = "kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true"
  }
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"
  chart = "jetstack/cert-manager"
  version =  "${var.cert_manager_version}"
  namespace = "cert-manager"
}


## data loaders go here

## -- dictybase issuer and certificate
resource "helm_release" "dicty-issuer-certificate" {
  name = "dicty-issuer-certificate"
  chart = "dictybase/issuer-certificate"
  namespace = "dictybase"
  version = "${var.issuer_certificate_version}"
  values = ["${var.config_path}/dictybase-certificate/${var.env}.yaml"]
}

## -- dictybase ingress charts
resource "helm_release" "dictybase-auth-ingress" {
  name = "dictybase-auth-ingress"
  chart = "dictybase/dictybase-ingress"
  namespace = "dictybase"
  version = "${var.dictybase_ingress_version}"
  values = ["${var.config_path}/dictybase-auth-certificate/${var.env}.yaml"]
}

resource "helm_release" "dictybase-ingress" {
  name = "dictybase-ingress"
  chart = "dictybase/dictybase-ingress"
  namespace = "dictybase"
  version = "${var.dictybase_ingress_version}"
  values = ["${var.config_path}/dictybase-ingress/${var.env}.yaml"]
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

## install kubeless functions here

## frontend web apps
resource "helm_release" "dicty-stock-center" {
  name = "dicty-stock-center"
  chart = "dictybase/dicty-stock-center"
  namespace = "dictybase"
  values = [
    "${var.config_path}/dicty-stock-center/${var.env}.yaml"
  ]
}

resource "helm_release" "dicty-frontpage" {
  name = "dicty-frontpage"
  chart = "dictybase/dicty-frontpage"
  namespace = "dictybase"
  values = [
    "${var.config_path}/dicty-frontpage/${var.env}.yaml"
  ]
}

resource "helm_release" "genomepage" {
  name = "genomepage"
  chart = "dictybase/genomepage"
  namespace = "dictybase"
  values = [
    "${var.config_path}/genomepage/${var.env}.yaml"
  ]
}

resource "helm_release" "dictyaccess" {
  name = "dictyaccess"
  chart = "dictybase/dictyaccess"
  namespace = "dictybase"
  values = [
    "${var.config_path}/dictyaccess/${var.env}.yaml"
  ]
}

resource "helm_release" "publication" {
  name = "publication"
  chart = "dictybase/publication"
  namespace = "dictybase"
  values = [
    "${var.config_path}/publication/${var.env}.yaml"
  ]
}

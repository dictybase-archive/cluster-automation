data "helm_repository" "stable" {
  name = "stable"
  url = "http://storage.googleapis.com/kubernetes-charts"
}

data "helm_repository" "jetstack" {
  name = "jetstack"
  url = "https://charts.jetstack.io"
}

data "helm_repository" "dictybase" {
  name = "dictybase"
  url = "https://dictybase-docker.github.io/kubernetes-charts"
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

resource "helm_release" "argo-certificate" {
  name = "argo-certificate"
  chart = "dictybase/issuer-certificate"
  namespace = "${var.argo_namespace}"
  version = "${var.issuer_certificate_version}"
  values = [
    "${var.config_path}/argo-certificate/${var.env}.yaml"
  ]
}

resource "helm_release" "github-ingress" {
  name = "github-gateway-ingress"
  chart = "dictybase/dictybase-ingress"
  namespace = "${var.argo_namespace}"
  version = "${var.dictybase_ingress_version}"
  values = [
    "${var.config_path}/argo-ingress/${var.env}.yaml"
  ]
}

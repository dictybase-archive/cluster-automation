## -- nginx ingress controller
resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = "http://storage.googleapis.com/kubernetes-charts"
  chart      = "nginx-ingress"
  version    = var.nginx_ingress_version
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
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_version
  namespace  = "cert-manager"
}

## -- dictybase issuer and certificate
resource "helm_release" "dicty-issuer-certificate" {
  name       = "dicty-issuer-certificate"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "issuer-certificate"
  namespace  = "dictybase"
  version    = var.issuer_certificate_version
  values     = ["${var.config_path}/dictybase-certificate/${var.env}.yaml"]
}

## -- dictybase ingress charts
resource "helm_release" "dictybase-auth-ingress" {
  name       = "dictybase-auth-ingress"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dictybase-ingress"
  namespace  = "dictybase"
  version    = var.dictybase_ingress_version
  values     = ["${var.config_path}/dictybase-auth-ingress/${var.env}.yaml"]
}

resource "helm_release" "dictybase-ingress" {
  name       = "dictybase-ingress"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dictybase-ingress"
  namespace  = "dictybase"
  version    = var.dictybase_ingress_version
  values     = ["${var.config_path}/dictybase-ingress/${var.env}.yaml"]
}

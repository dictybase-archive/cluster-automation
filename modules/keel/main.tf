data "helm_repository" "keel" {
  name = "keel"
  url = "https://charts.keel.sh"
}

resource "helm_release" "keel-issuer-certificate" {
  name      = "keel-issuer-certificate"
  chart     = "dictybase/issuer-certificate"
  namespace = "kube-system"
  version   = "${var.issuer_certificate_version}"
  values    = ["${var.config_path}/keel/issuer-cert-${var.env}.yaml"]
}

resource "helm_release" "keel" {
  name = "keel"
  chart = "keel/keel"
  namespace = "kube-system"
  version = "${var.keel_version}"
  values = [
    "${var.config_path}/keel/${var.env}.yaml"
  ]
}

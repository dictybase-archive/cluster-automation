data "helm_repository" "incubator" {
  name = "incubator"
  url  = "https://kubernetes-charts-incubator.storage.googleapis.com"
}

## -- kubeless
resource "helm_release" "kubeless" {
  name      = "kubeless"
  chart     = "incubator/kubeless"
  version   = "${var.kubeless_version}"
  namespace = "kubeless"

  set {
    name  = "rbac.create"
    value = "true"
  }
}

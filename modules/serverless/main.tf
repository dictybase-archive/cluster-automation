## -- kubeless
resource "helm_release" "kubeless" {
  name       = "kubeless"
  repository = "https://kubernetes-charts-incubator.storage.googleapis.com"
  chart      = "kubeless"
  version    = "${var.kubeless_version}"
  namespace  = "kubeless"

  set {
    name  = "rbac.create"
    value = "true"
  }
}

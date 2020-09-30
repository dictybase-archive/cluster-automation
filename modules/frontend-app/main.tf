## frontend web apps
resource "helm_release" "dicty-stock-center" {
  name       = "dicty-stock-center"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dicty-stock-center"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/dicty-stock-center/${var.env}.yaml"
  ]
}

resource "helm_release" "dicty-frontpage" {
  name       = "dicty-frontpage"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dicty-frontpage"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/dicty-frontpage/${var.env}.yaml"
  ]
}

resource "helm_release" "genomepage" {
  name       = "genomepage"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "genomepage"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/genomepage/${var.env}.yaml"
  ]
}

resource "helm_release" "dictyaccess" {
  name       = "dictyaccess"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dictyaccess"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/dictyaccess/${var.env}.yaml"
  ]
}

resource "helm_release" "publication" {
  name       = "publication"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "publication"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/publication/${var.env}.yaml"
  ]
}

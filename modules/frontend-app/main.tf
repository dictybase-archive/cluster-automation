data "helm_repository" "dictybase" {
  name = "dictybase"
  url = "https://dictybase-docker.github.io/kubernetes-charts"
}

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

## -- postgres schema loaders
resource "helm_release" "dictycontent-schema" {
  name       = "dictycontent-schema"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dictycontent-schema"
  namespace  = "dictybase"
  version    = var.dictycontent_schema_version
}

resource "helm_release" "dictyuser-schema" {
  name       = "dictyuser-schema"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dictyuser-schema"
  namespace  = "dictybase"
  version    = var.dictyuser_schema_version
}

resource "helm_release" "arango-create-database" {
  name       = "arango-create-database"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "arango-create-database"
  namespace  = "dictybase"
  values     = ["${var.config_path}/arango-createdb/${var.env}.yaml"]
}

## api services

##
## need authserver here
## authserver requires values set from the command line
## publicKey, privateKey, configFile
##

resource "helm_release" "content-api-server" {
  name       = "content-api-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "content-api-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/content-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "user-api-server" {
  name       = "user-api-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "user-api-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/user-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "identity-api-server" {
  name       = "identity-api-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "identity-api-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/identity-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "order-api-server" {
  name       = "order-api-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "order-api-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/order-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "stock-api-server" {
  name       = "stock-api-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "stock-api-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/stock-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "annotation-api-server" {
  name       = "annotation-api-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "annotation-api-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/annotation-api-server/${var.env}.yaml"
  ]
}


## -- graphql server
resource "helm_release" "graphql-server" {
  name       = "graphql-server"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "graphql-server"
  namespace  = "dictybase"
  values = [
    "${var.config_path}/graphql-api-server/${var.env}.yaml"
  ]
}


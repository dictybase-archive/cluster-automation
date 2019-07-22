data "helm_repository" "dictybase" {
  name = "dictybase"
  url  = "https://dictybase-docker.github.io/kubernetes-charts"
}

## -- postgres schema loaders
resource "helm_release" "dictycontent-schema" {
  name      = "dictycontent-schema"
  chart     = "dictybase/dictycontent-schema"
  namespace = "dictybase"
  version   = "${var.dictycontent_schema_version}"
}

resource "helm_release" "dictyuser-schema" {
  name      = "dictyuser-schema"
  chart     = "dictybase/dictyuser-schema"
  namespace = "dictybase"
  version   = "${var.dictyuser_schema_version}"
}

resource "helm_release" "arango-create-database" {
  name      = "arango-create-database"
  chart     = "dictybase/arango-create-database"
  namespace = "dictybase"
  values    = ["${var.config_path}/arango-createdb/${var.env}.yaml"]
}

## api services

##
## need authserver here
## authserver requires values set from the command line
## publicKey, privateKey, configFile
##

resource "helm_release" "content-api-server" {
  name      = "content-api-server"
  chart     = "dictybase/content-api-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/content-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "user-api-server" {
  name      = "user-api-server"
  chart     = "dictybase/user-api-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/user-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "identity-api-server" {
  name      = "identity-api-server"
  chart     = "dictybase/identity-api-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/identity-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "order-api-server" {
  name      = "order-api-server"
  chart     = "dictybase/order-api-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/order-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "stock-api-server" {
  name      = "stock-api-server"
  chart     = "dictybase/stock-api-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/stock-api-server/${var.env}.yaml"
  ]
}

resource "helm_release" "annotation-api-server" {
  name      = "annotation-api-server"
  chart     = "dictybase/annotation-api-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/annotation-api-server/${var.env}.yaml"
  ]
}


## -- graphql server
resource "helm_release" "graphql-server" {
  name      = "graphql-server"
  chart     = "dictybase/graphql-server"
  namespace = "dictybase"
  values = [
    "${var.config_path}/graphql-api-server/${var.env}.yaml"
  ]
}


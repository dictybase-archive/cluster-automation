data "local_file" "minio_config" {
  filename = "${var.minio_config_path}"
}

locals = {
  minio_data = yamldecode("${data.local_file.minio_config.content}")
}

data "local_file" "argo_config" {
  filename = "${var.argo_config_path}"
}

locals = {
  argo_data = yamldecode("${data.local_file.argo_config.content}")
}

resource "random_string" "webhook_secret" {
  length  = 16
  special = false
}

locals {
  webhook_secret = "${random_string.webhook_secret.result}"
}


resource "null_resource" "argo_namespace" {
  provisioner "local_exec" {
    command = "create ns ${var.argo_namespace}"
    interpreter = "kubectl"
  }
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


resource "kubernetes_secret" "minio-secret" {
  metadata {
    name = "${var.minio_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    accessKey = local.minio_data.accessKey
    secretKey = local.minio_data.secretKey
  }
}

resource "kubernetes_secret" "docker-secret" {
  metadata {
    name = "${var.docker_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "config.json" = file("${var.docker_config_path}")
  }
}

resource "kubernetes_secret" "slack-secret" {
  metadata {
    name = "${var.slack_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "oauth-token" = "${var.slack_secret_data}"
  }
}

resource "kubernetes_secret" "slack-secret" {
  metadata {
    name = "${var.slack_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "oauth-token" = "${var.slack_secret_data}"
  }
}

resource "kubernetes_secret" "github-secret" {
  metadata {
    name = "${var.github_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "apiToken" = trimspace("${data.local_file.github_access_token.content}")
    "webHookSecret" = local.webhook_secret
  }
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

resource "github_repository_webhook" "dictybase" {
  count = length("${var.github_repositories}") 
  repository = "${var.github_repositories[count.index]}"
  configuration {
    url = local.argo_data.eventSource.hookURL + "/github/${var.github_repositories[count.index]}"
    content_type = "json" 
    insecure_ssl = false
    secret = local.webhook_secret
  }
  events = ["push"]
}


resource "helm_release" "argo_events" {
  name = "argo-events"
  chart = "argo/argo-events"
  namespace = "${var.argo_namespace}"
  version = "${var.argo_events_version}"
  set {
    name = "namespace"
    value = "${var.argo_namespace}"
  }
}

resource "kubernetes_service_account" "argo_workflow" {
  metadata {
    name = "${var.argo_service_account}"
    namespace = "${var.argo_namespace}"
  }
}

resource "kubernetes_role" "argo_workflow_role" {
  metadata {
    name = "${var.argo_service_account}-role"
    namespace = "${var.argo_namespace}"
  }
  rule {
    api_groups = [""]
    resources = ["pods","pods/exec"]
    verbs = [
      "create",
      "get",
      "list",
      "watch",
      "update",
      "patch",
      "delete",
    ]
  }
  rule {
    api_groups = [""]
    resources = ["configmaps"]
    verbs = ["get","watch","list"]
  }
  rule {
    api_groups = [""]
    resources = ["persistentvolumeclaims"]
    verbs = ["create","delete"]
  }
  rule {
    api_groups = [""]
    resources = ["secrets"]
    verbs = ["create","get","watch","list"]
  }
  rule {
    api_groups = ["argoproj.io"]
    resources = ["workflows","workflows/finalizers"]
    verbs = [
      "get",
      "list",
      "watch",
      "update",
      "patch",
      "delete",
    ]
  }
}

resource "kubernetes_role_binding" "argo-role-binding" {
  metadata {
    name = "${var.argo_service_account}-binding"
    namespace = "${var.argo_namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io" 
    kind = "Role"
    name = "${var.argo_service_account}-role"
  }
  subject {
    kind = "ServiceAccount"
    name = "${var.argo_service_account}"
  }
}


resource "helm_release" "argo-workflow" {
  name = "argo-workflow"
  chart = "argo/argo"
  namespace = "${var.argo_namespace}"
  version = "${var.argo_workflow_version}"
  values = [
    "${var.config_path}/argo-workflow/${var.env}.yaml"
  ]
  set {
    name = "hooks"
    value  = [ for u in "${github_repository_webhook.dictybase-docker[*].url}" : {
      repo = element(split("/",u), 4)
      id   = element(split("/",u), 7)
    }]
  }
}

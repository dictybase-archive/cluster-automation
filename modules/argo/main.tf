data "helm_repository" "argo" {
  name = "argo"
  url  = "https://argoproj.github.io/argo-helm"
}

data "helm_repository" "dictybase" {
  name = "dictybase"
  url  = "https://dictybase-docker.github.io/kubernetes-charts"
}

data "local_file" "minio_config" {
  filename = "${var.config_path}/minio/${var.env}.yaml"
}

data "local_file" "argo_config" {
  filename = "${var.config_path}/argo-pipeline/${var.env}.yaml"
}

data "local_file" "github_token" {
  filename = pathexpand("${var.github_token_path}")
}

locals {
  minio_data        = yamldecode("${data.local_file.minio_config.content}")
  argo_data         = yamldecode("${data.local_file.argo_config.content}")
  webhook_secret    = "${random_string.webhook_secret.result}"
  github_token_data = trimspace("${data.local_file.github_token.content}")
}

resource "random_string" "webhook_secret" {
  length  = 16
  special = false
}

resource "null_resource" "argo-namespace" {
  provisioner "local-exec" {
    command = "kubectl create ns ${var.argo_namespace}"
  }
}

resource "kubernetes_secret" "minio-secret" {
  metadata {
    name      = "${var.minio_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    accessKey = local.minio_data.accessKey
    secretKey = local.minio_data.secretKey
  }
}

resource "kubernetes_secret" "docker-secret" {
  metadata {
    name      = "${var.docker_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "config.json" = file(pathexpand("${var.docker_config_path}"))
  }
}

resource "kubernetes_secret" "slack-secret" {
  metadata {
    name      = "${var.slack_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "oauth-token" = "${var.slack_secret_data}"
  }
}

resource "kubernetes_secret" "github-secret" {
  metadata {
    name      = "${var.github_secret}"
    namespace = "${var.argo_namespace}"
  }
  data = {
    "apiToken"      = local.github_token_data
    "webHookSecret" = local.webhook_secret
  }
}


resource "github_repository_webhook" "dictybase" {
  count      = length("${var.github_repositories}")
  repository = "${var.github_repositories[count.index]}"
  configuration {
    url          = local.argo_data.eventSource.hookURL + "/github/${var.github_repositories[count.index]}"
    content_type = "json"
    insecure_ssl = false
    secret       = local.webhook_secret
  }
  events = ["push"]
}


resource "helm_release" "argo-events" {
  name      = "argo-events"
  chart     = "argo/argo-events"
  namespace = "${var.argo_namespace}"
  version   = "${var.argo_events_version}"
  set {
    name  = "namespace"
    value = "${var.argo_namespace}"
  }
}

resource "kubernetes_service_account" "argo-workflow" {
  metadata {
    name      = "${var.argo_service_account}"
    namespace = "${var.argo_namespace}"
  }
}

resource "kubernetes_role" "argo-workflow-role" {
  metadata {
    name      = "${var.argo_service_account}-role"
    namespace = "${var.argo_namespace}"
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "pods/exec"]
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
    resources  = ["configmaps"]
    verbs      = ["get", "watch", "list"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["create", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create", "get", "watch", "list"]
  }
  rule {
    api_groups = ["argoproj.io"]
    resources  = ["workflows", "workflows/finalizers"]
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
    name      = "${var.argo_service_account}-binding"
    namespace = "${var.argo_namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.argo_service_account}-role"
  }
  subject {
    kind = "ServiceAccount"
    name = "${var.argo_service_account}"
  }
}

resource "helm_release" "argo-workflow" {
  name      = "argo-workflow"
  chart     = "argo/argo"
  namespace = "${var.argo_namespace}"
  version   = "${var.argo_workflow_version}"
  values = [
    "${var.config_path}/argo-workflow/${var.env}.yaml"
  ]
}

resource "helm_release" "argo-github-pipeline" {
  name      = "argo-github-pipeline"
  chart     = "dictybase/argo-pipeline"
  namespace = "${var.argo_namespace}"
  version   = "${var.argo_github_pipeline_version}"
  values = [
    "${var.config_path}/argo-github-pipeline/${var.env}.yaml"
  ]
  set {
    name = "hooks"
    value = [for u in "${github_repository_webhook.dictybase[*].url}" : {
      repo = element(split("/", u), 4)
      id   = element(split("/", u), 7)
    }]
  }
}

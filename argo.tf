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

resource "helm_release" "github-ingress" {
  name = "github-gateway-ingress"
  chart = "dictybase/dictybase-ingress"
  namespace = "${var.argo_namespace}"
  version = "${var.dictybase_ingress_version}"
  values = [
    "${var.config_path}/argo-ingress/${var.env}.yaml"
  ]
}

resource "github_repository_webhook" "frontend" {
  count = length("${var.github_repositories}") 
  repository = "${var.github_repositories[count.index]}"
  configuration {
    url = local.argo_data.eventSource.hookURL + "/github/${var.github_repositories[count.index]}"
    content_type = "json" 
    insecure_ssl = false
    secret = "${var.webhook_secret}"
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

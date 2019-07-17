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

locals = {
  minio_data = yamlencode(file("${var.config_path}/minio/${var.env}.yaml"))
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

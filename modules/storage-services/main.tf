## -- nats clusterrolebinding
resource "kubernetes_cluster_role_binding" "nats" {
  metadata {
    name = "default"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "dictybase"
  }
}

## -- ssd based storage class
resource "kubernetes_storage_class" "fast" {
  metadata {
    name = "fast"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  parameters = {
    type = "pd-standard"
    zone = "us-central1-a"
  }
}

## -- nats charts
resource "helm_release" "nats-operator" {
  name       = "nats-operator"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "nats-operator"
  namespace  = "dictybase"
  version    = var.nats_operator_version
}

resource "helm_release" "nats" {
  name       = "nats"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "nats"
  namespace  = "dictybase"
  version    = var.nats_version
}

## -- redis
resource "helm_release" "redis" {
  name       = "redis"
  repository = "http://storage.googleapis.com/kubernetes-charts"
  chart      = "redis"
  version    = var.redis_version
  namespace  = "dictybase"
  values     = ["${var.config_path}/redis/${var.env}.yaml"]
}

## - postgres
resource "helm_release" "dictycontent-postgres" {
  name       = "dictycontent-postgres"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "dictycontent-postgres"
  namespace  = "dictybase"
  version    = var.dictycontent_postgres_version
  values     = ["${var.config_path}/dictycontent-postgres/${var.env}.yaml"]
}

## minio
resource "helm_release" "minio" {
  name       = "minio"
  repository = "http://storage.googleapis.com/kubernetes-charts"
  chart      = "minio"
  namespace  = "dictybase"
  version    = var.minio_version
  values     = ["${var.config_path}/minio/${var.env}.yaml"]
}

## -- arangodb charts
resource "helm_release" "kube-arangodb-crd" {
  name  = "kube-arangodb-crd"
  chart = "https://github.com/arangodb/kube-arangodb/releases/download/${var.arango_chart_version}/kube-arangodb-crd.tgz"
}

resource "helm_release" "kube-arangodb" {
  name      = "kube-arangodb"
  chart     = "https://github.com/arangodb/kube-arangodb/releases/download/${var.arango_chart_version}/kube-arangodb.tgz"
  namespace = "dictybase"

  set {
    name  = "DeploymentReplication.Create"
    value = "false"
  }
}

resource "helm_release" "dictybase-arangodb" {
  name       = "dictybase-arangodb"
  repository = "https://dictybase-docker.github.io/kubernetes-charts"
  chart      = "arangodb"
  namespace  = "dictybase"
  version    = var.dictybase_arangodb_version
  set {
    name  = "arangodb.dbservers.storageClass"
    value = "fast"
  }

  set {
    name  = "arangodb.single.storage"
    value = var.arangodb_storage_size
  }
}

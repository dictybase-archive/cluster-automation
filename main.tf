## -- cluster admin
resource "kubernetes_cluster_role_binding" "cluster_admin" {
  metadata {
    name = "dictyadmin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = "${var.gcloud_account}"
    api_group = "rbac.authorization.k8s.io"
  }
}

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

resource "helm_release" "nats-operator" {
  name = "nats-operator"
  chart = "dictybase/nats-operator"
  namespace = "dictybase"
  version = "${var.nats_operator_version}"
}

resource "helm_release" "nats" {
  name = "nats"
  chart = "dictybase/nats"
  namespace = "dictybase"
  version = "${var.nats_version}"
}

## -- need to install kubeless here

resource "helm_release" "redis" {
  name = "redis"
  chart = "stable/redis"
  namespace = "dictybase"
  version =  "${var.redis_version}"
}

resource "helm_release" "dictycontent-postgres" {
  name = "dictycontent-postgres"
  chart = "dictybase/dictycontent-postgres"
  namespace = "dictybase"
  version = "${var.dictycontent_postgres_version}"
  values = [
    "${file("dictycontent-postgres.yaml")}"
  ]
}

resource "helm_release" "dictycontent-schema" {
  name = "dictycontent-schema"
  chart = "dictybase/dictycontent-schema"
  namespace = "dictybase"
  version = "${var.dictycontent_schema_version}"
}

resource "helm_release" "dictyuser-schema" {
  name = "dictyuser-schema"
  chart = "dictybase/dictyuser-schema"
  namespace = "dictybase"
  version = "${var.dictyuser_schema_version}"
}

## -- nginx ingress controller
resource "helm_release" "nginx-ingress" {
  name = "nginx-ingress"
  chart = "stable/nginx-ingress"
  version =  "${var.nginx_ingress_version}"
}

## -- cert-manager for lets encrypt based https access
resource "null_resource" "cert-manager" {
  provisioner "local-exec" {
    command = "apply -f https://githubusercontent.com/jetstack/cert-manager/${var.cert_manager_version}/deploy/manifests/00-crds.yaml"
    interpreter = "kubectl"
  }
  provisioner "local-exec" {
    command = "create ns cert-manager"
    interpreter = "kubectl"
  }
  provisioner "local-exec" {
    command = "label namespace cert-manager certmanager.k8s.io/disable-validation=true"
    interpreter = "kubectl"
  }
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"
  chart = "jetstack/cert-manager"
  version =  "${var.cert_manager_version}"
  namespace = "cert-manager"
}

resource "helm_release" "dicty-issuer-certificate" {
  name = "dicty-issuer-certificate"
  chart = "dictybase/issuer-certificate"
  namespace = "dictybase"
  version = "${var.issuer_certificate_version}"
  values = [
    "${file("dicty-issuer-certificate.yaml")}"
  ]  
}

resource "helm_release" "dictybase-auth-ingress" {
  name = "dictybase-auth-ingress"
  chart = "dictybase/dictybase-ingress"
  namespace = "dictybase"
  version = "${var.dictybase_ingress_version}"
  values = [
    "${file("dictybase-auth-ingress.yaml")}"
  ]  
}

resource "helm_release" "dictybase-ingress" {
  name = "dictybase-ingress"
  chart = "dictybase/dictybase-ingress"
  namespace = "dictybase"
  version = "${var.dictybase_ingress_version}"
  values = [
    "${file("dictybase-ingress.yaml")}"
  ]  
}

## minio goes here

resource "helm_release" "kube-arangodb-crd" {
  name = "kube-arangodb-crd"
  chart = "https://github.com/arangodb/kube-arangodb/releases/download/0.3.11/kube-arangodb-crd.tgz"
}

resource "helm_release" "kube-arangodb" {
  name = "kube-arangodb"
  chart = "https://github.com/arangodb/kube-arangodb/releases/download/0.3.11/kube-arangodb.tgz"
  namespace = "dictybase"

  set {
    name = "DeploymentReplication.Create"
    value = "false"
  }
}

resource "helm_release" "dictybase-arangodb" {
  name = "dictybase-arangodb"
  chart = "dictybase/arangodb"
  namespace = "dictybase"
  version = "${var.dictybase_arangodb_version}"
  set {
    name = "arangodb.dbservers.storageClass"
    value = "fast"
  }

  set {
    name = "arangodb.single.storage"
    value = "50Gi"
  }
}

resource "helm_release" "arango-create-database" {
  name = "arango-create-database"
  chart = "dictybase/arango-create-database"
  namespace = "dictybase"
  version = "${var.dictybase_arango_create_db_version}"
  values = [
    "${file("arango-create-database.yaml")}"
  ]    
}

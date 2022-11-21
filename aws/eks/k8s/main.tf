resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

resource "helm_release" "nginx_ingress" {
  namespace = kubernetes_namespace.test.metadata.0.name
  wait      = true
  timeout   = 600

  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "v3.30.0"
}
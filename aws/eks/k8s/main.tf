resource "local_file" "kubeconfig" {
  sensitive_content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = var.cluster_name,
    clusterca    = data.aws_eks_cluster.default.certificate_authority[0].data,
    endpoint     = data.aws_eks_cluster.default.endpoint,
  })
  filename = "./kubeconfig-${var.cluster_name}"
}

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
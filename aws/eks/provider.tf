provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = join("", aws_eks_cluster.eks.*.endpoint)
  cluster_ca_certificate = local.ca_data
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws-iam-authenticator"

    args = [
      "token",
      "-i",
      var.aws_eks_cluster_name,
    ]

    env = {
      AWS_ACCESS_KEY_ID     = var.aws_access_key
      AWS_SECRET_ACCESS_KEY = var.aws_secret_key
    }
  }
}
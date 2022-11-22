resource "aws_iam_role" "k8s-cluster" {
  name               = var.aws_eks_cluster_name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "k8s-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.k8s-cluster.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "k8s-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.k8s-cluster.name
}

resource "aws_iam_role" "k8s-node" {
  name = "${var.aws_eks_cluster_name}-node"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "k8s-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.k8s-node.name
}

resource "aws_iam_role_policy_attachment" "k8s-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.k8s-node.name
}

resource "aws_iam_role_policy_attachment" "k8s-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.k8s-node.name
}

module "aws_vpc" {
  source             = "../vpc"
  aws_az_name        = var.aws_az_name
  aws_owner          = var.owner
  aws_region         = var.aws_region
  aws_vpc_cidr_block = var.aws_vpc_cidr_block
  aws_vpc_name       = format("%s-vpc", var.aws_eks_cluster_name)
  custom_tags        = merge({
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "shared"
  }, var.custom_tags)
}

module "aws_subnets" {
  source          = "../subnet"
  aws_vpc_id      = module.aws_vpc.aws_vpc["id"]
  aws_vpc_subnets = [
    {
      name                    = format("%s-snet-a", var.aws_eks_cluster_name)
      owner                   = var.owner
      map_public_ip_on_launch = true
      cidr_block              = var.aws_vpc_subnet_a
      availability_zone       = format("%s%s", var.aws_region, var.aws_az_a)
      custom_tags             = merge({
        "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "shared"
        "kubernetes.io/role/elb"                            = 1
      }, var.custom_tags)
    },
    {
      name                    = format("%s-snet-b", var.aws_eks_cluster_name)
      owner                   = var.owner
      map_public_ip_on_launch = true
      cidr_block              = var.aws_vpc_subnet_b
      availability_zone       = format("%s%s", var.aws_region, var.aws_az_b)
      custom_tags             = merge({
        "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "shared"
        "kubernetes.io/role/elb"                            = 1
      }, var.custom_tags)
    }
  ]
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = module.aws_vpc.aws_vpc["id"]
  tags   = {
    Name = format("%s-igw", var.aws_eks_cluster_name)
  }
}

resource "aws_route_table" "k8s" {
  vpc_id = module.aws_vpc.aws_vpc["id"]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }
}

resource "aws_route_table_association" "k8s" {
  for_each       = {for k, v in module.aws_subnets.aws_subnets : k => v}
  subnet_id      = each.value.id
  route_table_id = aws_route_table.k8s.id
}

resource "aws_eks_cluster" "eks" {
  name     = var.aws_eks_cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.k8s-cluster.arn
  vpc_config {
    subnet_ids = [for s in module.aws_subnets.aws_subnets: s["id"]]
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.k8s-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.aws_eks_cluster_name
  node_role_arn   = aws_iam_role.k8s-node.arn
  subnet_ids      = [for s in module.aws_subnets.aws_subnets: s["id"]]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.k8s-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.k8s-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.k8s-AmazonEC2ContainerRegistryReadOnly,
  ]
}
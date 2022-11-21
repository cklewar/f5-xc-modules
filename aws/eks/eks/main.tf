resource "aws_iam_role" "k8s-cluster" {
  name = var.aws_eks_cluster_name

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

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    "Name"                                              = "terraform-eks-k8s-node"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "shared"
  }
}

resource "aws_subnet" "k8s" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    "Name"                                              = "terraform-eks-k8s-node"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                            = 1
  }
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-eks-k8s"
  }
}

resource "aws_route_table" "k8s" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }
}

resource "aws_route_table_association" "k8s" {
  count = 2

  subnet_id      = aws_subnet.k8s[count.index].id
  route_table_id = aws_route_table.k8s.id
}

resource "aws_eks_cluster" "k8s" {
  name     = var.aws_eks_cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.k8s-cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.k8s.*.id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.k8s-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "k8s" {
  cluster_name    = aws_eks_cluster.k8s.name
  node_group_name = var.aws_eks_cluster_name
  node_role_arn   = aws_iam_role.k8s-node.arn
  subnet_ids      = aws_subnet.k8s.*.id

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
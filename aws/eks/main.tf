resource "aws_iam_role" "eks_cluster" {
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

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = join("", aws_iam_role.eks_cluster.*.name)
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = join("", aws_iam_role.eks_cluster.*.name)
}

resource "aws_iam_role" "eks_node" {
  name = local.aws_eks_node_iam_role_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = join("", aws_iam_role.eks_node.*.name)
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = join("", aws_iam_role.eks_node.*.name)
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = join("", aws_iam_role.eks_node.*.name)
}

resource "aws_iam_instance_profile" "eks_node" {
  name = local.aws_eks_node_iam_instance_profile_name
  role = join("", aws_iam_role.eks_node.*.name)
}

resource "aws_security_group" "eks_cluster" {
  name        = local.aws_eks_cluster_security_group_name
  description = "Communication between the control plane and worker node groups"
  vpc_id      = var.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = local.aws_eks_cluster_security_group_name
    iam_owner = var.iam_owner
  }
}

resource "aws_security_group" "eks_node" {
  name        = local.aws_eks_node_security_group_name
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                              = "eks-node-${var.aws_eks_cluster_name}"
    "kubernetes.io/cluster/${var.aws_eks_cluster_name}" = "owned"
    "iam_owner"                                         = var.iam_owner
  }
}

resource "aws_security_group_rule" "eks_luster_ingress_workstation_https" {
  cidr_blocks       = ["104.219.109.84/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "eks_node_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_node_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_node.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_eks_cluster" "eks" {
  name     = var.aws_eks_cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id]
    subnet_ids              = var.aws_subnet_ids
    endpoint_private_access = var.aws_endpoint_private_access
    endpoint_public_access  = var.aws_endpoint_public_access
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
  ]
}

resource "kubernetes_config_map" "eks_aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOF
    - rolearn: ${aws_iam_role.eks_node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF
  }
}

resource "kubernetes_storage_class" "eks_default_storage_class" {
  metadata {
    name = "default"
  }

  parameters = {
    fsType = "ext4"
    type   = "gp2"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
}

resource "aws_launch_configuration" "eks" {
  associate_public_ip_address = var.aws_disable_public_ip ? false : true
  iam_instance_profile        = aws_iam_instance_profile.eks_node.name
  image_id                    = data.aws_ami.eks_worker.id
  instance_type               = "m4.large"
  name_prefix                 = "eks-node-${var.aws_eks_cluster_name}"
  security_groups             = [aws_security_group.eks_node.id]
  user_data_base64            = base64encode(local.node_userdata)
  # key_name                    = "${var.aws_eks_cluster_name}-key"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks" {
  desired_capacity     = var.aws_eks_worker_vm_count
  launch_configuration = aws_launch_configuration.eks.id
  max_size             = var.aws_eks_worker_vm_count
  min_size             = 1
  name                 = "eks-autoscale-group-${var.aws_eks_cluster_name}"
  vpc_zone_identifier  = var.aws_vpc_zone_identifier

  tag {
    key                 = "Name"
    value               = var.aws_eks_cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.aws_eks_cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "iam_owner"
    value               = var.iam_owner
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
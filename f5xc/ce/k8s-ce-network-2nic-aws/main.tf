resource "aws_route53_zone" "volterra_zone" {
  name = var.dns_zone_name == "" ? join(".", [var.deployment, var.dns_zone_suffix]) : var.dns_zone_name
  tags = local.common_tags

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_internet_gateway" "volterra_gw" {
  vpc_id = var.vpc_id
  tags   = local.common_tags
}

data "aws_vpc" "volterra_vpc" {
  id = var.vpc_id
}

resource "aws_route" "volterra_gw_route_ipv4" {
  route_table_id         = data.aws_vpc.volterra_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.volterra_gw.id
}

resource "aws_route" "volterra_gw_route_ipv6" {
  route_table_id              = data.aws_vpc.volterra_vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.volterra_gw.id
}

resource "aws_route_table" "volterra_inside_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.ce_inside_intf_id
  }

  route {
    ipv6_cidr_block      = "::/0"
    network_interface_id = var.ce_inside_intf_id
  }

  tags = local.common_tags
  lifecycle {
    ignore_changes = [
      tags, route
    ]
  }
}

resource "aws_subnet" "volterra_subnet_private" {
  vpc_id            = var.vpc_id
  cidr_block        = var.fabric_subnet_private
  availability_zone = data.aws_availability_zones.available_az.names[0]
  tags              = local.common_tags
}

resource "aws_subnet" "volterra_subnet_inside" {
  vpc_id            = var.vpc_id
  cidr_block        = var.fabric_subnet_inside
  availability_zone = data.aws_availability_zones.available_az.names[0]
  tags              = local.common_tags
}

resource "aws_security_group" "volterra_security_group" {
  name        = "volterra-security-group"
  description = "Allow SSH, ICMP, VER"
  vpc_id      = var.vpc_id
  tags        = local.common_tags
  depends_on  = [aws_internet_gateway.volterra_gw]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "4500"
    to_port     = "4500"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "nlb" {
  name                             = "${var.deployment}-nlb"
  load_balancer_type               = "network"
  internal                         = true
  subnets                          = [aws_subnet.volterra_subnet_private.id]
  enable_cross_zone_load_balancing = true
  tags                             = local.common_tags
}

# Forward TCP apiserver traffic to controllers
resource "aws_lb_listener" "apiserver-https" {
  load_balancer_arn = aws_lb.nlb.arn
  protocol          = "TCP"
  port              = "6443"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers.arn
  }
}

resource "aws_lb_target_group" "controllers" {
  name        = "${var.deployment}-lb-ctl"
  vpc_id      = var.vpc_id
  target_type = "instance"

  protocol = "TCP"
  port     = 6443

  health_check {
    protocol            = "TCP"
    port                = 6443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
}

resource "aws_iam_role" "role" {
  name = "role-${var.deployment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "policy" {
  name = "policy-${var.deployment}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeInstances",
                "ec2:DescribeRegions",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVolumes",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifyVolume",
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateRoute",
                "ec2:DeleteRoute",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteVolume",
                "ec2:DetachVolume",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:DescribeVpcs",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:AttachLoadBalancerToSubnets",
                "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:CreateLoadBalancerPolicy",
                "elasticloadbalancing:CreateLoadBalancerListeners",
                "elasticloadbalancing:ConfigureHealthCheck",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:DeleteLoadBalancerListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "elasticloadbalancing:DetachLoadBalancerFromSubnets",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:CreateListener",
                "elasticloadbalancing:CreateTargetGroup",
                "elasticloadbalancing:DeleteListener",
                "elasticloadbalancing:DeleteTargetGroup",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:ModifyListener",
                "elasticloadbalancing:ModifyTargetGroup",
                "elasticloadbalancing:RegisterTargets",
                "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
                "iam:CreateServiceLinkedRole",
                "kms:DescribeKey"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
POLICY

}

resource "aws_iam_policy_attachment" "attachment" {
  name       = format("%s-attachment", var.deployment)
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.deployment}-profile"
  role = aws_iam_role.role.name
}
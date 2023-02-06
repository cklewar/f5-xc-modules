resource "aws_vpc" "vpc" {
  count                = var.aws_existing_vpc_id == "" ? 1 : 0
  cidr_block           = var.aws_vpc_subnet_prefix
  enable_dns_support   = var.aws_vpc_enable_dns_support
  enable_dns_hostnames = var.aws_vp_enable_dns_hostnames
  tags                 = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  tags   = local.common_tags
}

resource "aws_route" "route_ipv4" {
  route_table_id         = data.aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "route_ipv6" {
  route_table_id              = data.aws_vpc.vpc.main_route_table_id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}

resource "aws_subnet" "slo" {
  for_each          = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v if contains(keys(v), "f5xc_aws_vpc_slo_subnet")}
  vpc_id            = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  cidr_block        = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_slo_subnet"]
  availability_zone = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_az_name"]
  tags              = local.common_tags
}

resource "aws_subnet" "sli" {
  for_each          = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v if var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress && contains(keys(var.f5xc_aws_vpc_az_nodes), "f5xc_aws_vpc_sli_subnet")}
  vpc_id            = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  cidr_block        = each.value["f5xc_aws_vpc_sli_subnet"]
  availability_zone = var.f5xc_aws_vpc_az_nodes[each.key]["f5xc_aws_vpc_az_name"]
  tags              = local.common_tags
}

resource "aws_eip" "nat_gw_eip" {
  count = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc   = var.aws_eip_vpc
  tags  = local.common_tags
}

resource "aws_nat_gateway" "ngw" {
  count         = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  allocation_id = element(aws_eip.nat_gw_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.slo.*.id, count.index)
  tags          = local.common_tags
}

resource "aws_route_table" "sli" {
  count  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc_id = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "rta_sli_subnet" {
  count          = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? length(aws_route_table.sli) : 0
  subnet_id      = element(aws_subnet.sli.*.id, count.index)
  route_table_id = element(aws_route_table.sli.*.id, count.index)
}

module "aws_security_group_slo" {
  source                      = "../../../../aws/security_group"
  aws_vpc_id                  = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                 = local.common_tags
  aws_security_group_name     = format("%s-sg-slo", var.cluster_name)
  security_group_rule_egress  = var.aws_security_group_rule_slo_egress
  security_group_rule_ingress = var.aws_security_group_rule_slo_ingress
}

module "aws_security_group_sli" {
  source                      = "../../../../aws/security_group"
  aws_vpc_id                  = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  custom_tags                 = local.common_tags
  aws_security_group_name     = format("%s-sg-sli", var.cluster_name)
  security_group_rule_egress  = var.aws_security_group_rule_sli_egress
  security_group_rule_ingress = var.aws_security_group_rule_sli_ingress
}

/*resource "aws_lb" "nlb" {
  tags                             = local.common_tags
  name                             = "${var.cluster_name}-nlb"
  subnets                          = [for subnet in aws_subnet.slo : subnet.id]
  internal                         = true
  load_balancer_type               = var.aws_lb_type_nlb
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "api-server-https" {
  load_balancer_arn = aws_lb.nlb.arn
  protocol          = "TCP"
  port              = "6443"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers.arn
  }
}

resource "aws_lb_target_group" "controllers" {
  name        = "${var.cluster_name}-lb-ctl"
  vpc_id      = var.aws_existing_vpc_id != "" ? var.aws_existing_vpc_id : aws_vpc.vpc[0].id
  target_type = "instance"
  protocol    = "TCP"
  port        = 6443

  health_check {
    protocol            = "TCP"
    port                = 6443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }
}*/

resource "aws_iam_role" "role" {
  name               = "${var.cluster_name}-role"
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
  name   = "${var.cluster_name}-policy"
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

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.cluster_name}-profile"
  role = aws_iam_role.role.name
}
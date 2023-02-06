module "aws_security_group_slo" {
  source                      = "../../../../../aws/security_group"
  aws_vpc_id                  = var.aws_vpc_id
  custom_tags                 = local.common_tags
  aws_security_group_name     = format("%s-sg-slo", var.cluster_name)
  security_group_rule_egress  = var.aws_security_group_rule_slo_egress
  security_group_rule_ingress = var.aws_security_group_rule_slo_ingress
}

module "aws_security_group_sli" {
  source                      = "../../../../../aws/security_group"
  count                       = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  aws_vpc_id                  = var.aws_vpc_id
  custom_tags                 = local.common_tags
  aws_security_group_name     = format("%s-sg-sli", var.cluster_name)
  security_group_rule_egress  = var.aws_security_group_rule_sli_egress
  security_group_rule_ingress = var.aws_security_group_rule_sli_ingress
}

resource "aws_subnet" "slo" {
  # for_each          = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v if contains(keys(v), "f5xc_aws_vpc_slo_subnet")}
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_slo_cidr
  availability_zone = var.aws_vpc_az
  tags              = local.common_tags
}

resource "aws_subnet" "sli" {
  # for_each          = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v if var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress && contains(keys(var.f5xc_aws_vpc_az_nodes), "f5xc_aws_vpc_sli_subnet")}
  count             = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_sli_cidr
  availability_zone = var.aws_vpc_az
  tags              = local.common_tags
}

module "network_interface_slo" {
  source                          = "../../../../../aws/network_interface"
  # for_each                        = {for k, v in var.f5xc_aws_vpc_az_nodes : k=>v if contains(keys(v), "f5xc_aws_vpc_slo_subnet")}
  aws_interface_subnet_id         = aws_subnet.slo.id
  aws_interface_create_eip        = var.has_public_ip
  aws_interface_security_groups   = [module.aws_security_group_slo.aws_security_group["id"]]
  aws_interface_source_dest_check = false
}

module "network_interface_sli" {
  source                          = "../../../../../aws/network_interface"
  count                           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  aws_interface_subnet_id         = aws_subnet.sli.id
  aws_interface_create_eip        = false
  aws_interface_security_groups   = [module.aws_security_group_sli.aws_security_group["id"]]
  aws_interface_source_dest_check = false
}

resource "aws_eip" "nat_gw_eip" {
  count = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc   = var.aws_eip_vpc
  tags  = local.common_tags
}

resource "aws_nat_gateway" "ngw" {
  count         = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  allocation_id = aws_eip.nat_gw_eip.*.id
  subnet_id     = aws_subnet.slo.*.id
  tags          = local.common_tags
}

resource "aws_route_table" "sli" {
  count  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc_id = var.aws_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "rta_sli_subnet" {
  count          = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? length(aws_route_table.sli) : 0
  subnet_id      = aws_subnet.sli.*.id
  route_table_id = aws_route_table.sli.*.id
}

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
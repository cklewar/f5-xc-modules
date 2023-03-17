locals {
  # is_slo_snet_same_az = length([for node in var.f5xc_aws_vpc_az_nodes : node["f5xc_aws_vpc_az_name"]]) != length(distinct([for node in var.f5xc_aws_vpc_az_nodes : node["f5xc_aws_vpc_az_name"]])) ? true : false
  f5xc_ip_ranges_americas = concat(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP)
  f5xc_ip_ranges_europe   = concat(var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP)
  f5xc_ip_ranges_asia     = concat(var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_ip_ranges_all      = concat(local.f5xc_ip_ranges_americas, concat(local.f5xc_ip_ranges_europe, local.f5xc_ip_ranges_asia))
  server_roles            = {
    node0 = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"]),
    node1 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"]),
    node2 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
  }
  common_tags = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
  }
  aws_security_group_rules_slo_egress_secure_ce = concat([
    {
      from_port   = "-1"
      to_port     = "-1"
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "4500"
      to_port     = "4500"
      protocol    = "udp"
      cidr_blocks = toset(local.f5xc_ip_ranges_all)
    },
    {
      from_port   = "123"
      to_port     = "123"
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = toset(local.f5xc_ip_ranges_all)
    },
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = toset(var.f5xc_ce_egress_ip_ranges)
    },
  ], var.aws_security_group_rules_slo_egress)

  aws_security_group_rules_slo_ingress_secure_ce = concat([
    {
      from_port   = "4500"
      to_port     = "4500"
      protocol    = "udp"
      cidr_blocks = toset(local.f5xc_ip_ranges_all)
    },
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ], var.aws_security_group_rules_slo_ingress)

  aws_security_group_rules_sli_egress_secure_ce = concat([
    {
      from_port   = "-1"
      to_port     = "-1"
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ], var.aws_security_group_rules_sli_egress)

  aws_security_group_rules_sli_ingress_secure_ce = concat([
    {
      from_port   = "22"
      to_port     = "22"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ], var.aws_security_group_rules_sli_ingress)
}
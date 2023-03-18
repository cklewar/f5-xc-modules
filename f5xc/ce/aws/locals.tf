locals {
  # is_slo_snet_same_az = length([for node in var.f5xc_aws_vpc_az_nodes : node["f5xc_aws_vpc_az_name"]]) != length(distinct([for node in var.f5xc_aws_vpc_az_nodes : node["f5xc_aws_vpc_az_name"]])) ? true : false
  is_multi_nic            = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  f5xc_ip_ranges_americas = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP)
  f5xc_ip_ranges_europe   = setunion(var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP)
  f5xc_ip_ranges_asia     = setunion(var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  f5xc_ip_ranges_all      = setunion(var.f5xc_ip_ranges_Americas_TCP, var.f5xc_ip_ranges_Americas_UDP, var.f5xc_ip_ranges_Europe_TCP, var.f5xc_ip_ranges_Europe_UDP, var.f5xc_ip_ranges_Asia_TCP, var.f5xc_ip_ranges_Asia_UDP)
  server_roles            = {
    node0 = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"]),
    node1 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"]),
    node2 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
  }
  common_tags = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
  }
  aws_security_group_rules_slo_egress_secure_ce = [
    {
      from_port   = "-1"
      to_port     = "-1"
      ip_protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "4500"
      to_port     = "4500"
      ip_protocol = "udp"
      cidr_blocks = local.f5xc_ip_ranges_all
    },
    {
      from_port   = "123"
      to_port     = "123"
      ip_protocol = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "443"
      to_port     = "443"
      ip_protocol = "tcp"
      cidr_blocks = local.f5xc_ip_ranges_all
    }
  ]

  aws_security_group_rules_slo_egress_secure_ce_extended = [
    {
      from_port   = "443"
      to_port     = "443"
      ip_protocol = "tcp"
      cidr_blocks = var.f5xc_ce_egress_ip_ranges
    }
  ]

  aws_security_group_rules_slo_ingress_secure_ce = [
    {
      from_port   = "4500"
      to_port     = "4500"
      ip_protocol = "udp"
      cidr_blocks = local.f5xc_ip_ranges_all
    },
    {
      from_port   = "22"
      to_port     = "22"
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  aws_security_group_rules_sli_egress_secure_ce = [
    {
      from_port   = "-1"
      to_port     = "-1"
      ip_protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = "22"
      to_port     = "22"
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  aws_security_group_rules_sli_ingress_secure_ce = [
    {
      from_port   = "22"
      to_port     = "22"
      ip_protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
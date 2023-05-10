resource "volterra_enhanced_firewall_policy" "efp" {
  name      = var.f5xc_enhanced_fw_policy_name
  namespace = var.f5xc_namespace

  rule_list {
    rules {
      metadata {
        name = "rule1"
      }
      source_prefix_list {
        prefixes = [element(var.f5xc_aws_vpc_prefixes, 0)]
      }
      destination_prefix_list {
        prefixes = [element(var.f5xc_aws_vpc_prefixes, 1)]
      }
      insert_service {
        nfv_service {
          name = var.f5xc_nfv_name
        }
      }
    }
  }
}

resource "volterra_enhanced_firewall_policy" "efp" {
  name      = var.f5xc_enhanced_fw_policy_name
  namespace = var.f5xc_namespace

  rule_list {
    dynamic "rules" {
      for_each = var.f5xc_enhanced_fw_policy_rules
      content {
        allow       = rules.value.allow
        all_sources = rules.value.all_source
        metadata {
          name = rules.value.metadata.name
        }
        applications {
          applications = rules.value.applications
        }
        insert_service {
          nfv_service {
            name = rules.value.insert_service != null ? rules.value.insert_service.nfv_service.name : ""
          }
        }
        source_aws_vpc_ids {
          vpc_id = rules.value.source_aws_vpc_ids
        }
        destination_aws_vpc_ids {
          vpc_id = rules.value.destination_aws_vpc_ids
        }
        source_prefix_list {
          prefixes = rules.value.source_prefix_list
        }
        destination_prefix_list {
          prefixes = rules.value.destination_prefix_list
        }
      }
    }
  }
}
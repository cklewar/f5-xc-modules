resource "volterra_enhanced_firewall_policy" "efp" {
  name      = var.f5xc_enhanced_fw_policy_name
  namespace = var.f5xc_namespace

  rule_list {
    dynamic "rules" {
      for_each = var.f5xc_enhanced_fw_policy_rules
      content {
        allow                   = rules.value.all_source
        metadata                = rules.value.metadata
        all_source              = rules.value.all_source
        applications            = rules.value.applications
        insert_service          = rules.value.insert_service
        source_aws_vpc_ids      = rules.value.source_aws_vpc_ids
        source_prefix_list      = rules.value.source_prefix_list
        destination_prefix_list = rules.value.destination_prefix_list
      }
    }
  }
}
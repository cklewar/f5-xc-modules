```hcl
module "update_site" {
  source              = "../../../../modules/utils/update"
  count               = length(local.site_names)
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_namespace      = var.f5xc_namespace
  f5xc_api_token      = var.f5xc_api_token
  f5xc_api_get_uri    = "config/namespaces/${var.f5xc_namespace}/aws_tgw_sites/${local.site_names[count.index]}"
  f5xc_api_update_uri = "config/namespaces/${var.f5xc_namespace}/aws_tgw_sites/${local.site_names[count.index]}"
  merge_key           = "tgw_security"
  del_key             = "no_forward_proxy"
  merge_data          = jsonencode({
    active_forward_proxy_policies = {
      forward_proxy_policies = [
        {
          name      = volterra_forward_proxy_policy.policy[count.index].name,
          tenant    = var.f5xc_tenant
          namespace = var.f5xc_namespace,
        }
      ]
    }
  })
}

output "merged" {
  value = module.update_site.*.data
}


module "update_no_del_key" {
  source              = "../modules/utils/update"
  del_key             = ""
  merge_key           = "tgw_security"
  merge_data          = local.payload
  f5xc_tenant         = var.f5xc_tenant
  f5xc_api_url        = var.f5xc_api_url
  f5xc_namespace      = var.namespace
  f5xc_api_token      = var.f5xc_api_token
  f5xc_api_get_uri    = "config/namespaces/system/aws_tgw_sites/${data.tfe_outputs.step1.values.site_name}"
  f5xc_api_update_uri = "config/namespaces/system/aws_tgw_sites/${data.tfe_outputs.step1.values.site_name}"
}

output "response" {
  value = module.update.*.data
}
```
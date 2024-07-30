locals {
  f5os_tenant    = var.is_sensitive ? sensitive(var.f5os_tenant) : var.f5os_tenant
  tenant_get_uri = format(var.f5os_tenant_get_uri, var.f5os_tenant)
  tenant_get_url = format("%s/%s?response_format=GET_RSP_FORMAT_DEFAULT", var.f5os_api_url, local.tenant_get_uri)
}

# Status
#curl -k -X GET  -H “Content-Type : application/yang-data+json” --data-binary “@/Users/m.sridhar/Downloads/tenant.create.api.data”  -H “Accept : application/yang-data+json” -u admin :ess-pwe-f5site02 ‘https : //192.168.4.13:8888/restconf/data/f5-tenants:tenants/tenant=sri-rseries-test-15’ | grep -i  status
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

data "http" "myip" {
  url = "http://ip4.clara.net/?raw"
}

module "global_run" {
  source  = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  tenant_id           = var.azure_tenant_id

  monitoring_function_storage_account_authorized_ips = ["${data.http.myip.body}/32"]
  monitoring_function_splunk_token                   = "xxxxxx"
  monitoring_function_metrics_extra_dimensions = {
    env           = var.environment
    sfx_monitored = "true"
  }

  extra_tags = {
    foo = "bar"
  }
}

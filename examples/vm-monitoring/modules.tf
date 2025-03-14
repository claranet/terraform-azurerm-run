module "vm_monitoring" {
  source  = "claranet/run/azurerm//modules/vm-monitoring"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  log_analytics_workspace_id = module.logs.id

  extra_tags = {
    foo = "bar"
  }
}

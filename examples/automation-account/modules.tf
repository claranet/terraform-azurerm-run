module "automation_account" {
  source  = "claranet/run/azurerm//modules/automation-account"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.name
  client_name         = var.client_name
  stack               = var.stack
  environment         = var.environment

  log_analytics_workspace_id = module.logs.id
  logs_destinations_ids      = [module.logs.id]

  extra_tags = {
    foo = "bar"
  }
}

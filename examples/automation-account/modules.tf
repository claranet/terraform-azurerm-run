module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure-region.location
  location_short = module.azure-region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
}

module "automation-account" {
  source  = "claranet/run-iaas/azurerm//modules/automation-account"
  version = "x.x.x"

  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  resource_group_name = module.rg.resource_group_name
  client_name         = var.client_name
  stack               = var.stack
  environment         = var.environment

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  extra_tags = {
    foo = "bar"
  }
}

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

module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  log_analytics_workspace_retention_in_days                  = 30
  logs_storage_account_enable_archiving                      = true
  tier_to_cool_after_days_since_modification_greater_than    = 30
  tier_to_archive_after_days_since_modification_greater_than = 60
  delete_after_days_since_modification_greater_than          = 700

  extra_tags = {
    foo = "bar"
  }
}

module "any_child_resource" {
  source  = "claranet/acr/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
  sku                 = "Standard"

  logs_destinations_ids = [
    # Logs will be archive in Storage Account
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

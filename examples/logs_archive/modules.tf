module "logs" {
  source  = "claranet/run/azurerm//modules/logs"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  workspace_retention_in_days       = 30
  storage_account_archiving_enabled = true

  tier_to_cool_after_days_since_modification_greater_than    = 30
  tier_to_archive_after_days_since_modification_greater_than = 60
  delete_after_days_since_modification_greater_than          = 700

  extra_tags = {
    foo = "bar"
  }
}

module "any_child_resource" {
  source  = "claranet/storage-account/azurerm"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.name

  account_replication_type = "LRS"

  logs_destinations_ids = [
    # Logs will be archive in Storage Account
    module.logs.storage_account_id,
    module.logs.id,
  ]

  extra_tags = {
    foo = "bar"
  }
}

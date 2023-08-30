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

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  monitoring_function_splunk_token = "xxxxxx"
  monitoring_function_metrics_extra_dimensions = {
    env           = var.environment
    sfx_monitored = "true"
  }

  # IaaS
  automation_account_enabled = true

  backup_vm_enabled           = true
  backup_managed_disk_enabled = true
  backup_file_share_enabled   = true
  backup_storage_blob_enabled = true

  update_center_enabled = true
  update_center_maintenance_configurations = [
    {
      configuration_name = "config1"
      start_date_time    = "2023-08-21 04:00"
      recur_every        = "1Day"
    },
    {
      configuration_name = "config2"
      start_date_time    = "1900-01-01 03:00"
      recur_every        = "1Week"
    }
  ]

  vm_monitoring_enabled = true

  extra_tags = {
    foo = "bar"
  }
}

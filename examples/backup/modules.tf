module "az_vm_backup" {
  source  = "claranet/run/azurerm//modules/backup"
  version = "x.x.x"

  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  backup_vm_enabled         = true
  backup_postgresql_enabled = true

  vm_backup_policy_time = "23:00"

  vm_backup_monthly_retention = {
    count    = 3
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  logs_destinations_ids = [module.logs.log_analytics_workspace_id]

  extra_tags = {
    foo = "bar"
  }
}

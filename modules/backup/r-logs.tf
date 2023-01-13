module "diagnostics" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 6.2.0"

  count = var.backup_vm_enabled || var.backup_file_share_enabled ? 1 : 0

  resource_id = azurerm_recovery_services_vault.vault[0].id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
  retention_days        = var.logs_retention_days

  use_caf_naming = var.use_caf_naming
  custom_name    = var.custom_diagnostic_settings_name
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
}

module "diagnostics_backup_vault" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 6.2.0"

  count = var.backup_postgresql_enabled || var.backup_managed_disk_enabled || var.backup_storage_blob_enabled ? 1 : 0

  resource_id = azurerm_data_protection_backup_vault.vault[0].id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories
  retention_days        = var.logs_retention_days

  use_caf_naming = var.use_caf_naming
  custom_name    = var.custom_diagnostic_settings_name
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
}

module "diagnostics" {
  source  = "claranet/diagnostic-settings/azurerm"
  version = "~> 7.0.0"

  count = var.backup_vm_enabled || var.backup_file_share_enabled ? 1 : 0

  resource_id = azurerm_recovery_services_vault.vault[0].id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  use_caf_naming = var.use_caf_naming
  custom_name    = var.custom_diagnostic_settings_name
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
}

moved {
  from = module.diagnostics
  to   = module.diagnostics[0]
}

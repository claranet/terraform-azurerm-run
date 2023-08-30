module "diagnostics" {
  # source  = "claranet/diagnostic-settings/azurerm"
  # version = "~> 6.4.1"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/diagnostic-settings.git?ref=AZ-1153_drop_retention_param"

  resource_id = azurerm_automation_account.automation_account.id

  logs_destinations_ids = var.logs_destinations_ids
  log_categories        = var.logs_categories
  metric_categories     = var.logs_metrics_categories

  use_caf_naming = var.use_caf_naming
  custom_name    = var.custom_diagnostic_settings_name
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
}

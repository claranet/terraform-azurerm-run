locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""

  base_name                      = "${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}"
  vault_default_name             = "${local.base_name}-recoveryvault"
  vm_policy_default_name         = "${local.base_name}-vm-backup-policy"
  file_share_policy_default_name = "${local.base_name}-fileshare-backup-policy"
  diag_setting_name              = "${local.base_name}-diagsettings"

  # Fixed default list of valid categories, avoid retrieving deprecated ones from the data_source.
  default_valid_log_categories = ["CoreAzureBackup", "AddonAzureBackupJobs", "AddonAzureBackupAlerts", "AddonAzureBackupPolicy", "AddonAzureBackupStorage", "AddonAzureBackupProtectedInstance"]

  # Use data_source `azurerm_monitor_diagnostic_categories` to make sure given categories are available.
  log_categories = setintersection(coalesce(var.log_categories, local.default_valid_log_categories), data.azurerm_monitor_diagnostic_categories.recovery_vault_diagnostics_settings.logs)

  logs = {
    for category in local.log_categories : category => {
      enabled        = var.log_enabled
      retention_days = var.log_retention_in_days
    }
  }
}

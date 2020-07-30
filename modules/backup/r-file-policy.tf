resource "azurerm_backup_policy_file_share" "file_share_backup_policy" {
  name                = coalesce(var.file_share_backup_policy_custom_name, local.file_share_policy_default_name)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.file_share_backup_policy_timezone

  backup {
    frequency = "Daily"
    time      = var.file_share_backup_policy_time
  }

  retention_daily {
    count = var.file_share_backup_policy_retention
  }
}

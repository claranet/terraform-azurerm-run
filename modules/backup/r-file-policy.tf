resource "azurerm_backup_policy_file_share" "file_share_backup_policy" {
  count = var.backup_file_share_enabled ? 1 : 0

  name                = local.file_share_policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault[0].name

  timezone = var.file_share_backup_policy_timezone

  backup {
    frequency = var.file_share_backup_policy_frequency
    time      = var.file_share_backup_policy_time
  }

  retention_daily {
    count = var.file_share_backup_daily_policy_retention
  }

  dynamic "retention_weekly" {
    for_each = var.file_share_backup_weekly_retention != null ? ["_"] : []
    content {
      count    = var.file_share_backup_weekly_retention.count
      weekdays = var.file_share_backup_weekly_retention.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = var.file_share_backup_monthly_retention != null ? ["_"] : []
    content {
      count    = var.file_share_backup_monthly_retention.count
      weekdays = var.file_share_backup_monthly_retention.weekdays
      weeks    = var.file_share_backup_monthly_retention.weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = var.file_share_backup_yearly_retention != null ? ["_"] : []
    content {
      count    = var.file_share_backup_yearly_retention.count
      weekdays = var.file_share_backup_yearly_retention.weekdays
      weeks    = var.file_share_backup_yearly_retention.weeks
      months   = var.file_share_backup_yearly_retention.months
    }
  }
}

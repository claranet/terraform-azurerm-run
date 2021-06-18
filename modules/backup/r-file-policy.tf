resource "azurerm_backup_policy_file_share" "file_share_backup_policy" {
  name                = coalesce(var.file_share_backup_policy_custom_name, local.file_share_policy_default_name)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.file_share_backup_policy_timezone

  backup {
    frequency = var.file_share_backup_policy_frequency
    time      = var.file_share_backup_policy_time
  }

  retention_daily {
    count = var.file_share_backup_daily_policy_retention
  }

  dynamic "retention_weekly" {
    for_each = var.file_share_backup_weekly != {} ? [var.file_share_backup_weekly] : []
    content {
      count    = lookup(retention_weekly.value, "count")
      weekdays = lookup(retention_weekly.value, "weekdays")
    }
  }

  dynamic "retention_monthly" {
    for_each = var.file_share_backup_monthly != {} ? [var.file_share_backup_monthly] : []
    content {
      count    = lookup(retention_monthly.value, "count")
      weekdays = lookup(retention_monthly.value, "weekdays")
      weeks    = lookup(retention_monthly.value, "weeks")
    }
  }

  dynamic "retention_yearly" {
    for_each = var.file_share_backup_yearly != {} ? [var.file_share_backup_yearly] : []
    content {
      count    = lookup(retention_yearly.value, "count")
      weekdays = lookup(retention_yearly.value, "weekdays")
      weeks    = lookup(retention_yearly.value, "weeks")
      months   = lookup(retention_yearly.value, "months")
    }
  }
}

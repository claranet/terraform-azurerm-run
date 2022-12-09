resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  name                = local.vm_policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.vm_backup_policy_timezone

  backup {
    frequency = var.vm_backup_policy_frequency
    time      = var.vm_backup_policy_time
  }

  retention_daily {
    count = var.vm_backup_daily_policy_retention
  }

  dynamic "retention_weekly" {
    for_each = var.vm_backup_weekly != {} ? [var.vm_backup_weekly] : []
    content {
      count    = lookup(retention_weekly.value, "count")
      weekdays = lookup(retention_weekly.value, "weekdays")
    }
  }

  dynamic "retention_monthly" {
    for_each = var.vm_backup_monthly != {} ? [var.vm_backup_monthly] : []
    content {
      count    = lookup(retention_monthly.value, "count")
      weekdays = lookup(retention_monthly.value, "weekdays")
      weeks    = lookup(retention_monthly.value, "weeks")
    }
  }

  dynamic "retention_yearly" {
    for_each = var.vm_backup_yearly != {} ? [var.vm_backup_yearly] : []
    content {
      count    = lookup(retention_yearly.value, "count")
      weekdays = lookup(retention_yearly.value, "weekdays")
      weeks    = lookup(retention_yearly.value, "weeks")
      months   = lookup(retention_yearly.value, "months")
    }
  }
}

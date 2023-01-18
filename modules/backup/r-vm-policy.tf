resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  count = var.backup_vm_enabled ? 1 : 0

  name                = local.vm_policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault[0].name

  timezone = var.vm_backup_policy_timezone

  backup {
    frequency = var.vm_backup_policy_frequency
    time      = var.vm_backup_policy_time
  }

  retention_daily {
    count = var.vm_backup_daily_policy_retention
  }

  dynamic "retention_weekly" {
    for_each = var.vm_backup_weekly_retention != null ? ["_"] : []
    content {
      count    = var.vm_backup_weekly_retention.count
      weekdays = var.vm_backup_weekly_retention.weekdays
    }
  }

  dynamic "retention_monthly" {
    for_each = var.vm_backup_monthly_retention != null ? ["_"] : []
    content {
      count    = var.vm_backup_monthly_retention.count
      weekdays = var.vm_backup_monthly_retention.weekdays
      weeks    = var.vm_backup_monthly_retention.weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = var.vm_backup_yearly_retention != null ? ["_"] : []
    content {
      count    = var.vm_backup_yearly_retention.count
      weekdays = var.vm_backup_yearly_retention.weekdays
      weeks    = var.vm_backup_yearly_retention.weeks
      months   = var.vm_backup_yearly_retention.months
    }
  }
}

moved {
  from = azurerm_backup_policy_vm.vm_backup_policy
  to   = azurerm_backup_policy_vm.vm_backup_policy[0]
}

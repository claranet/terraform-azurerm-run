locals {
  # Weekly schedule days: first non-empty `weekdays` list among the weekly, monthly and yearly retentions.
  # Empty when none is set, which the preconditions below report.
  vm_backup_policy_weekdays = try(coalescelist([for r in [var.vm_backup_weekly_retention, var.vm_backup_monthly_retention, var.vm_backup_yearly_retention] : r.weekdays if r != null]...), [])
}

resource "azurerm_backup_policy_vm" "main" {
  count = var.backup_vm_enabled ? 1 : 0

  name                = local.vm_policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main[0].name

  timezone    = var.vm_backup_policy_timezone
  policy_type = var.vm_backup_policy_type

  backup {
    frequency = var.vm_backup_policy_frequency
    time      = var.vm_backup_policy_time
    weekdays  = var.vm_backup_policy_frequency == "Daily" ? null : local.vm_backup_policy_weekdays
  }

  dynamic "retention_daily" {
    for_each = var.vm_backup_policy_frequency == "Daily" ? ["_"] : []
    content {
      count = var.vm_backup_daily_policy_retention
    }
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

  lifecycle {
    prevent_destroy = true

    precondition {
      condition     = var.vm_backup_policy_frequency != "Weekly" || var.vm_backup_weekly_retention != null
      error_message = "`vm_backup_weekly_retention` must be set when `vm_backup_policy_frequency` is `Weekly`."
    }

    precondition {
      condition     = var.vm_backup_policy_frequency != "Weekly" || length(local.vm_backup_policy_weekdays) > 0
      error_message = "No backup weekdays can be derived while `vm_backup_policy_frequency` is `Weekly`: set `weekdays` in `vm_backup_weekly_retention` (or in `vm_backup_monthly_retention` or `vm_backup_yearly_retention`)."
    }

    precondition {
      condition     = var.vm_backup_policy_frequency != "Weekly" || var.vm_backup_monthly_retention == null || length(setsubtract(try(var.vm_backup_monthly_retention.weekdays, []), local.vm_backup_policy_weekdays)) == 0
      error_message = "`vm_backup_monthly_retention.weekdays` must be among the scheduled backup weekdays (${jsonencode(local.vm_backup_policy_weekdays)}) when `vm_backup_policy_frequency` is `Weekly`. Its default keeps the first Sunday of the month: set `vm_backup_monthly_retention` to matching weekdays or to `null`."
    }

    precondition {
      condition     = var.vm_backup_policy_frequency != "Weekly" || var.vm_backup_yearly_retention == null || length(setsubtract(try(var.vm_backup_yearly_retention.weekdays, []), local.vm_backup_policy_weekdays)) == 0
      error_message = "`vm_backup_yearly_retention.weekdays` must be among the scheduled backup weekdays (${jsonencode(local.vm_backup_policy_weekdays)}) when `vm_backup_policy_frequency` is `Weekly`: set `vm_backup_yearly_retention` to matching weekdays or to `null`."
    }
  }
}

moved {
  from = azurerm_backup_policy_vm.vm_backup_policy[0]
  to   = azurerm_backup_policy_vm.main[0]
}

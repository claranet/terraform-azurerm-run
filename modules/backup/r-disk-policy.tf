resource "azurerm_data_protection_backup_policy_disk" "disk_policy" {
  count = var.backup_managed_disk_enabled ? 1 : 0

  name     = local.disk_policy_name
  vault_id = azurerm_data_protection_backup_vault.vault[0].id

  backup_repeating_time_intervals = [
    "R/2023-01-01T${var.managed_disk_backup_policy_time}:00+00:00/PT${var.managed_disk_backup_policy_interval_in_hours}H"
  ]
  default_retention_duration = "P${var.managed_disk_backup_policy_retention_in_days}D"

  dynamic "retention_rule" {
    for_each = var.managed_disk_backup_daily_policy_retention_in_days != null ? ["_"] : []
    content {
      name     = "Daily"
      duration = "P${var.managed_disk_backup_daily_policy_retention_in_days}D"
      priority = 25
      criteria {
        absolute_criteria = "FirstOfDay"
      }
    }
  }

  dynamic "retention_rule" {
    for_each = var.managed_disk_backup_weekly_policy_retention_in_weeks != null ? ["_"] : []
    content {
      name     = "Weekly"
      duration = "P${var.managed_disk_backup_weekly_policy_retention_in_weeks}W"
      priority = 20
      criteria {
        absolute_criteria = "FirstOfWeek"
      }
    }
  }
}

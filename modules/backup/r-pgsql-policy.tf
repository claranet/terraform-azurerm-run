resource "azurerm_data_protection_backup_policy_postgresql" "main" {
  count = var.backup_postgresql_enabled ? 1 : 0

  name                = local.pgqsl_policy_name
  vault_name          = azurerm_data_protection_backup_vault.main[0].name
  resource_group_name = var.resource_group_name

  backup_repeating_time_intervals = [
    "R/2023-01-01T${var.postgresql_backup_policy_time}:00+00:00/PT${var.postgresql_backup_policy_interval_in_hours}H"
  ]
  default_retention_duration = "P${var.postgresql_backup_policy_retention_in_days}D"

  dynamic "retention_rule" {
    for_each = var.postgresql_backup_daily_policy_retention_in_days != null ? ["_"] : []
    content {
      name     = "Daily"
      duration = "P${var.postgresql_backup_daily_policy_retention_in_days}D"
      priority = 25
      criteria {
        absolute_criteria = "FirstOfDay"
      }
    }
  }

  dynamic "retention_rule" {
    for_each = var.postgresql_backup_weekly_policy_retention_in_weeks != null ? ["_"] : []
    content {
      name     = "Weekly"
      duration = "P${var.postgresql_backup_weekly_policy_retention_in_weeks}W"
      priority = 20
      criteria {
        absolute_criteria = "FirstOfWeek"
      }
    }
  }

  dynamic "retention_rule" {
    for_each = var.postgresql_backup_monthly_policy_retention_in_months != null ? ["_"] : []
    content {
      name     = "Monthly"
      duration = "P${var.postgresql_backup_weekly_policy_retention_in_weeks}W"
      priority = 20
      criteria {
        absolute_criteria = "FirstOfMonth"
      }
    }
  }
}

moved {
  from = azurerm_data_protection_backup_policy_postgresql.pgsql_policy[0]
  to   = azurerm_data_protection_backup_policy_postgresql.main[0]
}
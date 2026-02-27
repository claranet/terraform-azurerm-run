resource "azurerm_data_protection_backup_policy_postgresql_flexible_server" "main" {
  count = var.backup_postgresql_enabled ? 1 : 0

  name     = local.pgqsl_policy_name
  vault_id = azurerm_data_protection_backup_vault.main[0].id

  backup_repeating_time_intervals = [
    "R/2023-01-01T${var.postgresql_backup_policy_time}:00+00:00/P${var.postgresql_backup_policy_interval_in_weeks}W"
  ]

  time_zone = var.postgresql_backup_policy_timezone

  default_retention_rule {
    life_cycle {
      data_store_type = "VaultStore"
      duration        = "P${var.postgresql_backup_weekly_policy_retention_in_weeks}W"

    }
  }

  dynamic "retention_rule" {
    for_each = var.postgresql_backup_monthly_policy_retention_in_months[*]
    content {
      name = "Monthly"
      life_cycle {
        data_store_type = "VaultStore"
        duration        = "P${var.postgresql_backup_monthly_policy_retention_in_months}M"
      }
      priority = 25
      criteria {
        absolute_criteria = "FirstOfMonth"
      }
    }
  }

  dynamic "retention_rule" {
    for_each = var.postgresql_backup_yearly_policy_retention_in_years[*]
    content {
      name = "Yearly"
      life_cycle {
        data_store_type = "VaultStore"
        duration        = "P${var.postgresql_backup_yearly_policy_retention_in_years}Y"
      }
      priority = 30
      criteria {
        absolute_criteria = "FirstOfYear"
      }
    }
  }
}

moved {
  from = azurerm_data_protection_backup_policy_postgresql.pgsql_policy[0]
  to   = azurerm_data_protection_backup_policy_postgresql.main[0]
}

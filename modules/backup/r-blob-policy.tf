resource "azurerm_data_protection_backup_policy_blob_storage" "main" {
  count = var.backup_storage_blob_enabled ? 1 : 0

  name = local.blob_policy_name

  vault_id = azurerm_data_protection_backup_vault.main[0].id

  backup_repeating_time_intervals = ["R/2023-01-01T${var.storage_blob_backup_policy_time}:00+00:00/P${var.storage_blob_backup_policy_interval_in_days}D"]
  time_zone                       = var.storage_blob_backup_policy_timezone

  vault_default_retention_duration       = "P${var.storage_blob_backup_policy_vault_retention_in_days}D"
  operational_default_retention_duration = var.storage_blob_backup_policy_operational_retention_in_days != null ? "P${var.storage_blob_backup_policy_operational_retention_in_days}D" : null

  dynamic "retention_rule" {
    for_each = var.storage_blob_backup_policy_retention_rules
    content {
      name     = retention_rule.value.name
      priority = retention_rule.value.priority
      criteria {
        absolute_criteria      = retention_rule.value.criteria.absolute_criteria
        days_of_month          = retention_rule.value.criteria.days_of_month
        days_of_week           = retention_rule.value.criteria.days_of_week
        months_of_year         = retention_rule.value.criteria.months_of_year
        scheduled_backup_times = retention_rule.value.criteria.scheduled_backup_times
        weeks_of_month         = retention_rule.value.criteria.weeks_of_month
      }
      life_cycle {
        duration        = retention_rule.value.duration
        data_store_type = "VaultStore"
      }
    }
  }
}

moved {
  from = azurerm_data_protection_backup_policy_blob_storage.blob_policy[0]
  to   = azurerm_data_protection_backup_policy_blob_storage.main[0]
}

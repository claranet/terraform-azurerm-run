resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "main" {
  count = var.backup_kubernetes_enabled ? 1 : 0

  name = local.kubernetes_policy_name

  resource_group_name = var.resource_group_name

  vault_name = one(azurerm_data_protection_backup_vault.main[*].name)

  backup_repeating_time_intervals = ["R/2023-01-01T${var.kubernetes_backup_policy_time}:00+00:00/PT${var.kubernetes_backup_policy_interval_in_hours}H"]
  time_zone                       = var.kubernetes_backup_policy_timezone

  dynamic "retention_rule" {
    for_each = var.kubernetes_backup_policy_retention_rules
    content {
      name     = retention_rule.value.name
      priority = retention_rule.value.priority
      criteria {
        absolute_criteria      = retention_rule.value.criteria.absolute_criteria
        days_of_week           = retention_rule.value.criteria.days_of_week
        months_of_year         = retention_rule.value.criteria.months_of_year
        scheduled_backup_times = retention_rule.value.criteria.scheduled_backup_times
        weeks_of_month         = retention_rule.value.criteria.weeks_of_month
      }
      life_cycle {
        duration        = retention_rule.value.duration
        data_store_type = "OperationalStore"
      }
    }
  }

  default_retention_rule {
    life_cycle {
      duration        = "P${var.kubernetes_backup_policy_retention_in_days}D"
      data_store_type = "OperationalStore"
    }
  }
}

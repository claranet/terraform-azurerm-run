resource "azurerm_data_protection_backup_policy_kubernetes_cluster" "main" {
  count = var.backup_kubernetes_enabled ? 1 : 0

  name                = local.kubernetes_policy_name
  vault_name          = azurerm_recovery_services_vault.main[0].name
  resource_group_name = var.resource_group_name

  time_zone = var.kubernetes_backup_policy_timezone

  backup_repeating_time_intervals = ["R/2023-01-01T${var.kubernetes_backup_policy_time}:00+00:00/PT${var.kubernetes_backup_policy_interval_in_hours}H"
  ]

  default_retention_rule {
    life_cycle {
      duration        = var.kubernetes_backup_policy_retention_duration
      data_store_type = "OperationalStore"
    }

    dynamic "retention_rule" {
      for_each = var.kubernetes_backup_policy_retention_rules
      content {
        name     = retention_rule.value.name
        priority = retention_rule.value.priority

        dynamic "life_cycle" {
          for_each = retention_rule.value.life_cycles
          content {
            duration        = life_cycle.value.duration
            data_store_type = life_cycle.value.data_store_type
          }
        }

        criteria {
          absolute_criteria = retention_rule.value.criteria.absolute_criteria
        }
      }
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "recovery_vault_diagnostics_settings" {
  resource_id = azurerm_recovery_services_vault.vault.id
}

resource "azurerm_monitor_diagnostic_setting" "recovery_vault_diagnostics_settings" {
  count = var.diagnostics_settings_enabled ? 1 : 0

  name                           = local.diag_setting_name
  target_resource_id             = azurerm_recovery_services_vault.vault.id
  storage_account_id             = var.log_storage_account_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_workspace_id == null ? null : "Dedicated"
  eventhub_authorization_rule_id = var.log_eventhub_authorization_rule_id

  dynamic "log" {
    for_each = local.logs

    content {
      category = log.key
      enabled  = log.value.enabled

      retention_policy {
        enabled = log.value.retention_days != null ? true : false
        days    = log.value.retention_days
      }
    }
  }
}

# Automation Account
resource "azurerm_automation_account" "main" {
  name                = local.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.automation_account_sku
  tags     = local.curtailed_tags

  dynamic "identity" {
    for_each = var.automation_account_identity_type != null ? ["_"] : []
    content {
      type         = var.automation_account_identity_type.type
      identity_ids = var.automation_account_identity_type.identity_ids
    }
  }
}

moved {
  from = azurerm_automation_account.automation_account
  to   = azurerm_automation_account.main
}

# Link automation account to log analytics workspace
resource "azurerm_log_analytics_linked_service" "main" {
  count = var.log_analytics_workspace_link_enabled ? 1 : 0

  resource_group_name = coalesce(var.log_analytics_resource_group_name, var.resource_group_name)
  workspace_id        = var.log_analytics_workspace_id
  read_access_id      = azurerm_automation_account.main.id
}

moved {
  from = azurerm_log_analytics_linked_service.link_workspace_automation[0]
  to   = azurerm_log_analytics_linked_service.main[0]
}

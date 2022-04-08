# Automation Account
resource "azurerm_automation_account" "automation_account" {
  name                = local.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.automation_account_sku
  tags     = merge(local.default_tags, var.extra_tags, var.automation_account_extra_tags)

    dynamic "identity" {
    for_each = var.automation_account_identity_type != null ? ["fake"] : []
    content {
      type         = var.automation_account_identity_type.type
      identity_ids = var.automation_account_identity_type.identity_ids
    }
  }

}

# Link automation account to log analytics workspace
resource "azurerm_log_analytics_linked_service" "link_workspace_automation" {
  count = var.log_analytics_workspace_link_enabled ? 1 : 0

  resource_group_name = coalesce(var.log_analytics_resource_group_name, var.resource_group_name)
  workspace_id        = var.log_analytics_workspace_id
  read_access_id      = azurerm_automation_account.automation_account.id
}
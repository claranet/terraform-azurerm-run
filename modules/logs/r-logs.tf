# Log Analytics
resource "azurerm_log_analytics_workspace" "main" {
  name = coalesce(
    var.workspace_custom_name,
    local.workspace_name,
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.workspace_sku
  retention_in_days = var.workspace_retention_in_days
  daily_quota_gb    = var.workspace_daily_quota_gb

  tags = merge(
    local.default_tags,
    var.extra_tags,
    var.workspace_extra_tags,
  )
}

moved {
  from = azurerm_log_analytics_workspace.log_workspace
  to = azurerm_log_analytics_workspace.main
}

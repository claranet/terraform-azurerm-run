# Log Analytics
resource "azurerm_log_analytics_workspace" "log_workspace" {
  name = coalesce(
    var.log_analytics_workspace_custom_name,
    local.log_analytics_name,
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = var.log_analytics_workspace_sku
  retention_in_days = var.log_analytics_workspace_retention_in_days

  tags = merge(
    local.default_tags,
    var.extra_tags,
    var.log_analytics_workspace_extra_tags,
  )
}

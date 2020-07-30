data "azurerm_log_analytics_workspace" "log-workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = coalesce(var.log_analytics_resource_group_name, var.resource_group_name)
}

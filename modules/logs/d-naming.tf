data "azurecaf_name" "workspace" {
  name          = var.stack
  resource_type = "azurerm_log_analytics_workspace"
  prefixes      = local.workspace_name_prefix == "" ? null : [local.workspace_name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = true
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "log_analytics_workspace" {
  name          = var.stack
  resource_type = "azurerm_log_analytics_workspace"
  prefixes      = local.log_analytics_workspace_name_prefix == "" ? null : [local.log_analytics_workspace_name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "log"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

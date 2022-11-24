data "azurecaf_name" "log_analytics_workspace" {
  name          = var.stack
  resource_type = "azurerm_log_analytics_workspace"
  prefixes      = var.log_analytics_workspace_name_prefix == "" ? null : [local.log_analytics_workspace_name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "log"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "storage_account" {
  name          = var.stack
  resource_type = "azurerm_storage_account"
  prefixes      = null
  suffixes      = compact([local.logs_storage_account_name_prefix, var.location_short, var.environment, local.name_suffix, "log"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

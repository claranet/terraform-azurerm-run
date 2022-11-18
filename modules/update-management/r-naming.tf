data "azurecaf_name" "update" {
  name          = var.stack
  resource_type = "azurerm_resource_group"
  prefixes      = compact([local.name_prefix, var.use_caf_naming ? "update-management" : ""])
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "update-management"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "mc" {
  for_each = { for config in var.maintenance_configurations : config.configuration_name => config }

  name          = each.key
  resource_type = "azurerm_resource_group"
  prefixes      = [local.name_prefix, "mc"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "mcds" {
  for_each = { for config in var.maintenance_configurations : config.configuration_name => config }

  name          = each.key
  resource_type = "azurerm_resource_group"
  prefixes      = [local.name_prefix, "mcds"]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

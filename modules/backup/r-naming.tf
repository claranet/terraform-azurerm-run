data "azurecaf_name" "recovery_vault" {
  name          = var.stack
  resource_type = "azurerm_recovery_services_vault"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "recoveryvault"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

data "azurecaf_name" "backup_vault" {
  name          = var.stack
  resource_type = "azurerm_data_protection_backup_vault"
  prefixes      = var.name_prefix == "" ? null : [local.name_prefix]
  suffixes      = compact([var.client_name, var.location_short, var.environment, local.name_suffix, var.use_caf_naming ? "" : "backupvault"])
  use_slug      = var.use_caf_naming
  clean_input   = true
  separator     = "-"
}

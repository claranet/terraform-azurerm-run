resource "azurerm_recovery_services_vault" "vault" {
  name                = coalesce(var.recovery_vault_custom_name, local.vault_default_name)
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = var.recovery_vault_sku

  tags = merge(local.default_tags, var.extra_tags)
}

resource "azurerm_recovery_services_protection_policy_vm" "vm_backup_policy" {
  name                = coalesce(var.vm_backup_policy_custom_name, local.vm_policy_default_name)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.vm_backup_policy_timezone

  backup {
    frequency = "Daily"
    time      = var.vm_backup_policy_time
  }

  retention_daily {
    count = var.vm_backup_policy_retention
  }
}

resource "azurerm_backup_policy_file_share" "file_share_backup_policy" {
  name                = coalesce(var.file_share_backup_policy_custom_name, local.file_share_policy_default_name)
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = var.file_share_backup_policy_timezone

  backup {
    frequency = "Daily"
    time      = var.file_share_backup_policy_time
  }

  retention_daily {
    count = var.file_share_backup_policy_retention
  }
}

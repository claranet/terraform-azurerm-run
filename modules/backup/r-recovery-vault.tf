resource "azurerm_recovery_services_vault" "main" {
  count = var.backup_vm_enabled || var.backup_file_share_enabled ? 1 : 0

  name                = local.recovery_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = var.recovery_vault_sku

  storage_mode_type            = var.recovery_vault_storage_mode_type
  cross_region_restore_enabled = var.recovery_vault_cross_region_restore_enabled
  soft_delete_enabled          = var.recovery_vault_soft_delete_enabled

  dynamic "identity" {
    for_each = var.recovery_vault_identity_type[*]
    content {
      type = var.recovery_vault_identity_type
    }
  }

  tags = merge(local.default_tags, var.extra_tags, var.recovery_vault_extra_tags)
}

moved {
  from = azurerm_recovery_services_vault.vault[0]
  to   = azurerm_recovery_services_vault.main[0]
}

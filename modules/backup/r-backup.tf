resource "azurerm_recovery_services_vault" "vault" {
  name                = coalesce(var.recovery_vault_custom_name, local.vault_default_name)
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = var.recovery_vault_sku

  dynamic "identity" {
    for_each = toset(var.recovery_vault_identity_type != null ? ["fake"] : [])
    content {
      type = var.recovery_vault_identity_type
    }
  }

  tags = merge(local.default_tags, var.extra_tags, var.recovery_vault_extra_tags)
}

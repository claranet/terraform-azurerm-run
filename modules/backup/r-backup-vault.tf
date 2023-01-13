resource "azurerm_data_protection_backup_vault" "vault" {
  count = var.backup_postgresql_enabled || var.backup_managed_disk_enabled || var.backup_storage_blob_enabled ? 1 : 0

  name                = local.backup_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  datastore_type      = var.backup_vault_datastore_type
  redundancy          = var.backup_vault_geo_redundancy_enabled ? "GeoRedundant" : "LocallyRedundant"

  dynamic "identity" {
    for_each = toset(var.backup_vault_identity_type != null ? ["fake"] : [])
    content {
      type = var.backup_vault_identity_type
    }
  }

  tags = merge(local.default_tags, var.extra_tags, var.backup_vault_extra_tags)
}

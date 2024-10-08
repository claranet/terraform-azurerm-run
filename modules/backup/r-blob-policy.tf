resource "azurerm_data_protection_backup_policy_blob_storage" "main" {
  count = var.backup_storage_blob_enabled ? 1 : 0

  name     = local.blob_policy_name
  vault_id = azurerm_data_protection_backup_vault.main[0].id

  operational_default_retention_duration = "P${var.storage_blob_backup_policy_retention_in_days}D"
}

moved {
  from = azurerm_data_protection_backup_policy_blob_storage.blob_policy[0]
  to   = azurerm_data_protection_backup_policy_blob_storage.main[0]
}
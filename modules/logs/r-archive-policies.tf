# Archived Logs File Shares
resource "azurerm_storage_share" "main" {
  count                = var.storage_account_enabled && var.storage_account_archived_logs_fileshare_enabled ? 1 : 0
  name                 = var.storage_account_archived_logs_fileshare_name
  storage_account_name = one(module.storage[*].storage_account_name)
  quota                = var.storage_account_archived_logs_fileshare_quota
}

moved {
  from = azurerm_storage_share.archivedlogs_fileshare
  to   = azurerm_storage_share.main
}

# Blob Archive policy
resource "azurerm_storage_management_policy" "main" {
  count              = var.storage_account_enabled && lower(var.storage_account_kind) == "storagev2" && var.storage_account_archiving_enabled ? 1 : 0
  storage_account_id = one(module.storage[*].id)

  rule {
    name    = "Archive"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = var.tier_to_cool_after_days_since_modification_greater_than
        tier_to_archive_after_days_since_modification_greater_than = var.tier_to_archive_after_days_since_modification_greater_than
        delete_after_days_since_modification_greater_than          = var.delete_after_days_since_modification_greater_than
      }
    }
  }

  rule {
    name    = "PurgeLogs"
    enabled = true
    filters {
      blob_types = ["appendBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = var.delete_after_days_since_modification_greater_than
      }
    }
  }
}

moved {
  from = azurerm_storage_management_policy.archive_storage[0]
  to   = azurerm_storage_management_policy.main[0]
}

# Storage account for Logs
module "storage_logs" {
  count = var.logs_storage_account_enabled ? 1 : 0

  source  = "claranet/storage-account/azurerm"
  version = "~> 7.7.0"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = var.location
  location_short = var.location_short

  resource_group_name = var.resource_group_name

  storage_account_custom_name = var.logs_storage_account_custom_name
  name_prefix                 = local.logs_storage_account_name_prefix
  name_suffix                 = "${var.name_suffix}log"

  # Storage account kind/SKU/tier
  account_replication_type = var.logs_storage_account_replication_type
  account_tier             = var.logs_storage_account_tier
  account_kind             = var.logs_storage_account_kind

  # Storage account options / security
  min_tls_version                    = var.logs_storage_min_tls_version
  https_traffic_only_enabled         = var.logs_storage_account_enable_https_traffic_only
  public_nested_items_allowed        = false
  advanced_threat_protection_enabled = var.logs_storage_account_enable_advanced_threat_protection

  # Identity
  #   identity_type = var.storage_account_identity_type
  #   identity_ids  = var.storage_account_identity_ids

  # Data protection - not needed for now
  storage_blob_data_protection = {
    change_feed_enabled                       = false
    versioning_enabled                        = false
    delete_retention_policy_in_days           = 0
    container_delete_retention_policy_in_days = 0
    container_point_in_time_restore           = false
  }

  # Network rules - handle out of module to avoid Terraform cycle
  network_rules_enabled = false

  # Diagnostics/logs
  logs_destinations_ids = []

  # Tagging
  default_tags_enabled = var.default_tags_enabled
  extra_tags = merge(
    local.default_tags,
    var.extra_tags,
    var.logs_storage_account_extra_tags,
  )
}

## This statement declares a move to an object declared in external module package "registry.terraform.io/claranet/storage-account/azurerm". Move statements can be only within a single module package.
# moved {
#   from = azurerm_storage_account.storage_logs
#   to   = module.storage_logs.azurerm_storage_account.storage
# }

# moved {
#   from = azurerm_advanced_threat_protection.storage_threat_protection
#   to   = module.storage_logs.azurerm_advanced_threat_protection.threat_protection
# }

# Archived Logs File Shares
resource "azurerm_storage_share" "archivedlogs_fileshare" {
  count                = var.logs_storage_account_enabled && var.logs_storage_account_enable_archived_logs_fileshare ? 1 : 0
  name                 = var.logs_storage_account_archived_logs_fileshare_name
  storage_account_name = one(module.storage_logs[*].storage_account_name)
  quota                = var.logs_storage_account_archived_logs_fileshare_quota
}

# Blob Archive policy
resource "azurerm_storage_management_policy" "archive_storage" {
  count              = var.logs_storage_account_enabled && lower(var.logs_storage_account_kind) == "storagev2" && var.logs_storage_account_enable_archiving ? 1 : 0
  storage_account_id = one(module.storage_logs[*].storage_account_id)

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

}

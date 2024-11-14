# Storage account for Logs
module "storage" {
  count = var.storage_account_enabled ? 1 : 0

  source  = "claranet/storage-account/azurerm"
  version = "~> 8.1.0"

  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack
  location       = var.location
  location_short = var.location_short

  resource_group_name = var.resource_group_name

  custom_name = var.storage_account_custom_name
  name_prefix = local.storage_account_name_prefix
  name_suffix = "${var.name_suffix}log"

  # RBAC/access
  shared_access_key_enabled                   = var.storage_shared_access_key_enabled
  rbac_storage_contributor_role_principal_ids = var.rbac_storage_contributor_role_principal_ids
  rbac_storage_blob_role_principal_ids        = var.rbac_storage_blob_role_principal_ids

  # Storage account kind/SKU/tier
  account_replication_type = var.storage_account_replication_type
  account_tier             = var.storage_account_tier
  account_kind             = var.storage_account_kind

  # Storage access tier
  access_tier = var.storage_account_access_tier

  # Storage account options / security
  min_tls_version                    = var.storage_account_min_tls_version
  https_traffic_only_enabled         = var.storage_account_https_traffic_only_enabled
  public_nested_items_allowed        = false
  advanced_threat_protection_enabled = var.storage_account_advanced_threat_protection_enabled

  # Identity
  identity_type = var.storage_account_identity_type
  identity_ids  = var.storage_account_identity_ids

  customer_managed_key = var.storage_account_customer_managed_key

  # Data protection - not needed for now
  blob_data_protection = {
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
    var.storage_account_extra_tags,
  )
}

moved {
  from = module.storage
  to   = module.storage[0]
}

module "logs" {
  source = "./modules/logs"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.logs_resource_group_name, var.resource_group_name)

  name_prefix = var.name_prefix
  name_suffix = var.name_suffix

  storage_account_enabled                            = var.logs_storage_account_enabled
  storage_account_name_prefix                        = var.logs_storage_account_name_prefix
  storage_account_custom_name                        = var.logs_storage_account_custom_name
  storage_account_extra_tags                         = var.logs_storage_account_extra_tags
  storage_account_kind                               = var.logs_storage_account_kind
  storage_account_tier                               = var.logs_storage_account_tier
  storage_account_access_tier                        = var.logs_storage_account_access_tier
  storage_account_replication_type                   = var.logs_storage_account_replication_type
  storage_account_min_tls_version                    = var.logs_storage_account_min_tls_version
  storage_account_advanced_threat_protection_enabled = var.logs_storage_account_advanced_threat_protection_enabled
  storage_account_infrastructure_encryption_enabled  = var.logs_storage_account_infrastructure_encryption_enabled
  storage_account_https_traffic_only_enabled         = var.logs_storage_account_https_traffic_only_enabled
  storage_account_archived_logs_fileshare_enabled    = var.logs_storage_account_archived_logs_fileshare_enabled
  storage_account_archived_logs_fileshare_name       = var.logs_storage_account_archived_logs_fileshare_name
  storage_account_archived_logs_fileshare_quota      = var.logs_storage_account_archived_logs_fileshare_quota
  storage_account_customer_managed_key               = var.logs_storage_account_customer_managed_key
  storage_account_identity_type                      = var.logs_storage_account_identity_type
  storage_account_identity_ids                       = var.logs_storage_account_identity_ids
  storage_account_allowed_copy_scope                 = var.logs_storage_account_allowed_copy_scope
  storage_account_public_network_access_enabled      = var.logs_storage_account_public_network_access_enabled

  # RBAC/access
  storage_shared_access_key_enabled           = var.logs_storage_account_shared_access_key_enabled
  rbac_storage_contributor_role_principal_ids = var.logs_rbac_storage_contributor_role_principal_ids
  rbac_storage_blob_role_principal_ids        = var.logs_rbac_storage_blob_role_principal_ids

  workspace_name_prefix       = var.log_analytics_workspace_name_prefix
  workspace_custom_name       = var.log_analytics_workspace_custom_name
  workspace_extra_tags        = var.log_analytics_workspace_extra_tags
  workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  workspace_daily_quota_gb    = var.log_analytics_workspace_daily_quota_gb
  workspace_sku               = var.log_analytics_workspace_sku

  storage_account_archiving_enabled                          = var.logs_storage_account_archiving_enabled
  tier_to_cool_after_days_since_modification_greater_than    = var.logs_tier_to_cool_after_days_since_modification_greater_than
  tier_to_archive_after_days_since_modification_greater_than = var.logs_tier_to_archive_after_days_since_modification_greater_than
  delete_after_days_since_modification_greater_than          = var.logs_delete_after_days_since_modification_greater_than

  default_tags_enabled = var.default_tags_enabled

  extra_tags = var.extra_tags
}

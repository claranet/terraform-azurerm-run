module "logs" {
  source = "./modules/logs"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.logs_resource_group_name, var.resource_group_name)

  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix

  logs_storage_account_enabled                           = var.logs_storage_account_enabled
  logs_storage_account_name_prefix                       = var.logs_storage_account_name_prefix
  logs_storage_account_custom_name                       = var.logs_storage_account_custom_name
  logs_storage_account_extra_tags                        = var.logs_storage_account_extra_tags
  logs_storage_account_kind                              = var.logs_storage_account_kind
  logs_storage_account_tier                              = var.logs_storage_account_tier
  logs_storage_account_replication_type                  = var.logs_storage_account_replication_type
  logs_storage_min_tls_version                           = var.logs_storage_min_tls_version
  logs_storage_account_enable_advanced_threat_protection = var.logs_storage_account_enable_advanced_threat_protection
  logs_storage_account_enable_https_traffic_only         = var.logs_storage_account_enable_https_traffic_only
  logs_storage_account_enable_archived_logs_fileshare    = var.logs_storage_account_enable_archived_logs_fileshare
  logs_storage_account_archived_logs_fileshare_name      = var.logs_storage_account_archived_logs_fileshare_name
  logs_storage_account_archived_logs_fileshare_quota     = var.logs_storage_account_archived_logs_fileshare_quota

  log_analytics_workspace_name_prefix       = var.log_analytics_workspace_name_prefix
  log_analytics_workspace_custom_name       = var.log_analytics_workspace_custom_name
  log_analytics_workspace_extra_tags        = var.log_analytics_workspace_extra_tags
  log_analytics_workspace_retention_in_days = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku               = var.log_analytics_workspace_sku

  logs_storage_account_enable_archiving                      = var.logs_storage_account_enable_archiving
  tier_to_cool_after_days_since_modification_greater_than    = var.logs_tier_to_cool_after_days_since_modification_greater_than
  tier_to_archive_after_days_since_modification_greater_than = var.logs_tier_to_archive_after_days_since_modification_greater_than
  delete_after_days_since_modification_greater_than          = var.logs_delete_after_days_since_modification_greater_than

  default_tags_enabled = var.default_tags_enabled

  extra_tags = var.extra_tags
}

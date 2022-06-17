module "logs" {
  source = "./modules/logs"

  client_name         = var.client_name
  location            = var.location
  location_short      = var.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = coalesce(var.logs_resource_group_name, var.resource_group_name)

  use_caf_naming = var.use_caf_naming
  name_prefix    = coalesce(var.name_prefix, "logs")
  name_suffix    = var.name_suffix

  logs_storage_account_name_prefix                       = var.logs_storage_account_name_prefix
  logs_storage_account_custom_name                       = var.logs_storage_account_custom_name
  logs_storage_account_extra_tags                        = var.logs_storage_account_extra_tags
  logs_storage_account_kind                              = var.logs_storage_account_kind
  logs_storage_min_tls_version                           = var.logs_storage_min_tls_version
  logs_storage_account_sas_expiry                        = var.logs_storage_account_sas_expiry
  logs_storage_account_enable_appservices_container      = var.logs_storage_account_enable_appservices_container
  logs_storage_account_appservices_container_name        = var.logs_storage_account_appservices_container_name
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
  log_analytics_workspace_enable_iis_logs   = var.log_analytics_workspace_enable_iis_logs

  logs_storage_account_enable_archiving                      = var.logs_storage_account_enable_archiving
  tier_to_cool_after_days_since_modification_greater_than    = var.logs_tier_to_cool_after_days_since_modification_greater_than
  tier_to_archive_after_days_since_modification_greater_than = var.logs_tier_to_archive_after_days_since_modification_greater_than
  delete_after_days_since_modification_greater_than          = var.logs_delete_after_days_since_modification_greater_than

  default_tags_enabled = var.default_tags_enabled

  extra_tags = var.extra_tags
}

module "keyvault" {
  source  = "claranet/keyvault/azurerm"
  version = "5.1.0"

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = coalesce(var.keyvault_resource_group_name, var.resource_group_name)
  stack               = var.stack
  tenant_id           = var.tenant_id

  custom_name    = var.keyvault_custom_name
  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix

  sku_name = var.keyvault_sku

  admin_objects_ids  = var.keyvault_admin_objects_ids
  reader_objects_ids = var.keyvault_reader_objects_ids

  enabled_for_deployment          = var.keyvault_enabled_for_deployment
  enabled_for_disk_encryption     = var.keyvault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.keyvault_enabled_for_template_deployment

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id,
  ]

  logs_retention_days     = var.log_analytics_workspace_retention_in_days
  logs_categories         = var.keyvault_logs_categories
  logs_metrics_categories = var.keyvault_logs_metrics_categories

  purge_protection_enabled = true

  network_acls = var.keyvault_network_acls

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(var.extra_tags, var.keyvault_extra_tags)
}

module "monitoring_function" {
  source = "./modules/monitoring_function"

  count = var.monitoring_function_enabled ? 1 : 0

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = coalesce(var.keyvault_resource_group_name, var.resource_group_name)
  stack               = var.stack

  use_caf_naming = var.use_caf_naming
  name_prefix    = coalesce(var.name_prefix, "fame")
  name_suffix    = var.name_suffix

  storage_account_name             = var.monitoring_function_storage_account_custom_name
  function_app_custom_name         = var.monitoring_function_function_app_custom_name
  application_insights_custom_name = var.monitoring_function_application_insights_custom_name
  service_plan_custom_name         = var.monitoring_function_app_service_plan_name

  zip_package_path           = var.monitoring_function_zip_package_path
  metrics_extra_dimensions   = var.monitoring_function_metrics_extra_dimensions
  extra_application_settings = var.monitoring_function_extra_application_settings

  log_analytics_workspace_guid = module.logs.log_analytics_workspace_guid
  splunk_token                 = var.monitoring_function_splunk_token

  logs_destinations_ids = [
    module.logs.log_analytics_workspace_id,
    module.logs.logs_storage_account_id,
  ]

  logs_retention_days     = var.log_analytics_workspace_retention_in_days
  logs_categories         = var.monitoring_function_logs_categories
  logs_metrics_categories = var.monitoring_function_logs_metrics_categories

  storage_account_enable_advanced_threat_protection = var.monitoring_function_advanced_threat_protection_enabled
  storage_account_network_rules_enabled             = var.monitoring_function_storage_account_network_rules_enabled
  storage_account_authorized_ips                    = var.monitoring_function_storage_account_authorized_ips
  storage_account_network_bypass                    = var.monitoring_function_storage_account_network_bypass

  default_tags_enabled = var.default_tags_enabled

  extra_tags = var.monitoring_function_extra_tags
}

resource "azurerm_role_assignment" "function_workspace" {
  count = var.monitoring_function_enabled && var.monitoring_function_assign_role_on_workspace ? 1 : 0

  principal_id = module.monitoring_function[0].function_app_identity["principal_id"]
  scope        = module.logs.log_analytics_workspace_id

  role_definition_name = "Log Analytics Reader"
}

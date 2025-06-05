module "function" {
  source  = "claranet/function-app/azurerm"
  version = "~> 8.2.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix = coalesce(local.name_prefix, "fame")
  name_suffix = local.name_suffix

  storage_account_custom_name      = var.storage_account_custom_name
  function_app_custom_name         = var.function_app_custom_name
  application_insights_custom_name = var.application_insights_custom_name
  service_plan_custom_name         = var.service_plan_custom_name

  application_settings_drift_ignore = false
  application_settings              = local.app_settings

  os_type              = "Linux"
  sku_name             = "Y1"
  function_app_version = 4
  site_config = {
    application_stack = {
      python_version = "3.12"
    }
  }

  storage_account_network_rules_enabled       = false
  rbac_storage_contributor_role_principal_ids = var.rbac_storage_contributor_role_principal_ids
  rbac_storage_table_role_principal_ids       = var.rbac_storage_table_role_principal_ids

  application_zip_package_path = var.zip_package_path

  logs_destinations_ids           = var.logs_destinations_ids
  logs_categories                 = var.logs_categories
  logs_metrics_categories         = var.logs_metrics_categories
  diagnostic_settings_custom_name = var.diagnostic_settings_custom_name

  application_insights_enabled                    = var.application_insights_enabled
  application_insights_log_analytics_workspace_id = var.application_insights_log_analytics_workspace_id

  storage_account_advanced_threat_protection_enabled = var.storage_account_advanced_threat_protection_enabled

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(
    local.default_tags,
    var.extra_tags,
  )
}

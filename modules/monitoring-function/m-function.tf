module "function" {
  source  = "claranet/function-app/azurerm"
  version = "~> 8.0.0"

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

  function_app_application_settings_drift_ignore = false
  function_app_application_settings = merge({
    SFX_TOKEN                    = var.splunk_token
    LOG_ANALYTICS_WORKSPACE_GUID = var.log_analytics_workspace_guid
    SUBSCRIPTION_ID              = data.azurerm_client_config.current.subscription_id
    SFX_EXTRA_DIMENSIONS         = local.extra_dimensions
  }, var.extra_application_settings)

  os_type              = "Linux"
  sku_name             = "Y1"
  function_app_version = 4
  function_app_site_config = {
    application_stack = {
      python_version = "3.10"
    }
  }

  storage_account_network_rules_enabled = false

  application_zip_package_path = var.zip_package_path

  logs_destinations_ids           = var.logs_destinations_ids
  logs_categories                 = var.logs_categories
  logs_metrics_categories         = var.logs_metrics_categories
  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  application_insights_enabled                    = var.application_insights_enabled
  application_insights_log_analytics_workspace_id = var.application_insights_log_analytics_workspace_id

  storage_account_enable_advanced_threat_protection = var.storage_account_enable_advanced_threat_protection

  default_tags_enabled = var.default_tags_enabled

  extra_tags = merge(
    local.default_tags,
    var.extra_tags,
  )
}

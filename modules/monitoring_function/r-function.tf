module "function" {
  # source  = "claranet/function-app/azurerm"
  # version = "4.1.0"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/function-app.git?ref=AZ-515_caf_naming"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix    = local.name_prefix
  name_suffix    = local.name_suffix
  use_caf_naming = var.use_caf_naming

  storage_account_name             = var.storage_account_name
  function_app_custom_name         = var.function_app_custom_name
  application_insights_custom_name = var.application_insights_custom_name

  function_app_application_settings = merge({
    SFX_TOKEN                    = var.splunk_token
    LOG_ANALYTICS_WORKSPACE_GUID = var.log_analytics_workspace_guid
    SFX_EXTRA_DIMENSIONS         = local.extra_dimensions
  }, var.extra_application_settings)

  app_service_plan_os         = "Linux"
  function_language_for_linux = "python"
  function_app_version        = 3

  application_zip_package_path = var.zip_package_path

  logs_destinations_ids           = var.logs_destinations_ids
  logs_categories                 = var.logs_categories
  logs_metrics_categories         = var.logs_metrics_categories
  logs_retention_days             = var.logs_retention_days
  custom_diagnostic_settings_name = var.custom_diagnostic_settings_name

  storage_account_enable_advanced_threat_protection = var.storage_account_enable_advanced_threat_protection

  extra_tags = merge(
    local.default_tags,
    var.extra_tags,
  )
}

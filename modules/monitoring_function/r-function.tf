module "function" {
  source  = "claranet/function-app/azurerm"
  version = "4.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix = var.name_prefix

  function_app_application_settings = merge({
    SFX_TOKEN                    = var.splunk_token
    LOG_ANALYTICS_WORKSPACE_GUID = var.log_analytics_workspace_guid
    SFX_EXTRA_DIMENSIONS         = local.extra_dimensions
  }, var.extra_application_settings)

  app_service_plan_os         = "Linux"
  function_language_for_linux = "python"
  function_app_version        = 3

  application_zip_package_path = var.zip_package_path

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories

  extra_tags = merge(
    local.default_tags,
    var.extra_tags,
  )
}

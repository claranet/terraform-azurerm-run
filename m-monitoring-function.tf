resource "null_resource" "fake_function_condition" {
  count = var.monitoring_function_enabled ? 1 : 0

  triggers = {
    splunk_token = var.monitoring_function_splunk_token
  }

  lifecycle {
    precondition {
      condition     = var.monitoring_function_splunk_token != null
      error_message = "Variable monitoring_function_splunk_token must be set when variable monitoring_function_enabled is set to true."
    }
  }
}

module "monitoring_function" {
  source = "./modules/monitoring-function"

  count = var.monitoring_function_enabled ? 1 : 0

  client_name         = var.client_name
  environment         = var.environment
  location            = var.location
  location_short      = var.location_short
  resource_group_name = coalesce(var.key_vault_resource_group_name, var.resource_group_name)
  stack               = var.stack

  name_prefix = coalesce(var.name_prefix, "fame")
  name_suffix = var.name_suffix

  storage_account_custom_name      = var.monitoring_function_storage_account_custom_name
  function_app_custom_name         = var.monitoring_function_function_app_custom_name
  application_insights_custom_name = var.monitoring_function_application_insights_custom_name
  service_plan_custom_name         = var.monitoring_function_app_service_plan_name

  zip_package_path           = var.monitoring_function_zip_package_path
  metrics_extra_dimensions   = var.monitoring_function_metrics_extra_dimensions
  extra_application_settings = var.monitoring_function_extra_application_settings

  log_analytics_workspace_guid = module.logs.log_analytics_workspace_guid
  splunk_token                 = var.monitoring_function_splunk_token

  logs_destinations_ids = [
    module.logs.id,
    module.logs.storage_account_id,
  ]
  logs_categories         = var.monitoring_function_logs_categories
  logs_metrics_categories = var.monitoring_function_logs_metrics_categories

  storage_account_enable_advanced_threat_protection = var.monitoring_function_advanced_threat_protection_enabled

  application_insights_enabled                    = var.monitoring_function_application_insights_enabled
  application_insights_log_analytics_workspace_id = module.logs.id

  default_tags_enabled = var.default_tags_enabled

  extra_tags = var.monitoring_function_extra_tags

  depends_on = [null_resource.fake_function_condition]
}

resource "azurerm_role_assignment" "function_workspace" {
  count = var.monitoring_function_enabled && var.monitoring_function_assign_roles ? 1 : 0

  principal_id = module.monitoring_function[0].function_app_identity_principal_id
  scope        = module.logs.id

  role_definition_name = "Log Analytics Reader"
}

resource "azurerm_role_assignment" "function_subscription" {
  count = var.monitoring_function_enabled && var.monitoring_function_assign_roles ? 1 : 0

  principal_id = module.monitoring_function[0].function_app_identity_principal_id
  scope        = format("/subscriptions/%s", data.azurerm_client_config.current.subscription_id)

  role_definition_name = "Reader"
}

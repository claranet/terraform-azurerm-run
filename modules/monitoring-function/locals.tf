locals {
  fame_dimensions = {
    fame_function_app_resource_group  = var.resource_group_name,
    fame_function_app_subscription_id = data.azurerm_client_config.current.subscription_id,
  }
  extra_dimensions = join(",", [for k, v in merge(local.default_tags, local.fame_dimensions, var.metrics_extra_dimensions) : format("%s=%s", k, v)])

  log_queries = merge(
    local.log_queries_heartbeat,
    local.log_queries_appgw,
    local.log_queries_backup,
    local.log_queries_updates,
    local.log_queries_vpn,
  )

  app_settings = merge(
    {
      LOG_ANALYTICS_WORKSPACE_GUID = var.log_analytics_workspace_guid,
      SUBSCRIPTION_ID              = data.azurerm_client_config.current.subscription_id,
      METRICS_EXTRA_DIMENSIONS     = local.extra_dimensions,
    },
    var.extra_application_settings,
    var.splunk_token != null ? { SFX_TOKEN = var.splunk_token } : {},
    var.datadog_api_key != null ? { DD_API_KEY = var.datadog_api_key } : {},
  )
}

module "automation_account" {
  source = "./modules/automation-account"

  count = var.automation_account_enabled ? 1 : 0

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  use_caf_naming                 = var.use_caf_naming
  name_prefix                    = var.name_prefix
  name_suffix                    = var.name_suffix
  automation_account_custom_name = var.automation_account_custom_name

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags

  automation_account_sku           = var.automation_account_sku
  automation_account_extra_tags    = var.automation_account_extra_tags
  automation_account_identity_type = var.automation_account_identity_type

  log_analytics_resource_group_name    = var.log_analytics_resource_group_name
  log_analytics_workspace_link_enabled = var.log_analytics_workspace_link_enabled
  log_analytics_workspace_id           = coalesce(var.log_analytics_workspace_id, module.logs.log_analytics_workspace_id)

  logs_destinations_ids   = coalescelist(var.automation_logs_destinations_ids, local.logs_destinations_ids)
  logs_categories         = var.automation_logs_categories
  logs_metrics_categories = var.automation_logs_metrics_categories

  diagnostic_settings_custom_name = var.automation_diagnostic_settings_custom_name
}

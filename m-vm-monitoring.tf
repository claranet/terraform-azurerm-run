module "vm_monitoring" {
  source = "./modules/vm-monitoring"

  count = var.monitoring_function_enabled ? 1 : 0

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix
  custom_name    = var.dcr_custom_name

  log_analytics_workspace_id = coalesce(var.log_analytics_workspace_id, module.logs.log_analytics_workspace_id)

  syslog_facilities_names = var.data_collection_syslog_facilities_names
  syslog_levels           = var.data_collection_syslog_levels

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

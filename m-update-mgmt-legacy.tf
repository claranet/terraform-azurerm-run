module "update_management" {
  source = "./modules/update-management"

  count = var.update_management_legacy_enabled ? 1 : 0

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  use_caf_naming = var.use_caf_naming
  name_prefix    = try(coalesce(var.update_management_name_prefix, var.name_prefix), "")
  name_suffix    = var.name_suffix

  automation_account_name    = one(module.automation_account[*].automation_account_name)
  log_analytics_workspace_id = coalesce(var.log_analytics_workspace_id, module.logs.log_analytics_workspace_id)

  deploy_update_management_solution = var.deploy_update_management_solution

  update_management_os_list                 = var.update_management_os_list
  update_management_scope                   = var.update_management_scope
  update_management_duration                = var.update_management_duration
  update_management_tags_filtering          = var.update_management_tags_filtering
  update_management_tags_filtering_operator = var.update_management_tags_filtering_operator
  update_management_schedule                = var.update_management_schedule

  linux_update_management_duration                = var.linux_update_management_duration
  linux_update_management_scope                   = var.linux_update_management_scope
  linux_update_management_tags_filtering          = var.linux_update_management_tags_filtering
  linux_update_management_tags_filtering_operator = var.linux_update_management_tags_filtering_operator
  linux_update_management_schedule                = var.linux_update_management_schedule
  linux_update_management_configuration           = var.linux_update_management_configuration
  linux_update_management_configuration_name      = var.linux_update_management_config_name

  windows_update_management_duration                = var.windows_update_management_duration
  windows_update_management_scope                   = var.windows_update_management_scope
  windows_update_management_tags_filtering          = var.windows_update_management_tags_filtering
  windows_update_management_tags_filtering_operator = var.windows_update_management_tags_filtering_operator
  windows_update_management_schedule                = var.windows_update_management_schedule
  windows_update_management_configuration           = var.windows_update_management_configuration
  windows_update_management_configuration_name      = var.windows_update_management_configuration_name

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags
}

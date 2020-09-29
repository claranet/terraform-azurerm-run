module "backup" {
  source = "./modules/backup"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix
  extra_tags          = var.extra_tags

  recovery_vault_custom_name   = var.recovery_vault_custom_name
  recovery_vault_sku           = var.recovery_vault_sku
  recovery_vault_identity_type = var.recovery_vault_identity_type
  recovery_vault_extra_tags    = var.recovery_vault_extra_tags

  vm_backup_policy_custom_name     = var.vm_backup_policy_custom_name
  vm_backup_policy_timezone        = var.vm_backup_policy_timezone
  vm_backup_policy_frequency       = var.vm_backup_policy_frequency
  vm_backup_policy_time            = var.vm_backup_policy_time
  vm_backup_daily_policy_retention = var.vm_backup_daily_policy_retention

  vm_backup_weekly  = var.vm_backup_weekly
  vm_backup_monthly = var.vm_backup_monthly
  vm_backup_yearly  = var.vm_backup_yearly

  file_share_backup_policy_custom_name     = var.file_share_backup_policy_custom_name
  file_share_backup_policy_timezone        = var.file_share_backup_policy_timezone
  file_share_backup_policy_frequency       = var.file_share_backup_policy_frequency
  file_share_backup_policy_time            = var.file_share_backup_policy_time
  file_share_backup_daily_policy_retention = var.file_share_backup_daily_policy_retention

  file_share_backup_weekly  = var.file_share_backup_weekly
  file_share_backup_monthly = var.file_share_backup_monthly
  file_share_backup_yearly  = var.file_share_backup_yearly

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories
  logs_retention_days     = var.logs_retention_days
}

module "automation_account" {
  source = "./modules/automation-account"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name
  extra_tags          = var.extra_tags

  automation_account_sku        = var.automation_account_sku
  automation_account_extra_tags = var.automation_account_extra_tags

  custom_automation_account_name    = var.custom_automation_account_name
  log_analytics_resource_group_name = var.log_analytics_resource_group_name
  log_analytics_workspace_id        = var.log_analytics_workspace_id

  logs_destinations_ids   = var.logs_destinations_ids
  logs_categories         = var.logs_categories
  logs_metrics_categories = var.logs_metrics_categories
  logs_retention_days     = var.logs_retention_days
}

module "update_management" {
  source = "./modules/update-management"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name
  name_prefix         = try(coalesce(var.update_management_name_prefix, var.name_prefix), "")

  automation_account_name    = module.automation_account.automation_account_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

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

  extra_tags = var.extra_tags
}

module "vm-monitoring" {
  source = "./modules/vm-monitoring"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name
  extra_tags          = var.extra_tags

  log_analytics_workspace_id = var.log_analytics_workspace_id

  syslog_facilities_names = var.data_collection_syslog_facilities_names
  syslog_levels           = var.data_collection_syslog_levels
}

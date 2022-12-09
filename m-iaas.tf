module "backup" {
  source = "./modules/backup"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  use_caf_naming = var.use_caf_naming
  name_prefix    = var.name_prefix
  name_suffix    = var.name_suffix

  default_tags_enabled = var.default_tags_enabled
  extra_tags           = var.extra_tags

  recovery_vault_custom_name                  = var.recovery_vault_custom_name
  recovery_vault_sku                          = var.recovery_vault_sku
  recovery_vault_identity_type                = var.recovery_vault_identity_type
  recovery_vault_storage_mode_type            = var.recovery_vault_storage_mode_type
  recovery_vault_cross_region_restore_enabled = var.recovery_vault_cross_region_restore_enabled
  recovery_vault_soft_delete_enabled          = var.recovery_vault_soft_delete_enabled
  recovery_vault_extra_tags                   = var.recovery_vault_extra_tags

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

  logs_destinations_ids   = coalescelist(var.backup_logs_destinations_ids, local.logs_destinations_ids)
  logs_categories         = var.backup_logs_categories
  logs_metrics_categories = var.backup_logs_metrics_categories
  logs_retention_days     = var.backup_logs_retention_days

  custom_diagnostic_settings_name = var.backup_custom_diagnostic_settings_name
}

module "automation_account" {
  source = "./modules/automation-account"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  use_caf_naming                 = var.use_caf_naming
  name_prefix                    = var.name_prefix
  name_suffix                    = var.name_suffix
  custom_automation_account_name = var.custom_automation_account_name

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
  logs_retention_days     = var.automation_logs_retention_days

  custom_diagnostic_settings_name = var.automation_custom_diagnostic_settings_name
}

module "update_management" {
  source = "./modules/update-management"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  use_caf_naming = var.use_caf_naming
  name_prefix    = try(coalesce(var.update_management_name_prefix, var.name_prefix), "")
  name_suffix    = var.name_suffix

  automation_account_name    = module.automation_account.automation_account_name
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

module "vm_monitoring" {
  source = "./modules/vm-monitoring"

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

module "update_management_center" {
  for_each = toset(var.update_center_enabled ? ["enabled"] : [])
  source   = "./modules/update-center"

  environment         = var.environment
  stack               = var.stack
  location            = var.location
  resource_group_name = var.resource_group_name

  auto_assessment_enabled    = var.update_center_periodic_assessment_enabled
  auto_assessment_scopes     = var.update_center_periodic_assessment_scopes
  auto_assessment_exclusions = var.update_center_periodic_assessment_exclusions

  maintenance_configurations = var.update_center_maintenance_configurations
}


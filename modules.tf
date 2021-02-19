module "azure-backup" {
  source = "./modules/backup"

  client_name    = var.client_name
  location       = var.location
  location_short = var.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix
  extra_tags          = var.extra_tags

  recovery_vault_custom_name = var.recovery_vault_custom_name
  recovery_vault_sku         = var.recovery_vault_sku
  recovery_vault_extra_tags  = var.recovery_vault_extra_tags

  vm_backup_policy_custom_name = var.vm_backup_policy_custom_name
  vm_backup_policy_timezone    = var.vm_backup_policy_timezone
  vm_backup_policy_time        = var.vm_backup_policy_time
  vm_backup_policy_retention   = var.vm_backup_policy_retention

  file_share_backup_policy_custom_name = var.file_share_backup_policy_custom_name
  file_share_backup_policy_timezone    = var.file_share_backup_policy_timezone
  file_share_backup_policy_time        = var.file_share_backup_policy_time
  file_share_backup_policy_retention   = var.file_share_backup_policy_retention

  diagnostics_settings_enabled = var.diagnostics_settings_enabled

  log_enabled    = var.log_enabled
  log_categories = var.log_categories

  log_retention_in_days              = var.log_retention_in_days
  log_analytics_workspace_id         = var.log_analytics_workspace_id
  log_storage_account_id             = var.log_storage_account_id
  log_eventhub_authorization_rule_id = var.log_eventhub_authorization_rule_id

}

module "automation-account" {
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

  custom_automation_account_name = var.custom_automation_account_name
  law_resource_group_name        = var.law_resource_group_name
  log_analytics_workspace_id     = var.log_analytics_workspace_id

}

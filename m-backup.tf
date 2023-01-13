module "backup" {
  source = "./modules/backup"

  count = var.backup_fileshare_enabled || var.backup_vm_enabled || var.backup_postgresql_enabled ? 1 : 0

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

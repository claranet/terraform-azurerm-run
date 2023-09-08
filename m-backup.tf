module "backup" {
  source = "./modules/backup"

  count = (
    var.backup_file_share_enabled
    || var.backup_vm_enabled
    || var.backup_postgresql_enabled
    || var.backup_managed_disk_enabled
    || var.backup_storage_blob_enabled ? 1 : 0
  )

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

  backup_vault_custom_name            = var.backup_vault_custom_name
  backup_vault_datastore_type         = var.backup_vault_datastore_type
  backup_vault_geo_redundancy_enabled = var.backup_vault_geo_redundancy_enabled
  backup_vault_identity_type          = var.backup_vault_identity_type
  backup_vault_extra_tags             = var.backup_vault_extra_tags

  backup_vm_enabled                = var.backup_vm_enabled
  vm_backup_policy_custom_name     = var.vm_backup_policy_custom_name
  vm_backup_policy_timezone        = var.vm_backup_policy_timezone
  vm_backup_policy_frequency       = var.vm_backup_policy_frequency
  vm_backup_policy_time            = var.vm_backup_policy_time
  vm_backup_policy_type            = var.vm_backup_policy_type
  vm_backup_daily_policy_retention = var.vm_backup_daily_policy_retention
  vm_backup_weekly_retention       = var.vm_backup_weekly_retention
  vm_backup_monthly_retention      = var.vm_backup_monthly_retention
  vm_backup_yearly_retention       = var.vm_backup_yearly_retention

  backup_file_share_enabled                = var.backup_file_share_enabled
  file_share_backup_policy_custom_name     = var.file_share_backup_policy_custom_name
  file_share_backup_policy_timezone        = var.file_share_backup_policy_timezone
  file_share_backup_policy_frequency       = var.file_share_backup_policy_frequency
  file_share_backup_policy_time            = var.file_share_backup_policy_time
  file_share_backup_daily_policy_retention = var.file_share_backup_daily_policy_retention
  file_share_backup_weekly_retention       = var.file_share_backup_weekly_retention
  file_share_backup_monthly_retention      = var.file_share_backup_monthly_retention
  file_share_backup_yearly_retention       = var.file_share_backup_yearly_retention

  backup_postgresql_enabled                            = var.backup_postgresql_enabled
  postgresql_backup_policy_custom_name                 = var.postgresql_backup_policy_custom_name
  postgresql_backup_policy_time                        = var.postgresql_backup_policy_time
  postgresql_backup_policy_interval_in_hours           = var.postgresql_backup_policy_interval_in_hours
  postgresql_backup_policy_retention_in_days           = var.postgresql_backup_policy_retention_in_days
  postgresql_backup_daily_policy_retention_in_days     = var.postgresql_backup_daily_policy_retention_in_days
  postgresql_backup_weekly_policy_retention_in_weeks   = var.postgresql_backup_weekly_policy_retention_in_weeks
  postgresql_backup_monthly_policy_retention_in_months = var.postgresql_backup_monthly_policy_retention_in_months

  backup_managed_disk_enabled                          = var.backup_managed_disk_enabled
  managed_disk_backup_policy_custom_name               = var.managed_disk_backup_policy_custom_name
  managed_disk_backup_policy_time                      = var.managed_disk_backup_policy_time
  managed_disk_backup_policy_interval_in_hours         = var.managed_disk_backup_policy_interval_in_hours
  managed_disk_backup_policy_retention_in_days         = var.managed_disk_backup_policy_retention_in_days
  managed_disk_backup_daily_policy_retention_in_days   = var.managed_disk_backup_daily_policy_retention_in_days
  managed_disk_backup_weekly_policy_retention_in_weeks = var.managed_disk_backup_weekly_policy_retention_in_weeks

  backup_storage_blob_enabled                  = var.backup_storage_blob_enabled
  storage_blob_backup_policy_custom_name       = var.storage_blob_backup_policy_custom_name
  storage_blob_backup_policy_retention_in_days = var.storage_blob_backup_policy_retention_in_days

  logs_destinations_ids   = coalescelist(var.backup_logs_destinations_ids, local.logs_destinations_ids)
  logs_categories         = var.backup_logs_categories
  logs_metrics_categories = var.backup_logs_metrics_categories

  custom_diagnostic_settings_name = var.backup_custom_diagnostic_settings_name
}

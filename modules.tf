module "azure-backup" {
  source = "./backup"

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

  vm_backup_policy_custom_name = var.vm_backup_policy_custom_name
  vm_backup_policy_timezone    = var.vm_backup_policy_timezone
  vm_backup_policy_time        = var.vm_backup_policy_time
  vm_backup_policy_retention   = var.vm_backup_policy_retention
}


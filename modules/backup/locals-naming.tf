locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  recovery_vault_name    = coalesce(var.recovery_vault_custom_name, data.azurecaf_name.recovery_vault.result)
  backup_vault_name      = coalesce(var.backup_vault_custom_name, data.azurecaf_name.backup_vault.result)
  vm_policy_name         = coalesce(var.vm_backup_policy_custom_name, "${data.azurecaf_name.recovery_vault.result}-vm-backup-policy")
  file_share_policy_name = coalesce(var.file_share_backup_policy_custom_name, "${data.azurecaf_name.recovery_vault.result}-fileshare-backup-policy")
  pgqsl_policy_name      = coalesce(var.postgresql_backup_policy_custom_name, "${data.azurecaf_name.backup_vault.result}-pgsql-backup-policy")
  blob_policy_name       = coalesce(var.storage_blob_backup_policy_custom_name, "${data.azurecaf_name.backup_vault.result}-blob-backup-policy")
  disk_policy_name       = coalesce(var.managed_disk_backup_policy_custom_name, "${data.azurecaf_name.backup_vault.result}-disk-backup-policy")
}
